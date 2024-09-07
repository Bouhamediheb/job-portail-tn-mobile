import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/named_routes.dart';
import 'package:job_search_app/themes/color_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/route_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startPageTransition();
  }

  void _startPageTransition() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentPage < 3) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

void _checkLoginStatusAndNavigate(bool isRecruiter) async {
  final prefs = await SharedPreferences.getInstance();
  final String? userType = prefs.getString('type');
  print("User type: $userType");

  if (userType != null && isRecruiter) {
    if (userType == 'recruiter') {
      print("User is a recruiter");
      AppRoute.offNamed(NamedRoutes.homeScreenRecruter);
    } else {
      AppRoute.offNamed(NamedRoutes.homeScreenSeeker);
    }
  } else {
    if (isRecruiter) {
      AppRoute.offNamed(NamedRoutes.registerScreenRecruter);
    } else {
      AppRoute.offNamed(NamedRoutes.registerScreenSeeker);
    }
  }
}


  Widget _buildPageContent({required String imagePath, required String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: scaleWidth(80, context),
            vertical: scaleHeight(88, context),
          ),
          child: Image.asset(
            imagePath,
            height: scaleHeight(150, context),
            width: scaleWidth(150, context),
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ColorStyles.pureWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (page < 3) {
      _startPageTransition();
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
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildPageContent(
                imagePath: "assets/images/job.png",
                text: 'Bienvenue à PortailTN',
              ),
              _buildPageContent(
                imagePath: "assets/images/job.png",
                text: 'Trouvez le travail de rêves \n ou le candidat parfait !',
              ),
              _buildPageContent(
                imagePath: "assets/images/job.png",
text: 'Cette application est dans sa version 0.1 et manque quelques fonctionnalités. \n Veuillez nous excuser pour les désagréments.'
              ),
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPageContent(
                    imagePath: "assets/images/job.png",
                    text: 'Avant de commencer, vous êtes \n Recruteur ou \nchercheur d\'emploi ?',
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _checkLoginStatusAndNavigate(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyles.splashGradient1,
                        ),
                        child: const Text(
                          'Recruteur/Entreprise',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _checkLoginStatusAndNavigate(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyles.splashGradient2,
                        ),
                        child: const Text(
                          'Chercheur d\'emploi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
