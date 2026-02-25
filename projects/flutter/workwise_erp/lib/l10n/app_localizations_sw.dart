// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'Workwise';

  @override
  String get selectLanguage => 'Chagua Lugha';

  @override
  String get languageUpdatedSuccess => 'Lugha imebadilishwa.';

  @override
  String get success => 'Imefanikiwa!';

  @override
  String get done => 'Sawa';

  @override
  String get back => 'Rudi';

  @override
  String get welcomeBack => 'Karibu Tena';

  @override
  String get emailAddress => 'Anwani ya Barua Pepe';

  @override
  String get emailRequired => 'Barua pepe inahitajika';

  @override
  String get password => 'Nywila';

  @override
  String get passwordRequired => 'Nywila inahitajika';

  @override
  String get forgotPassword => 'Umesahau Nywila?';

  @override
  String get signIn => 'Ingia';

  @override
  String get signingIn => 'Ingia...';

  @override
  String get loginFailed => 'Imeshindwa kuingia';

  @override
  String get restoringSession => 'Kurejesha kikao...';

  @override
  String get forgotPasswordTitle => 'Umesahau Nywila';

  @override
  String get resetPasswordTitle => 'Weka Upya Nywila';

  @override
  String get resetPasswordDesc =>
      'Weka barua pepe au nambari ya simu. Tutatuma OTP kuthibitisha utambulisho wako.';

  @override
  String get emailOrPhone => 'Barua Pepe au Simu';

  @override
  String get emailOrPhoneHint => 'Weka barua pepe au nambari ya simu';

  @override
  String get emailOrPhoneRequired => 'Barua pepe au simu inahitajika';

  @override
  String get invalidEmailOrPhone => 'Weka barua pepe au simu sahihi';

  @override
  String get sendResetCode => 'Tuma Msimbo wa Kuweka Upya';

  @override
  String get sendingResetCode => 'Inatuma msimbo...';

  @override
  String get codeSent => 'Msimbo Umetumwa';

  @override
  String get codeSentMessage =>
      'Kama akaunti ipo, utapokea OTP kwa barua pepe au SMS.\nTafadhali angalia kisanduku chako.';

  @override
  String get verifyOtp => 'Thibitisha OTP';

  @override
  String get requestFailed => 'Ombi Limeshindwa';

  @override
  String get rememberPassword => 'Unakumbuka nywila yako?';

  @override
  String get secureResetNote =>
      'Kuweka upya nywila kwa usalama • OTP itaisha baada ya dakika 10';

  @override
  String get verifyResetCode => 'Thibitisha Msimbo wa Kuweka Upya';

  @override
  String get enterOtpDesc =>
      'Weka msimbo wa tarakimu 6 tuliotuma kwa barua pepe au simu yako';

  @override
  String get otpCode => 'Msimbo wa OTP';

  @override
  String get otpRequired => 'OTP inahitajika';

  @override
  String get invalidOtp => 'Weka OTP sahihi ya nambari';

  @override
  String get verifyingCode => 'Inathibitisha msimbo...';

  @override
  String get verify => 'Thibitisha';

  @override
  String get verificationFailed => 'Uthibitisho umeshindwa';

  @override
  String get setNewPassword => 'Weka Nywila Mpya';

  @override
  String resettingFor(String identifier) {
    return 'Kuweka upya kwa: $identifier';
  }

  @override
  String get newPassword => 'Nywila mpya';

  @override
  String get confirmPassword => 'Thibitisha nywila';

  @override
  String get passwordsDoNotMatch => 'Nywila hazifanani';

  @override
  String get passwordMinLength => 'Nywila lazima iwe na angalau herufi 6';

  @override
  String get setPassword => 'Weka nywila';

  @override
  String get resettingPassword => 'Inaweka upya nywila...';

  @override
  String get passwordChanged => 'Nywila imebadilishwa';

  @override
  String get passwordChangedMessage =>
      'Nywila yako imebadilishwa. Tafadhali ingia na nywila yako mpya.';

  @override
  String get backToLogin => 'Rudi Kuingia';

  @override
  String get missingData => 'Data inakosekana';

  @override
  String get identifierOtpMissing => 'Kitambulisho au OTP inakosekana.';

  @override
  String get resetFailed => 'Kuweka upya kumeshindwa';

  @override
  String get enterYourWorkspace => 'Weka eneo lako la kazi';

  @override
  String get subdomainDescription =>
      'Subdomain ya shirika lako kwenye workwise.africa';

  @override
  String get subdomain => 'Subdomain';

  @override
  String get subdomainHint => 'shirikalakolako';

  @override
  String get workspaceRequired => 'Subdomain ya eneo la kazi inahitajika';

  @override
  String get enterSubdomainOnly => 'Weka subdomain tu, si domain nzima';

  @override
  String get useLettersNumbersHyphens => 'Tumia herufi, nambari au kistari tu';

  @override
  String get continueButton => 'Endelea';

  @override
  String get termsAgreement =>
      'Kwa kuendelea, unakubali Masharti ya Huduma ya Workwise.';

  @override
  String get signInToWorkspace => 'Ingia kwenye eneo lako la kazi';

  @override
  String get couldNotConnect =>
      'Haikuweza kuunganisha eneo la kazi. Tafadhali angalia na ujaribu tena.';
}
