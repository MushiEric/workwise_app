// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Workwise';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageUpdatedSuccess => 'Language updated successfully.';

  @override
  String get success => 'Success!';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get restoringSession => 'Restoring session...';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email or phone number. We\'ll send an OTP to verify your identity.';

  @override
  String get emailOrPhone => 'Email or Phone';

  @override
  String get emailOrPhoneHint => 'Enter your email or phone number';

  @override
  String get emailOrPhoneRequired => 'Email or phone is required';

  @override
  String get invalidEmailOrPhone => 'Enter a valid email or phone';

  @override
  String get sendResetCode => 'Send Reset Code';

  @override
  String get sendingResetCode => 'Sending reset code...';

  @override
  String get codeSent => 'Code Sent';

  @override
  String get codeSentMessage =>
      'If an account exists, you will receive an OTP by email or SMS.\nPlease check your inbox or messages.';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get requestFailed => 'Request Failed';

  @override
  String get rememberPassword => 'Remember your password?';

  @override
  String get secureResetNote =>
      'Secure password reset • OTP will expire in 10 minutes';

  @override
  String get verifyResetCode => 'Verify Reset Code';

  @override
  String get enterOtpDesc =>
      'Enter the 6-digit code we sent to your email or phone';

  @override
  String get otpCode => 'OTP code';

  @override
  String get otpRequired => 'OTP is required';

  @override
  String get invalidOtp => 'Enter a valid numeric OTP';

  @override
  String get verifyingCode => 'Verifying code...';

  @override
  String get verify => 'Verify';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get setNewPassword => 'Set New Password';

  @override
  String resettingFor(String identifier) {
    return 'Resetting for: $identifier';
  }

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get setPassword => 'Set password';

  @override
  String get resettingPassword => 'Resetting password...';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get passwordChangedMessage =>
      'Your password was updated successfully. Please sign in with your new password.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get missingData => 'Missing data';

  @override
  String get identifierOtpMissing => 'Identifier or OTP missing.';

  @override
  String get resetFailed => 'Reset failed';

  @override
  String get enterYourWorkspace => 'Enter your workspace';

  @override
  String get subdomainDescription =>
      'Your organization\'s subdomain on workwise.africa';

  @override
  String get subdomain => 'Subdomain';

  @override
  String get subdomainHint => 'yourcompany';

  @override
  String get workspaceRequired => 'Workspace subdomain is required';

  @override
  String get enterSubdomainOnly =>
      'Enter only the subdomain, not the full domain';

  @override
  String get useLettersNumbersHyphens =>
      'Use letters, numbers, or hyphens only';

  @override
  String get continueButton => 'Continue';

  @override
  String get termsAgreement =>
      'By continuing, you agree to Workwise Terms of Service.';

  @override
  String get signInToWorkspace => 'Sign in to your workspace';

  @override
  String get couldNotConnect =>
      'Could not connect to workspace. Please check and try again.';
}
