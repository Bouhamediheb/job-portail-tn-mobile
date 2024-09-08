import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portail_tn/constants/assets_location.dart';
import 'package:portail_tn/constants/strings.dart';
import 'package:portail_tn/constants/svg_color.dart';
import 'package:portail_tn/themes/color_styles.dart';

class MessageBar extends StatelessWidget {
  const MessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          StaticText.message,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorStyles.darkTitleColor,
          ),
        ),
        SvgPicture.asset(
          Assets.editSquare,
          width: 21,
          colorFilter: svgColor(
            ColorStyles.splashGradient1,
          ),
        )
      ],
    );
  }
}
