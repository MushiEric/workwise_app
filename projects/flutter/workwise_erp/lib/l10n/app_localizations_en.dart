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
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get goodNight => 'Good Night';

  @override
  String get mainMenu => 'Main Menu';

  @override
  String welcomeToApp(String appName) {
    return 'Welcome to $appName';
  }

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
  String get passwordHint => 'Enter your password';

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
  String get currentPassword => 'Current Password';

  @override
  String get enterCurrentPassword => 'Enter current password';

  @override
  String get enterNewPassword => 'Enter new password';

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

  @override
  String get profileTitle => 'My Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get pleaseEnterName => 'Please enter name';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccess =>
      'Your profile has been updated successfully.';

  @override
  String get updateFailed => 'Update Failed';

  @override
  String get tryAgain => 'Try Again';

  @override
  String memberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get sound => 'Sound';

  @override
  String get switchWorkspace => 'Switch Workspace';

  @override
  String get changeWorkspaceSubtitle => 'Change workspace / tenant';

  @override
  String get switchWorkspaceMessage =>
      'Switching workspace will sign you out and require entering a new workspace URL. Continue?';

  @override
  String get switchButton => 'Switch';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutMessage =>
      'Are you sure you want to sign out of your account?';

  @override
  String get shareApp => 'Share Workwise';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Update your password regularly';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordUpdated => 'Password Updated';

  @override
  String get passwordUpdatedMessage =>
      'Your password has been changed successfully.';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get manageNotifications => 'Manage your notifications';

  @override
  String get updateProfilePhoto => 'Update Profile Photo';

  @override
  String get choosePhotoFromDevice => 'Choose a photo from your device';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get pickImageFromPhotos => 'Pick an image from your photos';

  @override
  String get removeSelectedPhoto => 'Remove Selected Photo';

  @override
  String get searchModulesHint => 'Search modules...';

  @override
  String get apps => 'Apps';

  @override
  String get noModulesFound => 'No modules found';

  @override
  String get tryAdjustingSearch => 'Try adjusting your search';

  @override
  String get clearSearch => 'Clear search';

  @override
  String manageModule(String module) {
    return 'Manage $module';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get retry => 'Retry';

  @override
  String get noNotificationsToShow => 'No notifications to show.';

  @override
  String get delete => 'Delete';

  @override
  String get viewDetails => 'View Details';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get timeJustNow => 'now';

  @override
  String timeMinutes(int count) {
    return '${count}m';
  }

  @override
  String timeHours(int count) {
    return '${count}h';
  }

  @override
  String timeDays(int count) {
    return '${count}d';
  }
}
