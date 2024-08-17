import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_search_app/constants/get_app_routes.dart';
import 'package:job_search_app/constants/strings.dart';
import 'package:job_search_app/themes/color_styles.dart';
import 'package:job_search_app/themes/font_styles.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_translation.dart';
import 'constants/named_routes.dart';

class JobSearchApp extends StatefulWidget {
  const JobSearchApp({super.key});

  @override
  State<JobSearchApp> createState() => _JobSearchAppState();
}

class _JobSearchAppState extends State<JobSearchApp> {
  @override
Widget build(BuildContext context) {
  return GetMaterialApp(
    title: StaticText.appTitle,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color.fromARGB(255, 231, 233, 236),
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme,
        
      ),
    ),
    initialRoute: NamedRoutes.splashScreen,
    getPages: GetAppRoutes.getAppRoutes(),
    locale: Get.deviceLocale,
    translationsKeys: AppTranslation.translationKeys,
    fallbackLocale: const Locale('fr', 'FR'),
  );
}
}