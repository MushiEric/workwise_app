import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:workwise_erp/core/constants/api_constant.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/exceptions_extended.dart';
import '../models/user_model.dart';

/// Returns true when [url] is the server's built-in default avatar placeholder
/// (e.g. "/storage/avatar.png"). That file does not exist on the staging/production
/// server, so we treat it as "no avatar" and let the UI fall back to initials.
bool _isDefaultAvatarPlaceholder(String url) {
  // Match both the bare filename and any full URL ending with the default path.
  return url == 'avatar.png' ||
      url.endsWith('/avatar.png') ||
      url.endsWith('/storage/avatar.png');
}

String _normalizeAvatarPath(String url) {
  // The backend may return "/profile/profile/..." on /getProfile.
  // Normalize this consistently to /storage/... so image loading works.
  if (url.startsWith('/profile/')) {
    return url.replaceFirst('/profile/', '/storage/');
  }
  return url;
}

Future<String?> _resolveAvatarUrl(Dio client, String url) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return null;

  // Absolute URL (S3 or direct path) should be used as-is.
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  // Strip leading slash for the service API request body.
  final lookupUrl = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;

  if (lookupUrl.isNotEmpty) {
    try {
      final resp = await client.post(
        '/getFile',
        data: {'url': lookupUrl},
        options: Options(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (resp.data is Map<String, dynamic>) {
        final path = resp.data['path'];
        if (path is String && path.isNotEmpty) {
          return path;
        }
      }
    } catch (_) {
      // ignore and fallback to local path normalization below.
    }
  }

  // Local/legacy fallback path.
  if (trimmed.startsWith('/profile/')) {
    return trimmed.replaceFirst('/profile/', '/storage/');
  }

  if (trimmed.startsWith('/')) {
    final base = ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return '$base$trimmed';
  }

  if (!trimmed.contains('://') && trimmed.contains('/')) {
    final base = ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return '$base/$trimmed';
  }

  return trimmed;
}

class AuthRemoteDataSource {
  final Dio client;
  AuthRemoteDataSource(this.client);

  /// GET /getProfile — returns the authenticated user's full profile including avatar URL.
  Future<UserModel> fetchCurrentUser() async {
    try {
      final resp = await client.get('/getProfile');

      // resp.data may sometimes be a Map, or (unexpectedly) a String that
      // contains JSON. Be defensive and try to parse string responses.
      final raw = resp.data;
      Map<String, dynamic>? dataMap;

      if (raw is Map<String, dynamic>) {
        // /getProfile wraps the user object inside { "status": ..., "data": { ... } }
        // Unwrap if the envelope is present, otherwise fall back to the raw map.
        final inner = raw['data'];
        dataMap = (inner is Map<String, dynamic>) ? inner : raw;
      } else if (raw is String) {
        try {
          final decoded = json.decode(raw);
          if (decoded is Map<String, dynamic>) {
            final inner = decoded['data'];
            dataMap = (inner is Map<String, dynamic>) ? inner : decoded;
          }
        } catch (_) {
          // ignore and fallthrough to error
        }
      }

      if (dataMap == null) {
        throw ServerException('Invalid server response when fetching user');
      }

      // /getProfile may supply `profile` and/or `avatar` fields.
      // Resolve the exact image URL via /getFile for dev/staging mixed storage paths.
      final profileUrl = dataMap['profile'];
      final avatarVal = dataMap['avatar'];

      String? resolvedAvatar;

      if (profileUrl is String &&
          profileUrl.isNotEmpty &&
          !_isDefaultAvatarPlaceholder(profileUrl)) {
        final url = await _resolveAvatarUrl(client, profileUrl);
        if (url != null && url.isNotEmpty) {
          resolvedAvatar = url;
          dataMap = Map<String, dynamic>.from(dataMap)..['profile'] = url;
        }
      }

      if ((resolvedAvatar == null || resolvedAvatar.isEmpty) &&
          avatarVal is String &&
          avatarVal.isNotEmpty &&
          !_isDefaultAvatarPlaceholder(avatarVal)) {
        final url = await _resolveAvatarUrl(client, avatarVal);
        if (url != null && url.isNotEmpty) {
          resolvedAvatar = url;
        }
      }

      if (resolvedAvatar != null && resolvedAvatar.isNotEmpty) {
        dataMap = Map<String, dynamic>.from(dataMap)
          ..['avatar'] = resolvedAvatar;
      } else if (avatarVal is String &&
          _isDefaultAvatarPlaceholder(avatarVal)) {
        dataMap = Map<String, dynamic>.from(dataMap)..['avatar'] = null;
      } else if (avatarVal is String && avatarVal.isNotEmpty) {
        dataMap = Map<String, dynamic>.from(dataMap)
          ..['avatar'] = _normalizeAvatarPath(avatarVal);
      } else if (profileUrl is String && profileUrl.isNotEmpty) {
        dataMap = Map<String, dynamic>.from(dataMap)
          ..['avatar'] = _normalizeAvatarPath(profileUrl);
      }

      // normalize older backend responses that use `type` (string/number)
      // as the user's role — convert `type` -> `roles` so `UserModel` can
      // deserialize into `roles: List<RoleModel>`.
      if ((dataMap['roles'] == null ||
              (dataMap['roles'] is List &&
                  (dataMap['roles'] as List).isEmpty)) &&
          dataMap.containsKey('type')) {
        final t = dataMap['type'];
        if (t != null) {
          dataMap = Map<String, dynamic>.from(dataMap)
            ..['roles'] = [
              {'name': t.toString()},
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
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Give the server a reasonable window but fail fast to avoid multi-minute waits.
      final resp = await client.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      final raw = resp.data;

      Map<String, dynamic>? data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<'))
          throw ServerException('Server returned HTML (check backend)');
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
        if (st is bool && st == false)
          throw ServerException(data['message']?.toString() ?? 'Login failed');
        if (st is num && st == 0)
          throw ServerException(data['message']?.toString() ?? 'Login failed');
      }
      if (data.containsKey('success') &&
          (data['success'] is bool) &&
          data['success'] == false) {
        throw ServerException(data['message']?.toString() ?? 'Login failed');
      }

      if (data.containsKey('user') && data['user'] is Map) {
        userMap = Map<String, dynamic>.from(data['user'] as Map);
        token =
            data['token'] as String? ??
            data['access_token'] as String? ??
            data['api_token'] as String?;
      } else if (data.containsKey('users') && data['users'] is Map) {
        // some backends use a plural 'users' wrapper
        userMap = Map<String, dynamic>.from(data['users'] as Map);
        token =
            data['token'] as String? ??
            data['access_token'] as String? ??
            data['api_token'] as String?;
      } else if (data.containsKey('data') && data['data'] is Map) {
        // some APIs wrap under `data`
        userMap = Map<String, dynamic>.from(data['data'] as Map);
        token =
            data['token'] as String? ??
            data['api_token'] as String? ??
            data['access_token'] as String?;
      } else {
        // fallback: top-level fields may include token and user fields mixed
        userMap = Map<String, dynamic>.from(data);
        token =
            data['api_token'] as String? ??
            data['token'] as String? ??
            data['access_token'] as String? ??
            (userMap['api_token'] as String?);
      }

      if (token != null && token.isNotEmpty) {
        userMap['api_token'] = token;
      }

      // Normalize `type` -> `roles` when backend returns a single `type` field
      // instead of an array of roles.
      if ((userMap['roles'] == null ||
              (userMap['roles'] is List &&
                  (userMap['roles'] as List).isEmpty)) &&
          userMap.containsKey('type')) {
        final t = userMap['type'];
        if (t != null) {
          userMap['roles'] = [
            {'name': t.toString()},
          ];
        }
      }

      // If server returned a token but the POST response does not look like a user
      // object (for example it contains only status/message/token), try to fetch
      // the full user using the token — improves robustness for backends that
      // return token-only on login.
      final bool looksLikeUser =
          userMap.containsKey('id') ||
          userMap.containsKey('email') ||
          userMap.containsKey('name');

      // If the response contains neither a token nor user-like fields, treat as failure
      if (!looksLikeUser && (token == null || token.isEmpty)) {
        final msg = data['message'] as String? ?? 'Login failed';
        throw ServerException(msg);
      }

      if (!looksLikeUser && token != null && token.isNotEmpty) {
        try {
          // Use a short timeout — this is an auxiliary call during login;
          // if it hangs and gets retried the login appears frozen for minutes.
          final userResp = await client.get(
            '/user',
            options: Options(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              extra: const {
                '__retry_count': 99,
              }, // disable retries for this call
            ),
          );
          final userRaw = userResp.data;
          Map<String, dynamic>? fetchedMap;
          if (userRaw is Map<String, dynamic>) {
            fetchedMap = userRaw;
          } else if (userRaw is String) {
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

            if ((fetchedMap['roles'] == null ||
                    (fetchedMap['roles'] is List &&
                        (fetchedMap['roles'] as List).isEmpty)) &&
                fetchedMap.containsKey('type')) {
              final t = fetchedMap['type'];
              if (t != null) {
                fetchedMap['roles'] = [
                  {'name': t.toString()},
                ];
              }
            }

            return UserModel.fromJson(fetchedMap);
          }
        } catch (_) {
          // ignore and fallback to returning whatever we have in userMap
        }
      }

      return UserModel.fromJson(userMap);
    } on ServerException {
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
            if (s.startsWith('<'))
              throw ServerException('Server returned HTML (check backend)');
            try {
              final decoded = json.decode(s);
              if (decoded is Map && decoded['message'] != null)
                throw ServerException(decoded['message'].toString());
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
  ///
  /// Returns the `message` field from the backend response (if available).
  Future<String> forgotPassword({
    required String emailOrPhone,
    String? redirectUrl,
  }) async {
    try {
      final payload = <String, dynamic>{'email': emailOrPhone};
      if (redirectUrl != null && redirectUrl.isNotEmpty) {
        payload['redirect_url'] = redirectUrl;
      }

      final response = await client.post('/forgotPassword', data: payload);

      // Some backends return a JSON payload with a `status` field even when the
      // HTTP status code is 200. Treat non-200 `status` codes as errors.
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'];
        final message = data['message']?.toString();

        if (status is int && status != 200) {
          throw ServerException(message ?? 'Server error');
        }

        // Prefer the returned message, fall back to a reasonable default.
        return message ?? 'Password reset initiated.';
      }

      return 'Password reset initiated.';
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message'] as String?)
              : e.message;
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
  Future<void> verifyForgotPasswordOtp({
    required String emailOrPhone,
    required String otp,
  }) async {
    try {
      final payload = {'email': emailOrPhone, 'otp': otp};
      final response = await client.post(
        '/verifyForgotPasswordOtp',
        data: payload,
      );

      // Some backends return a JSON payload with a `status` field even when the
      // HTTP status code is 200. Treat non-200 `status` codes as errors.
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'];
        final message = data['message']?.toString();

        if (status is int && status != 200) {
          throw ServerException(message ?? 'OTP verification failed');
        }
      }

      return;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message'] as String?)
              : e.message;
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
  Future<void> changePasswordUsingOtp({
    required String emailOrPhone,
    required String otp,
    required String password,
  }) async {
    try {
      final payload = {'email': emailOrPhone, 'otp': otp, 'password': password};
      final response = await client.post(
        '/changePasswordUsingOtp',
        data: payload,
      );

      // Some backends return a JSON payload with a `status` field even when the
      // HTTP status code is 200. Treat non-200 `status` codes as errors.
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'];
        final message = data['message']?.toString();

        if (status is int && status != 200) {
          throw ServerException(message ?? 'Password reset failed');
        }
      }

      return;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message'] as String?)
              : e.message;
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

  /// POST /changePasswordAuthenticated
  Future<void> changePasswordAuthenticated({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final payload = {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      final response = await client.post(
        '/changePasswordAuthenticated',
        data: payload,
      );

      // Some backends return a JSON payload with a `status` field even when the
      // HTTP status code is 200. Treat non-200 `status` codes as errors.
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'];
        final message = data['message']?.toString();

        if (status is int && status != 200) {
          throw ServerException(message ?? 'Password change failed');
        }
      }

      return;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message'] as String?)
              : e.message;
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

  /// POST /logout
  Future<void> logout() async {
    try {
      await client.post('/logout');
    } on DioException catch (e) {
      // We still want to clear local session even if server call fails.
      // But propagate an error so the app can log/track it.
      throw ServerException(e.message ?? 'Logout failed');
    } catch (e) {
      throw ServerException('Logout failed: ${e.toString()}');
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> payload) async {
    try {
      final isMultipart =
          payload.values.any((v) => v is MultipartFile) ||
          (payload.containsKey('avatar') &&
              payload['avatar'] is String &&
              (payload['avatar'] as String).startsWith('data:'));
      final resp = await client.post(
        '/user/updateProfile/',
        data: isMultipart ? FormData.fromMap(payload) : payload,
      );
      // backend may return user or {data: user}
      final raw = resp.data;
      Map<String, dynamic>? data;

      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<'))
          throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map<String, dynamic>) data = decoded;
        } catch (_) {
          // fall through
        }
      }

      if (data == null)
        throw ServerException('Invalid server response when updating profile');

      Map<String, dynamic> userMap;
      if (data.containsKey('user') && data['user'] is Map) {
        userMap = Map<String, dynamic>.from(data['user'] as Map);
      } else if (data.containsKey('data') && data['data'] is Map) {
        userMap = Map<String, dynamic>.from(data['data'] as Map);
      } else {
        userMap = Map<String, dynamic>.from(data);
      }

      // Promote `profile` field (full URL) into `avatar`, mirroring the
      // fetchCurrentUser behaviour. The backend stores the avatar as a bare
      // filename in the `avatar` column but exposes the fully-qualified URL
      // in `profile`.
      // Skip the server's default placeholder (avatar.png) which returns 404.
      final profileUrl = userMap['profile'];
      if (profileUrl is String &&
          profileUrl.isNotEmpty &&
          !_isDefaultAvatarPlaceholder(profileUrl)) {
        userMap['avatar'] = profileUrl;
      } else {
        final avatarVal = userMap['avatar'];
        if (avatarVal is String && _isDefaultAvatarPlaceholder(avatarVal)) {
          userMap['avatar'] = null;
        }
      }

      // Normalize `type` -> `roles` when backend returns a single `type` field
      // instead of an array of roles.
      if ((userMap['roles'] == null ||
              (userMap['roles'] is List &&
                  (userMap['roles'] as List).isEmpty)) &&
          userMap.containsKey('type')) {
        final t = userMap['type'];
        if (t != null) {
          userMap['roles'] = [
            {'name': t.toString()},
          ];
        }
      }

      return UserModel.fromJson(userMap);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          if (statusCode == 413) {
            throw ServerException(
              'The image is too large. Please choose a smaller image and try again.',
            );
          }
          // Try to extract a server-provided message before falling back to Dio's
          // technical string (e.g. "Http status error [422]").
          final respData = e.response?.data;
          if (respData is Map && respData['message'] != null) {
            throw ServerException(respData['message'].toString());
          }
          if (respData is String) {
            final s = respData.trim();
            if (!s.startsWith('<')) {
              try {
                final decoded = json.decode(s);
                if (decoded is Map && decoded['message'] != null) {
                  throw ServerException(decoded['message'].toString());
                }
              } catch (_) {}
            }
          }
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is TimeoutException)
        rethrow;
      throw ServerException('Unknown error');
    }
  }

  /// GET /user/getPermission — returns the flat list of permission names for
  /// the currently authenticated user.
  ///
  /// Accepted response shapes:
  ///   • `[{id, name}, ...]`                — array of objects
  ///   • `{data: [{id, name}, ...], ...}`   — wrapped in a data key
  ///   • `{data: ["name1", "name2"], ...}`  — wrapped array of strings
  ///   • `["name1", "name2"]`               — bare array of strings
  ///
  /// Returns an empty list if the request fails so the app degrades gracefully.
  Future<List<String>> fetchPermissions() async {
    try {
      final resp = await client.get('/user/getPermission');
      final raw = resp.data;
      List<dynamic>? items;

      if (raw is List) {
        items = raw;
      } else if (raw is Map<String, dynamic>) {
        final payload =
            raw['data'] ?? raw['permissions'] ?? raw['result'] ?? raw['items'];
        if (payload is List) items = payload;
      }

      if (items == null) return [];

      return items
          .map<String>((e) {
            if (e is String) return e.trim();
            if (e is Map)
              return ((e['name'] ?? e['permission'] ?? '') as Object)
                  .toString()
                  .trim();
            return '';
          })
          .where((n) => n.isNotEmpty)
          .toList();
    } catch (_) {
      // Silently degrade — never crash the app because of a missing permission list.
      return [];
    }
  }
}
