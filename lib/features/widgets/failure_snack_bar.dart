import 'package:flutter/material.dart';
import 'package:portail_tn/themes/color_styles.dart';
import 'package:portail_tn/themes/font_styles.dart';

void failureBar(String text, BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$text!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: FontStyles.fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ColorStyles.failureColor,
        duration: const Duration(seconds: 2),
      ),
    );
