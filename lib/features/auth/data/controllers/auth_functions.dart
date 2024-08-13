import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_search_app/constants/route_functions.dart';
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
  final response = await AuthService().login(
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

    final String? message = await AuthService().registration(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    if (message != null && message == 'success') {
      firstNameController.text = lastNameController.text =
          emailController.text = passwordController.text = '';
      AppRoute.offNamedUntil(NamedRoutes.logIn);
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
        AppRoute.offNamedUntil(NamedRoutes.homeScreen);
      } else {
        failureBar(ErrorText.enterCorrectOtp, context);
      }
    } catch (e) {
      failureBar(ErrorText.enterCorrectOtp, context);
      return;
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
        AppRoute.offNamedUntil(NamedRoutes.logIn);
      } else {
        final responseBody = jsonDecode(response.body);
        failureBar(
            responseBody['message'].toString() ?? 'Logout failed', context);
      }
    } catch (e) {
      failureBar('Logout failed', context);
    }
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
}
