// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Workwise';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get languageUpdatedSuccess => 'Langue mise à jour avec succès.';

  @override
  String get success => 'Succès!';

  @override
  String get done => 'Terminé';

  @override
  String get back => 'Retour';

  @override
  String get welcomeBack => 'Bienvenue';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signingIn => 'Connexion en cours...';

  @override
  String get loginFailed => 'Échec de connexion';

  @override
  String get restoringSession => 'Restauration de la session...';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordDesc =>
      'Entrez votre adresse e-mail ou numéro de téléphone. Nous enverrons un OTP pour vérifier votre identité.';

  @override
  String get emailOrPhone => 'E-mail ou Téléphone';

  @override
  String get emailOrPhoneHint => 'Entrez votre e-mail ou numéro de téléphone';

  @override
  String get emailOrPhoneRequired => 'E-mail ou téléphone requis';

  @override
  String get invalidEmailOrPhone => 'Entrez un e-mail ou téléphone valide';

  @override
  String get sendResetCode => 'Envoyer le code de réinitialisation';

  @override
  String get sendingResetCode => 'Envoi du code...';

  @override
  String get codeSent => 'Code envoyé';

  @override
  String get codeSentMessage =>
      'Si un compte existe, vous recevrez un OTP par e-mail ou SMS.\nVeuillez vérifier votre boîte de réception.';

  @override
  String get verifyOtp => 'Vérifier l\'OTP';

  @override
  String get requestFailed => 'Demande échouée';

  @override
  String get rememberPassword => 'Vous vous souvenez de votre mot de passe?';

  @override
  String get secureResetNote =>
      'Réinitialisation sécurisée • L\'OTP expirera dans 10 minutes';

  @override
  String get verifyResetCode => 'Vérifier le code de réinitialisation';

  @override
  String get enterOtpDesc =>
      'Entrez le code à 6 chiffres que nous avons envoyé à votre e-mail ou téléphone';

  @override
  String get otpCode => 'Code OTP';

  @override
  String get otpRequired => 'L\'OTP est requis';

  @override
  String get invalidOtp => 'Entrez un OTP numérique valide';

  @override
  String get verifyingCode => 'Vérification du code...';

  @override
  String get verify => 'Vérifier';

  @override
  String get verificationFailed => 'Échec de la vérification';

  @override
  String get setNewPassword => 'Définir un nouveau mot de passe';

  @override
  String resettingFor(String identifier) {
    return 'Réinitialisation pour: $identifier';
  }

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get setPassword => 'Définir le mot de passe';

  @override
  String get resettingPassword => 'Réinitialisation du mot de passe...';

  @override
  String get passwordChanged => 'Mot de passe modifié';

  @override
  String get passwordChangedMessage =>
      'Votre mot de passe a été mis à jour. Veuillez vous connecter avec votre nouveau mot de passe.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get missingData => 'Données manquantes';

  @override
  String get identifierOtpMissing => 'Identifiant ou OTP manquant.';

  @override
  String get resetFailed => 'Échec de la réinitialisation';

  @override
  String get enterYourWorkspace => 'Entrez votre espace de travail';

  @override
  String get subdomainDescription =>
      'Le sous-domaine de votre organisation sur workwise.africa';

  @override
  String get subdomain => 'Sous-domaine';

  @override
  String get subdomainHint => 'votreentreprise';

  @override
  String get workspaceRequired =>
      'Le sous-domaine de l\'espace de travail est requis';

  @override
  String get enterSubdomainOnly =>
      'Entrez uniquement le sous-domaine, pas le domaine complet';

  @override
  String get useLettersNumbersHyphens =>
      'Utilisez des lettres, des chiffres ou des tirets uniquement';

  @override
  String get continueButton => 'Continuer';

  @override
  String get termsAgreement =>
      'En continuant, vous acceptez les Conditions d\'utilisation de Workwise.';

  @override
  String get signInToWorkspace => 'Connectez-vous à votre espace de travail';

  @override
  String get couldNotConnect =>
      'Impossible de se connecter à l\'espace de travail. Veuillez vérifier et réessayer.';
}
