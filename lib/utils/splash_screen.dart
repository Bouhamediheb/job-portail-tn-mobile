import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/named_routes.dart';
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/themes/color_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('user');

    // Check if user data exists in SharedPreferences
    if (userData != null) {
      // If user data exists, navigate to the main screen
      AppRoute.offNamed(NamedRoutes.mainScreen);
    } else {
      // If no user data, navigate to the login screen
      AppRoute.offNamed(NamedRoutes.logIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          width: width(context),
          height: height(context),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorStyles.splashGradient1,
                ColorStyles.splashGradient2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: scaleWidth(80, context),
                    vertical: scaleHeight(88, context),
                  ),
                  child: SvgPicture.asset(
                    Assets.splashSvg,
                    colorFilter: const ColorFilter.mode(
                      ColorStyles.pureWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Text(
                  'Find your dream job',
                  style: TextStyle(
                    color: ColorStyles.pureWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
