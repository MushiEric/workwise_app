import 'package:flutter/widgets.dart';

import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import '../pages/forgot_password_page.dart';
import '../pages/verify_forgot_password_otp_page.dart';
import '../pages/change_password_page.dart';
import '../pages/change_password_using_otp_page.dart';
import '../pages/profile_page.dart';
import '../../../tenant/presentation/pages/workspace_entry_page.dart';

abstract class AuthRoutes {
  static const workspace = '/workspace';
  static const splash = '/splash';
  static const login = '/';
  static const forgotPassword = '/forgot-password';
  static const verifyOtp = '/forgot-password/verify';
  static const changePassword = '/forgot-password/change';
  static const changePasswordPage = '/profile/change-password';
  static const profile = '/profile';
}

class AuthRouter {
  static Map<String, WidgetBuilder> get routes => {
    AuthRoutes.workspace: (_) => const WorkspaceEntryScreen(),
    AuthRoutes.splash: (_) => const SplashPage(),
    AuthRoutes.login: (_) => const LoginPage(),
    AuthRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
    AuthRoutes.verifyOtp: (_) => const VerifyForgotPasswordOtpPage(),
    AuthRoutes.changePassword: (_) => const ChangePasswordUsingOtpPage(),
    AuthRoutes.changePasswordPage: (_) => const ChangePasswordPage(),
    AuthRoutes.profile: (_) => const ProfilePage(),
  };
}
