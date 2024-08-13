import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8000/api';

  Future<String?> registration({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return 'success';
  } else {
    final responseBody = jsonDecode(response.body);
    return responseBody['message']?.toString();
  }
}




Future<Map<String, dynamic>?> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
  Uri.parse('$baseUrl/login'),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, String>{
    'email': email,
    'password': password,
  }),
).timeout(const Duration(seconds: 10), onTimeout: () {
  throw TimeoutException('The connection has timed out, Please try again!');
});


  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);

    // Save the user ID in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', responseBody['user']['id'] as int);

    return {
      'status': responseBody['status'],
      'message': responseBody['message'],
      'token': responseBody['token'],
      'user': responseBody['user'],
    };
  } else {
    final responseBody = jsonDecode(response.body);
    return {
      'status': false,
      'message': responseBody['message']?.toString(),
    };
  }
}



  Future<void> resetPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/password/email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        // Attempt to decode JSON and handle errors
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(responseBody['message']?.toString() ?? 'Unknown error');
      }
    } catch (e) {
      // Log and handle error
      print('Error in resetPassword: $e');
      throw Exception('Error processing password reset');
    }
  }

  // Dummy methods for future implementation
  signInWithGoogle() {}

  signInWithFacebook() {}

  registerUserWithPhone(String text, BuildContext context) {}

  verifyOtp(String otp, String realOtp) {}
}
