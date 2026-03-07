import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../storage/token_local_data_source.dart';

/// Intercepts HTTP errors and converts them into user-friendly snack-bars.
///
/// Behaviour by status code:
/// - **401** (and request was authenticated): clears the stored token,
///   shows a "session expired" message, and navigates the user back to the
///   login screen (removing all routes from the back-stack).
/// - **403**: shows a "no permission" message and lets the error propagate so
///   the feature layer can react if needed.
/// - **Connection errors / timeouts**: shows a "no internet" message.
/// - **5xx**: shows a generic "server error" message.
///
/// All other errors are forwarded unchanged.
class UnauthorizedInterceptor extends Interceptor {
  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldMessengerState> _messengerKey;
  final TokenLocalDataSource _tokenStorage;

  UnauthorizedInterceptor({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldMessengerState> messengerKey,
    required TokenLocalDataSource tokenStorage,
  }) : _navigatorKey = navigatorKey,
       _messengerKey = messengerKey,
       _tokenStorage = tokenStorage;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    // Requests that opted out of auth (e.g. login) should not trigger a
    // session-expired redirect even if the server returns 401.
    final isAuthOptOut = err.requestOptions.extra['noAuth'] == true;

    if (status == 401 && !isAuthOptOut) {
      await _tokenStorage.deleteToken();
      _showSnackBar('Your session has expired. Please log in again.');
      _navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (_) => false);
    } else if (status == 403) {
      _showSnackBar('You don\'t have permission to perform this action.');
    } else if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      _showSnackBar(
        'No internet connection. Check your network and try again.',
      );
    } else if (status != null && status >= 500) {
      _showSnackBar('Server error. Please try again later.');
    }

    handler.next(err);
  }

  void _showSnackBar(String message) {
    _messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }
}
