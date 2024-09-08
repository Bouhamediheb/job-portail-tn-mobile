import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portail_tn/constants/dimensions.dart';
import 'package:portail_tn/themes/color_styles.dart';

class PopularJobsCard extends StatelessWidget {
  const PopularJobsCard({
    super.key,
    required this.logo,
    required this.company,
    required this.role,
    required this.salary,
    required this.color,
  });

  final String logo;
  final String role;
  final String company;
  final String salary;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scaleWidth(136, context),
      height: scaleHeight(164, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(scaleRadius(24, context)),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network
          (
            logo,
            width: scaleWidth(40, context),
            height: scaleHeight(40, context),
          ),
          Text(
            role,
            style: TextStyle(
              fontSize: scaleWidth(14, context),
              color: ColorStyles.c0d0d26,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            company,
            style: TextStyle(
              fontSize: scaleWidth(12, context),
              color: ColorStyles.c7A7C85,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            salary,
            style: TextStyle(
              fontSize: scaleWidth(12, context),
              color: ColorStyles.c0d0d26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
