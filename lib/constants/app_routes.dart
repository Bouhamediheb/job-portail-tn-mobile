import 'package:flutter/material.dart';
import 'package:portail_tn/constants/named_routes.dart';
import 'package:portail_tn/features/auth/presentation/screens/forgot_password.dart';
import 'package:portail_tn/features/auth/presentation/screens/home_screen_recruter.dart';
import 'package:portail_tn/features/auth/presentation/screens/login_screen_seeker.dart';
import 'package:portail_tn/features/auth/presentation/screens/login_screen_recruter.dart';
import 'package:portail_tn/features/auth/presentation/screens/register_screen_seeker.dart';
import 'package:portail_tn/features/auth/presentation/screens/register_screen_recruter.dart';
import 'package:portail_tn/features/auth/presentation/screens/reset_password.dart';
import 'package:portail_tn/features/auth/presentation/screens/home_screen_jobseeker.dart';
import 'package:portail_tn/utils/splash_screen.dart';
import 'package:portail_tn/utils/success_screen.dart';
import 'package:portail_tn/features/auth/presentation/screens/verify_code.dart';

class AppRoutes {
  AppRoutes._();

  static Map<String, WidgetBuilder> routes() {
    return {
      NamedRoutes.splashScreen: (context) => const SplashScreen(),
      NamedRoutes.LogInSeeker: (context) => const LogInSeeker(),
      NamedRoutes.logInRecruiter: (context) => const LogInRecruter(),
      NamedRoutes.registerScreenSeeker: (context) => const RegisterScreenSeeker(),
      NamedRoutes.registerScreenRecruter: (context) => const RegisterScreenRecruter(),
      NamedRoutes.forgotPassword: (context) => const ForgotPassword(),
      NamedRoutes.successScreen: (context) => const SuccessScreen(),
      NamedRoutes.resetPassword: (context) => ResetPassword(),
      NamedRoutes.verifyCode: (context) => const VerifyCode(),
      NamedRoutes.homeScreenSeeker: (context) => const HomeScreenSeeker(),
      NamedRoutes.homeScreenRecruter: (context) => const HomeScreenRecruter(),
    };
  }
}
