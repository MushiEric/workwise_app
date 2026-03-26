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
  String get goodMorning => 'Habari za asubuhi';

  @override
  String get goodAfternoon => 'Habari za mchana';

  @override
  String get goodEvening => 'Habari za jioni';

  @override
  String get goodNight => 'Usiku mwema';

  @override
  String get mainMenu => 'Menyu Kuu';

  @override
  String welcomeToApp(String appName) {
    return 'Karibu $appName';
  }

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
  String get passwordHint => 'Ingiza Nywila yako';

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
  String get currentPassword => 'Nywila ya sasa';

  @override
  String get enterCurrentPassword => 'Weka nywila ya sasa';

  @override
  String get enterNewPassword => 'Weka nywila mpya';

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

  @override
  String get profileTitle => 'Wasifu Wangu';

  @override
  String get personalInformation => 'Taarifa za Kibinafsi';

  @override
  String get fullName => 'Jina Kamili';

  @override
  String get phoneNumber => 'Nambari ya Simu';

  @override
  String get pleaseEnterName => 'Tafadhali ingiza jina';

  @override
  String get saveChanges => 'Hifadhi Mabadiliko';

  @override
  String get profileUpdatedSuccess => 'Wasifu wako umesasishwa kwa mafanikio.';

  @override
  String get updateFailed => 'Sasisha Imeshindwa';

  @override
  String get tryAgain => 'Jaribu Tena';

  @override
  String memberSince(String date) {
    return 'Mwanachama tangu $date';
  }

  @override
  String get darkMode => 'Hali Nyeusi';

  @override
  String get language => 'Lugha';

  @override
  String get sound => 'Sauti';

  @override
  String get switchWorkspace => 'Badilisha Eneo la Kazi';

  @override
  String get changeWorkspaceSubtitle => 'Badilisha eneo la kazi / mkanganyiko';

  @override
  String get switchWorkspaceMessage =>
      'Kubadilisha eneo la kazi kutakusajilisha nje na kuhitaji URL mpya. Endelea?';

  @override
  String get switchButton => 'Badilisha';

  @override
  String get signOut => 'Toka';

  @override
  String get signOutMessage =>
      'Je, una uhakika unataka kutoka kwenye akaunti yako?';

  @override
  String get termsOfService => 'Masharti ya Huduma';

  @override
  String get termsOfServiceSubtitle => 'Soma masharti na hali zetu';

  @override
  String get privacyPolicy => 'Sera ya Faragha';

  @override
  String get privacyPolicySubtitle => 'Jinsi tunavyolinda faragha yako';

  @override
  String get shareApp => 'Shiriki Workwise';

  @override
  String get changePassword => 'Badilisha Nenosiri';

  @override
  String get changePasswordSubtitle => 'Sasisha nenosiri lako mara kwa mara';

  @override
  String get confirmNewPassword => 'Thibitisha Nenosiri Jipya';

  @override
  String get passwordUpdated => 'Nenosiri Imesasishwa';

  @override
  String get passwordUpdatedMessage =>
      'Nenosiri lako limebadilishwa kwa mafanikio. Tafadhali ingia na nenosiri jipya.';

  @override
  String get notificationSettings => 'Mipangilio ya Arifa';

  @override
  String get manageNotifications => 'Simamia arifa zako';

  @override
  String get updateProfilePhoto => 'Sasisha Picha ya Wasifu';

  @override
  String get choosePhotoFromDevice => 'Chagua picha kutoka kwa kifaa chako';

  @override
  String get chooseFromGallery => 'Chagua kutoka Galari';

  @override
  String get pickImageFromPhotos => 'Chagua picha kutoka kwa picha zako';

  @override
  String get removeSelectedPhoto => 'Ondoa Picha Iliyochaguliwa';

  @override
  String get searchModulesHint => 'Tafuta moduli...';

  @override
  String get apps => 'Programu';

  @override
  String get noModulesFound => 'Hakuna moduli iliyopatikana';

  @override
  String get tryAdjustingSearch => 'Jaribu kurekebisha utafutaji wako';

  @override
  String get clearSearch => 'Futa utafutaji';

  @override
  String manageModule(String module) {
    return 'Simamia $module';
  }

  @override
  String get notifications => 'Taarifa';

  @override
  String get markAllRead => 'Weka alama zote kama zilizosomwa';

  @override
  String get failedToLoad => 'Imeshindwa kupakia';

  @override
  String get retry => 'Jaribu tena';

  @override
  String get noNotificationsToShow => 'Hakuna arifa za kuonyesha.';

  @override
  String get delete => 'Futa';

  @override
  String get viewDetails => 'Tazama maelezo';

  @override
  String get justNow => 'Sasa hivi';

  @override
  String minutesAgo(int count) {
    return 'dakika $count zilizopita';
  }

  @override
  String hoursAgo(int count) {
    return 'masaa $count yaliyopita';
  }

  @override
  String get yesterday => 'Jana';

  @override
  String daysAgo(int count) {
    return 'siku $count zilizopita';
  }

  @override
  String get timeJustNow => 'sasa';

  @override
  String timeMinutes(int count) {
    return '${count}d';
  }

  @override
  String timeHours(int count) {
    return '${count}s';
  }

  @override
  String timeDays(int count) {
    return 'siku $count';
  }

  @override
  String get developerOptionsBlockedTitle => 'Tahadhari ya Usalama';

  @override
  String get developerOptionsBlockedMessage =>
      'Tumegundua kuwa Chaguo za Msanidi Programu zimewezeshwa kwenye kifaa chako. Tafadhali zizime ili kulinda data yako na kuendelea kutumia programu ya Workwise salama.';

  @override
  String get exitApp => 'Toka';
}
