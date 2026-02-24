import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/exceptions_extended.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio client;
  AuthRemoteDataSource(this.client);

  /// Example: GET /user
  Future<UserModel> fetchCurrentUser() async {
    try {
      final resp = await client.get('/user');

      // resp.data may sometimes be a Map, or (unexpectedly) a String that
      // contains JSON. Be defensive and try to parse string responses.
      final raw = resp.data;
      Map<String, dynamic>? dataMap;

      if (raw is Map<String, dynamic>) {
        dataMap = raw;
      } else if (raw is String) {
        // try to decode JSON string responses
        try {
          final decoded = json.decode(raw);
          if (decoded is Map<String, dynamic>) dataMap = decoded;
        } catch (_) {
          // ignore and fallthrough to error
        }
      }

      if (dataMap == null) {
        throw ServerException('Invalid server response when fetching user');
      }

      // normalize older backend responses that use `type` (string/number)
      // as the user's role — convert `type` -> `roles` so `UserModel` can
      // deserialize into `roles: List<RoleModel>`.
      if ((dataMap['roles'] == null || (dataMap['roles'] is List && (dataMap['roles'] as List).isEmpty)) && dataMap.containsKey('type')) {
        final t = dataMap['type'];
        if (t != null) {
          dataMap['roles'] = [
            {
              'name': t.toString(),
            }
          ];
        }
      }

      return UserModel.fromJson(dataMap);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Invalid server response: ${e.toString()}');
    }
  }

  /// POST /login
  Future<UserModel> login({required String email, required String password}) async {
    try {
      // login can be slow on some environments — increase receiveTimeout for this call
      final resp = await client.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(receiveTimeout: const Duration(seconds: 30)),
      );
      final raw = resp.data;

      Map<String, dynamic>? data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map<String, dynamic>) data = decoded;
        } catch (_) {
          // fall through
        }
      }

      if (data == null) {
        throw ServerException('Invalid server response for login');
      }

      // tolerant parsing:
      // - { user: {...}, token: '...'}
      // - { api_token: '...', ...user fields... }
      Map<String, dynamic> userMap = {};
      String? token;

      if (data.containsKey('status')) {
        final st = data['status'];
        if (st is bool && st == false) throw ServerException(data['message']?.toString() ?? 'Login failed');
        if (st is num && st == 0) throw ServerException(data['message']?.toString() ?? 'Login failed');
      }
      if (data.containsKey('success') && (data['success'] is bool) && data['success'] == false) {
        throw ServerException(data['message']?.toString() ?? 'Login failed');
      }

      if (data.containsKey('user') && data['user'] is Map) {
        userMap = Map<String, dynamic>.from(data['user'] as Map);
        token = data['token'] as String? ?? data['access_token'] as String? ?? data['api_token'] as String?;
      } else if (data.containsKey('users') && data['users'] is Map) {
        // some backends use a plural 'users' wrapper
        userMap = Map<String, dynamic>.from(data['users'] as Map);
        token = data['token'] as String? ?? data['access_token'] as String? ?? data['api_token'] as String?;
      } else if (data.containsKey('data') && data['data'] is Map) {
        // some APIs wrap under `data`
        userMap = Map<String, dynamic>.from(data['data'] as Map);
        token = data['token'] as String? ?? data['api_token'] as String? ?? data['access_token'] as String?;
      } else {
        // fallback: top-level fields may include token and user fields mixed
        userMap = Map<String, dynamic>.from(data);
        token = data['api_token'] as String? ?? data['token'] as String? ?? data['access_token'] as String? ?? (userMap['api_token'] as String?);
      }

      if (token != null && token.isNotEmpty) {
        userMap['api_token'] = token;
      }

      // Normalize `type` -> `roles` when backend returns a single `type` field
      // instead of an array of roles.
      if ((userMap['roles'] == null || (userMap['roles'] is List && (userMap['roles'] as List).isEmpty)) && userMap.containsKey('type')) {
        final t = userMap['type'];
        if (t != null) {
          userMap['roles'] = [
            {
              'name': t.toString(),
            }
          ];
        }
      }

      // If server returned a token but the POST response does not look like a user
      // object (for example it contains only status/message/token), try to fetch
      // the full user using the token — improves robustness for backends that
      // return token-only on login.
      final bool looksLikeUser = userMap.containsKey('id') || userMap.containsKey('email') || userMap.containsKey('name');

      // If the response contains neither a token nor user-like fields, treat as failure
      if (!looksLikeUser && (token == null || token.isEmpty)) {
        final msg = data['message'] as String? ?? 'Login failed';
        throw ServerException(msg);
      }

      if (!looksLikeUser && token != null && token.isNotEmpty) {
        try {
          final userResp = await client.get('/user');
          final userRaw = userResp.data;
          Map<String, dynamic>? fetchedMap;
          if (userRaw is Map<String, dynamic>) fetchedMap = userRaw;
          else if (userRaw is String) {
            final s = userRaw.trim();
            if (!s.startsWith('<')) {
              try {
                final decoded = json.decode(s);
                if (decoded is Map<String, dynamic>) fetchedMap = decoded;
              } catch (_) {}
            }
          }
          if (fetchedMap != null) {
            fetchedMap['api_token'] = fetchedMap['api_token'] ?? token;
            return UserModel.fromJson(fetchedMap);
          }
        } catch (_) {
          // ignore and fallback to returning whatever we have in userMap
        }
      }

      return UserModel.fromJson(userMap);
    } on ServerException catch (e) {
      // allow explicit ServerException to bubble up unchanged
      rethrow;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final respData = e.response?.data;
          if (respData is Map && respData['message'] != null) {
            throw ServerException(respData['message'].toString());
          }
          if (respData is String) {
            final s = respData.trim();
            if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
            try {
              final decoded = json.decode(s);
              if (decoded is Map && decoded['message'] != null) throw ServerException(decoded['message'].toString());
            } catch (_) {}
          }
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  /// POST /forgotPassword
  Future<void> forgotPassword({required String emailOrPhone, String? redirectUrl}) async {
    try {
      final payload = <String, dynamic>{'email': emailOrPhone};
      if (redirectUrl != null && redirectUrl.isNotEmpty) payload['redirect_url'] = redirectUrl;
      await client.post('/forgotPassword', data: payload);
      return;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic> ? (e.response?.data['message'] as String?) : e.message;
          throw ServerException(message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  /// POST /verifyForgotPasswordOtp
  Future<void> verifyForgotPasswordOtp({required String emailOrPhone, required String otp}) async {
    try {
      final payload = {'email': emailOrPhone, 'otp': otp};
      await client.post('/verifyForgotPasswordOtp', data: payload);
      return;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic> ? (e.response?.data['message'] as String?) : e.message;
          throw ServerException(message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  /// POST /changePasswordUsingOtp
  Future<void> changePasswordUsingOtp({required String emailOrPhone, required String otp, required String password}) async {
    try {
      final payload = {'email': emailOrPhone, 'otp': otp, 'password': password};
      await client.post('/changePasswordUsingOtp', data: payload);
      return;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic> ? (e.response?.data['message'] as String?) : e.message;
          throw ServerException(message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  /// POST /user/updateProfile/
  /// Automatically uses multipart/form-data when [payload] contains a [MultipartFile].
  Future<UserModel> updateProfile(Map<String, dynamic> payload) async {
    try {
      final dynamic requestData = payload.values.any((v) => v is MultipartFile)
          ? FormData.fromMap(payload)
          : payload;
      final resp = await client.post('/user/updateProfile/', data: requestData);
      // backend may return user or {data: user}
      final raw = resp.data;
      Map<String, dynamic>? data;

      if (raw is Map<String, dynamic>) data = raw;
      else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map<String, dynamic>) data = decoded;
        } catch (_) {
          // fall through
        }
      }

      if (data == null) throw ServerException('Invalid server response when updating profile');

      if (data.containsKey('user')) return UserModel.fromJson(Map<String, dynamic>.from(data['user'] as Map));
      if (data.containsKey('data')) return UserModel.fromJson(Map<String, dynamic>.from(data['data'] as Map));
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error');
    }
  }
}

