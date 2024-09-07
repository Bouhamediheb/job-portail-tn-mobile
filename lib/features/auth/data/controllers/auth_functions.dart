import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_search_app/constants/route_functions.dart';
import 'package:job_search_app/features/auth/presentation/screens/login_screen_recruter.dart';
import '../../../../constants/named_routes.dart';
import '../../../../constants/strings.dart';
import 'validation.dart';
import '../../../widgets/failure_snack_bar.dart';
import '../services/firebase/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthFunctions {
  AuthFunctions._();

  // Function to login user
  static Future<void> loginUser({
  required TextEditingController emailController,
  required TextEditingController passWordController,
  required GlobalKey<FormState> formKey,
  required BuildContext context,
}) async {
  // Remove focus from keyboard
  FocusManager.instance.primaryFocus?.unfocus();
  print('Logging in user');
  print('Email: ${emailController.text}');
  print('Password: ${passWordController.text}');

  // Validation of inputs
  if (formKey.currentState!.validate() == false) {
    return;
  }

  // Use the provided AuthService for authentication
  final response = await AuthService().loginUser(
    email: emailController.text,
    password: passWordController.text,
  );

  if (response != null && response['status'] == true) {
    print(response);
    final String token = response['token'] as String;
    final Map<String, dynamic> user = response['user'] as Map<String, dynamic>;

    // Save token and user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user));
    await prefs.setInt('userId', response['user']['id'] as int);
    await prefs.setString('type', 'seeker');
    print('User ID: ${response['user']['id']}');
    print('User logged in successfully');
    

    emailController.text = passWordController.text = '';
    // Navigate to the main screen
    AppRoute.offNamedUntil(NamedRoutes.mainScreen);
  } else {
    // Handle different error messages returned by the AuthService
    if (response != null) {
      final String message = response['message'] as String;
      if (message.contains('invalid email') || message.contains('user not found')) {
        failureBar('User not found', context);
      } else if (message.contains('wrong password')) {
        failureBar('Wrong password', context);
      } else {
        failureBar('Invalid credentials', context);
      }
    } else {
      failureBar('An unexpected error occurred', context);
    }
  }
}

  // REGISTER USER
  static Future<void> registerUser({
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate() == false ||
        passwordController.text != confirmPasswordController.text) {
      failureBar(ErrorText.passwordsNotMatch, context);
      return;
    }
    print('Registering user');
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
    print('First Name: ${firstNameController.text}');
    print('Last Name: ${lastNameController.text}');

    final String? message = await AuthService().registrationUser(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    if (message != null && message == 'success') {
      firstNameController.text = lastNameController.text =
          emailController.text = passwordController.text = '';
      AppRoute.offNamedUntil(NamedRoutes.LogInSeeker);
    } else {
      if (message != null) {
        failureBar(message, context);
      } else {
        failureBar('An unexpected error occurred', context);
      }
    }
  }

  // VERIFY CODE
  static Future<void> onVerifyCode({
    required String otp,
    required String? realOtp,
    required BuildContext context,
    required FirebaseAuth auth,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (otp.length != 6 || realOtp == null) {
        failureBar(ErrorText.enterCorrectOtp, context);
        return;
      }

      // Assuming you have a method to verify OTP via your backend
      final response = await AuthService().verifyOtp(otp, realOtp);

      if (response == 'success') {
        AppRoute.offNamedUntil(NamedRoutes.homeScreenSeeker);
      } else {
        failureBar(ErrorText.enterCorrectOtp, context);
      }
    } catch (e) {
      failureBar(ErrorText.enterCorrectOtp, context);
      return;
    }
  }

  // REGISTER COMPANY
static Future<void> registerCompany({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required GlobalKey<FormState> formKey,
  required BuildContext context,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  if (formKey.currentState!.validate() == false ||
      passwordController.text != confirmPasswordController.text) {
    failureBar(ErrorText.passwordsNotMatch, context);
    return;
  }

  print('Registering company');
  print('Name: ${nameController.text}');
  print('Email: ${emailController.text}');
  print('Password: ${passwordController.text}');

  final String? message = await AuthService().registerCompany(
    name: nameController.text,
    email: emailController.text,
    password: passwordController.text,
  );

  if (message != null && message == 'success') {
    nameController.text = emailController.text = passwordController.text = '';
    AppRoute.offNamedUntil(NamedRoutes.logInRecruiter);
  } else {
    if (message != null) {
      failureBar(message, context);
    } else {
      failureBar('An unexpected error occurred', context);
    }
  }
}

// LOGIN COMPANY
static Future<void> loginCompany({
  required TextEditingController emailController,
  required TextEditingController passWordController,
  required GlobalKey<FormState> formKey,
  required BuildContext context,
}) async {
  // Remove focus from keyboard
  FocusManager.instance.primaryFocus?.unfocus();
  print('Logging in company');
  print('Email: ${emailController.text}');
  print('Password: ${passWordController.text}');

  // Validation of inputs
  if (formKey.currentState!.validate() == false) {
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/societe/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passWordController.text,
      }),
    );

    final responseBody = jsonDecode(response.body);
    print(responseBody);

    if (response.statusCode == 200 && responseBody['status'] == true) {
      final String token = responseBody['token'] as String;
      final Map<String, dynamic> societe = responseBody['societe'] as Map<String, dynamic>;

      // Save token and company data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('societeName', societe['name'] as String);
      await prefs.setString('societe', jsonEncode(societe));
      await prefs.setInt('companyId', responseBody['societe']['id'] as int);
      await prefs.setString('token', responseBody['token'] as String);
      await prefs.setString('type', 'recruiter');
      print('Company ID: ${responseBody['societe']['id']}');
      print('Token: ${responseBody['token']}');
      print('Type: $prefs.getString("type")');
      print('NAME' + prefs.getString('societeName').toString());
      print('Company logged in successfully');

      emailController.text = passWordController.text = '';
      // Navigate to the main screen
      AppRoute.offNamedUntil(NamedRoutes.homeScreenRecruter);
    } else {
      failureBar(responseBody['message'] as String, context);
    }
  } catch (e) {
    failureBar('An unexpected error occurred', context);
  }
}


  // LOGOUT USER
  static Future<void> signOutUser(BuildContext context) async {
    try {
      
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${await SharedPreferences.getInstance().then((value) => value.getString('token'))}',
        },
      );

      if (response.statusCode == 200) {
        AppRoute.offNamedUntil(NamedRoutes.logInRecruiter);
      } else {
        final responseBody = jsonDecode(response.body);
        failureBar(
            responseBody['message'].toString() ?? 'Logout failed', context);
      }
    } catch (e) {
      failureBar('Logout failed', context);
    }
  }

  //clearSharedpref
  static Future<void> clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // SENDING OTP
  static Future<void> onClickSendCode({
    required TextEditingController mobileController,
    required BuildContext context,
  }) async {
    if (mobileController.text.length != 10) {
      failureBar(StaticText.invalidPhoneNo, context);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    await AuthService().registerUserWithPhone(
      mobileController.text,
      context,
    );
  }

  // VALIDATE TEXT FIELD
  static String validateTextField(String? value, InputType inputType) {
    switch (inputType) {
      case InputType.email:
        {
          if (value == null) {
            return "";
          } else if (!Validation.isValidEmail(value)) {
            return value.isEmpty
                ? ErrorText.emptyEmail
                : ErrorText.enterValidEmail;
          }
          break;
        }
      case InputType.password || InputType.confirmPassword:
        {
          if (value == null || value.isEmpty) {
            return "";
          } else if (value.length < 8) {
            return ErrorText.shortLength;
          } else if (!RegExp(r'[^\w\s]').hasMatch(value)) {
            return ErrorText.specialCharacter;
          } else if (!RegExp(r'[a-z]').hasMatch(value)) {
            return ErrorText.lowerCase;
          } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return ErrorText.upperCase;
          } else if (!RegExp(r'[0-9]').hasMatch(value)) {
            return ErrorText.containNumber;
          }
          break;
        }
      case InputType.name:
        {
          if (!Validation.isValidName(value!)) {
            return ErrorText.enterValidName;
          }
          break;
        }
      default:
        return "";
    }
    return "";
  }

  static Future<bool> checkIfAlreadyLoggedInUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  //    check prefs.setString('type', 'seeker');
  if (prefs.getString('type') == 'seeker') {
    AppRoute.offNamedUntil(NamedRoutes.homeScreenSeeker);
    return true;
  } else {
    return false;
  }
}
    
}
