// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'वर्कवाइज';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'शुभ दोपहर';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get goodNight => 'शुभ रात्रि';

  @override
  String get mainMenu => 'मुख्य मेनू';

  @override
  String welcomeToApp(String appName) {
    return '$appName में आपका स्वागत है';
  }

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageUpdatedSuccess => 'भाषा सफलतापूर्वक अपडेट की गई।';

  @override
  String get success => 'सफल!';

  @override
  String get done => 'हो गया';

  @override
  String get back => 'वापस';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get signingIn => 'साइन इन किया जा रहा है...';

  @override
  String get loginFailed => 'लॉगिन विफल रहा';

  @override
  String get restoringSession => 'सेशन पुनर्स्थापित किया जा रहा है...';

  @override
  String get forgotPasswordTitle => 'पासवर्ड भूल गए';

  @override
  String get resetPasswordTitle => 'पासवर्ड रीसेट करें';

  @override
  String get resetPasswordDesc =>
      'अपना ईमेल या फ़ोन नंबर दर्ज करें। हम आपकी पहचान सत्यापित करने के लिए एक OTP भेजेंगे।';

  @override
  String get emailOrPhone => 'ईमेल या फ़ोन';

  @override
  String get emailOrPhoneHint => 'अपना ईमेल या फ़ोन नंबर दर्ज करें';

  @override
  String get emailOrPhoneRequired => 'ईमेल या फ़ोन आवश्यक है';

  @override
  String get invalidEmailOrPhone => 'एक वैध ईमेल या फ़ोन दर्ज करें';

  @override
  String get sendResetCode => 'रीसेट कोड भेजें';

  @override
  String get sendingResetCode => 'रीसेट कोड भेजा जा रहा है...';

  @override
  String get codeSent => 'कोड भेजा गया';

  @override
  String get codeSentMessage =>
      'यदि खाता मौजूद है, तो आपको ईमेल या SMS द्वारा OTP प्राप्त होगा।\nकृपया अपना इनबॉक्स या संदेश देखें।';

  @override
  String get verifyOtp => 'OTP सत्यापित करें';

  @override
  String get requestFailed => 'अनुरोध विफल हुआ';

  @override
  String get rememberPassword => 'अपना पासवर्ड याद रखें?';

  @override
  String get secureResetNote =>
      'सुरक्षित पासवर्ड रीसेट • OTP 10 मिनट में समाप्त हो जाएगा';

  @override
  String get verifyResetCode => 'रीसेट कोड सत्यापित करें';

  @override
  String get enterOtpDesc =>
      'हमने आपके ईमेल या फ़ोन पर भेजे गए 6-अंकीय कोड को दर्ज करें';

  @override
  String get otpCode => 'OTP कोड';

  @override
  String get otpRequired => 'OTP आवश्यक है';

  @override
  String get invalidOtp => 'एक वैध अंक OTP दर्ज करें';

  @override
  String get verifyingCode => 'कोड सत्यापित किया जा रहा है...';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get verificationFailed => 'सत्यापन विफल हुआ';

  @override
  String get setNewPassword => 'नया पासवर्ड सेट करें';

  @override
  String resettingFor(String identifier) {
    return 'के लिए रीसेट हो रहा है: $identifier';
  }

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get passwordMinLength => 'पासवर्ड कम से कम 6 वर्ण का होना चाहिए';

  @override
  String get setPassword => 'पासवर्ड सेट करें';

  @override
  String get resettingPassword => 'पासवर्ड रीसेट किया जा रहा है...';

  @override
  String get passwordChanged => 'पासवर्ड बदल गया';

  @override
  String get passwordChangedMessage =>
      'आपका पासवर्ड सफलतापूर्वक अपडेट किया गया है। कृपया अपने नए पासवर्ड के साथ साइन इन करें।';

  @override
  String get backToLogin => 'लॉगिन पर वापस जाएं';

  @override
  String get missingData => 'डेटा गायब है';

  @override
  String get identifierOtpMissing => 'पहचानकर्ता या OTP गायब है।';

  @override
  String get resetFailed => 'रीसेट विफल हुआ';

  @override
  String get enterYourWorkspace => 'अपना कार्यक्षेत्र दर्ज करें';

  @override
  String get subdomainDescription => 'workwise.africa पर आपके संगठन का सबडोमेन';

  @override
  String get subdomain => 'सबडोमेन';

  @override
  String get subdomainHint => 'yourcompany';

  @override
  String get workspaceRequired => 'कार्यक्षेत्र सबडोमेन आवश्यक है';

  @override
  String get enterSubdomainOnly => 'केवल सबडोमेन दर्ज करें, पूरा डोमेन नहीं';

  @override
  String get useLettersNumbersHyphens =>
      'केवल अक्षर, संख्या, या हाइफ़न का उपयोग करें';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get termsAgreement =>
      'जारी रखते समय, आप वर्कवाइज सेवा की शर्तों से सहमत होते हैं।';

  @override
  String get signInToWorkspace => 'अपने कार्यक्षेत्र में साइन इन करें';

  @override
  String get couldNotConnect =>
      'कार्यक्षेत्र से कनेक्ट नहीं हो पाया। कृपया जांचकर फिर प्रयास करें।';

  @override
  String get profileTitle => 'मेरा प्रोफ़ाइल';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get pleaseEnterName => 'कृपया नाम दर्ज करें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get profileUpdatedSuccess =>
      'आपकी प्रोफ़ाइल सफलतापूर्वक अपडेट की गई है।';

  @override
  String get updateFailed => 'अपडेट विफल हुआ';

  @override
  String get tryAgain => 'फिर से प्रयास करें';

  @override
  String memberSince(String date) {
    return 'सदस्य since $date';
  }

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get sound => 'ध्वनि';

  @override
  String get switchWorkspace => 'कार्यक्षेत्र बदलें';

  @override
  String get changeWorkspaceSubtitle => 'कार्यक्षेत्र / किरायेदार बदलें';

  @override
  String get switchWorkspaceMessage =>
      'कार्यक्षेत्र बदलने से आपको साइन आउट किया जाएगा और एक नया कार्यक्षेत्र URL दर्ज करना होगा। जारी रखें?';

  @override
  String get switchButton => 'बदलें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutMessage =>
      'क्या आप वाकई अपने खाते से साइन आउट करना चाहते हैं?';

  @override
  String get shareApp => 'वर्कवाइज साझा करें';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get changePasswordSubtitle => 'नियमित रूप से अपना पासवर्ड अपडेट करें';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get passwordUpdated => 'पासवर्ड अपडेट किया गया';

  @override
  String get passwordUpdatedMessage =>
      'आपका पासवर्ड सफलतापूर्वक बदल दिया गया है।';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get manageNotifications => 'अपनी सूचनाओं को प्रबंधित करें';

  @override
  String get updateProfilePhoto => 'प्रोफ़ाइल फ़ोटो अपडेट करें';

  @override
  String get choosePhotoFromDevice => 'अपने डिवाइस से फ़ोटो चुनें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get pickImageFromPhotos => 'अपनी तस्वीरों से छवि चुनें';

  @override
  String get removeSelectedPhoto => 'चयनित फ़ोटो हटाएँ';

  @override
  String get searchModulesHint => 'मॉड्यूल खोजें...';

  @override
  String get apps => 'ऐप्स';

  @override
  String get noModulesFound => 'कोई मॉड्यूल नहीं मिला';

  @override
  String get tryAdjustingSearch => 'अपना खोज समायोजित करने का प्रयास करें';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String manageModule(String module) {
    return '$module प्रबंधित करें';
  }

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get markAllRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get failedToLoad => 'लोड करने में विफल हुआ';

  @override
  String get retry => 'पुन: प्रयास करें';

  @override
  String get noNotificationsToShow => 'दिखाने के लिए कोई सूचनाएँ नहीं हैं।';

  @override
  String get delete => 'हटाएँ';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get justNow => 'अभी';

  @override
  String minutesAgo(int count) {
    return '${count}m पहले';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h पहले';
  }

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(int count) {
    return '${count}d पहले';
  }

  @override
  String get timeJustNow => 'अब';

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
