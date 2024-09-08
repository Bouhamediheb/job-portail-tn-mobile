import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portail_tn/constants/strings.dart';
import 'package:portail_tn/themes/color_styles.dart';
import 'package:portail_tn/constants/dimensions.dart';
import 'package:portail_tn/themes/font_styles.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
    required this.welcomePath,
    required this.welcomeText,
    required this.smallText,
  });

  final String welcomeText;
  final String welcomePath;
  final String smallText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              welcomeText,
              style: TextStyle(
                fontFamily: FontStyles.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: scaleWidth(20, context),
                color: ColorStyles.darkTitleColor,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              welcomePath,
              width: scaleWidth(22, context),
              height: scaleHeight(22, context),
              colorFilter: const ColorFilter.mode(
                ColorStyles.amber,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
         Text(
            smallText,
          style: FontStyles.lightStyle,
        ),
      ],
    );
  }
}
