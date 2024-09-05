import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StaticText {
  StaticText._();

  static const String appTitle = 'Application de Recherche d\'Emploi';

  static const String forgotPassword = 'Mot de Passe Oublié';

  static const String enterMailPhone =
      'Entrez votre email ou numéro de téléphone, nous vous enverrons un code de vérification';

  static const String invalidPhoneNo = 'Numéro de téléphone invalide !';

  static const String resetPassword = 'Réinitialiser le Mot de Passe';

  static const String welcomeBack = 'Content de vous revoir';

  static const String logIn = 'Connexion';

  static const String registration = 'Inscription ';

  static const String fullName = 'Nom Complet';

  static const String register = 'S\'inscrire';

  static const String resetPasswordFullText =
      'Entrez votre nouveau mot de passe et confirmez-le pour réinitialiser le mot de passe';

  static const String success = 'SUCCÈS';

  static const String verifyCode = 'Vérifier le Code';

  static const String singOut = 'Se Déconnecter';

  static const String applyToJobs = "Connectez-vous. Postulez à des emplois !";

  static const String lookForCandidats = "Connectez-vous. Recherchez des candidats !";

  static const String userNotFound = 'Utilisateur non trouvé';

  static const String email = 'Adresse Email';

  static const String password = 'Mot de Passe';

  static const String confirmPassword = 'Confirmer le Mot de Passe';

  static const String confirmNewPassword = 'Confirmer le Nouveau Mot de Passe';

  static const String newPassword = 'Nouveau Mot de Passe';

  static const String mobileNumber = 'Numéro de Téléphone';

  static const String sendCode = 'Envoyer le Code';

  static const String enterOtpOnPhone =
      'Entrez le code de vérification envoyé à votre email ou numéro de téléphone';

  static const String welcomeBackProfile = 'Content de vous revoir !';

  static const String profileName = 'Nom du Profil';

  static const String searchJobPosition = 'Rechercher un emploi ou un poste';

  static const String featuredJobs = 'Emplois en Vedette';

  static const String browserJobsByDomain = 'Emplois par domaine';

  static const String seeAll = 'Voir tout';

  static const String softwareEngineer = 'Ingénieur Logiciel';

  static const String facebook = 'Facebook';

  static const String popularJobs = 'Emplois Populaires';

  static const String it = 'Informatique';

  static const String fullTime = 'Temps Plein';

  static const String junior = 'Junior';

  static const String california = 'Californie, États-Unis';

  static const String message = 'Messages';

  static const String google = 'Google';

  static const String productManager = 'Chef de Produit';

  static const String searchChat = 'Rechercher un chat ou un message';

  static const String vosJobs = 'Vos annonces de travail';

  static const String vosInternships ="Vos annonces de stage";
}

class ErrorText {
  static const String enterValidName = "Veuillez entrer un nom valide";

  static const String containNumber = "Le mot de passe doit contenir un chiffre";

  static const String upperCase =
      "Le mot de passe doit contenir une lettre majuscule";

  static const String lowerCase =
      "Le mot de passe doit contenir une lettre minuscule";

  static const String specialCharacter =
      "Le mot de passe doit contenir un caractère spécial";

  static const String shortLength =
      "Le mot de passe doit comporter au moins 8 caractères";

  static const String enterValidEmail = 'Veuillez entrer un email valide';

  static const String invalidCredentials = 'Veuillez entrer un email valide';

  static const String weakPassword = 'mot de passe faible';

  static const String operationNotAllowed = 'opération non autorisée';

  static const String emailInUse = 'email déjà utilisé';

  static const String success = 'succès';

  static const String passwordsNotMatch = 'Les mots de passe ne correspondent pas';

  static const String invalidEmail = 'email invalide';

  static const String userNotFound = 'utilisateur non trouvé';

  static const String wrongPassword = 'mot de passe incorrect';

  static const String enterCorrectOtp = 'Veuillez entrer un otp correct';

  static const String emptyEmail = "Le champ email ne peut pas être vide";
}

Future<Map<String, dynamic>?> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString('user');
  
  if (userJson != null) {
    return jsonDecode(userJson) as Map<String, dynamic>;
  }
  
  return null;
}
