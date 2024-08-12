import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_search_app/atom/pill.dart';
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/strings.dart';
import 'package:job_search_app/features/widgets/vetical_space.dart';
import 'package:job_search_app/themes/color_styles.dart';

class DisplayCard extends StatelessWidget {
  const DisplayCard({
    super.key,
    required this.companyName,
    required this.location,
    required this.logo,
    required this.role,
    required this.color,
    this.salary, // Salary is optional
  });

  final String companyName;
  final String role;
  final String logo;
  final String? salary; // Salary is now optional
  final String location;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scaleWidth(280, context),
      padding: EdgeInsets.fromLTRB(
        scaleWidth(24, context),
        scaleHeight(20, context),
        scaleWidth(22, context),
        scaleHeight(16, context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          scaleRadius(24, context),
        ),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COMPANY LOGO
              Container(
                decoration: BoxDecoration(
                  color: ColorStyles.pureWhite,
                  borderRadius: BorderRadius.circular(
                    scaleRadius(12, context),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: scaleWidth(12, context),
                  vertical: scaleHeight(12, context),
                ),
                child: Image.network(
                  logo,
                  width: scaleWidth(40, context),
                  height: scaleHeight(40, context),
                ),
              ),
              SizedBox(width: scaleWidth(16, context)),
              // TITLE, COMPANY NAME, AND LOCATION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorStyles.pureWhite,
                    ),
                  ),
                  VerticalSpace(value: 3, ctx: context),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorStyles.pureWhite,
                    ),
                  ),
                  VerticalSpace(value: 3, ctx: context),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ColorStyles.pureWhite,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // BOOKMARK ICON
              SvgPicture.asset(
                Assets.bookmarkSvg,
              ),
            ],
          ),
          VerticalSpace(value: 16, ctx: context),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Pill(StaticText.it),
                SizedBox(
                  width: 8,
                ),
                Pill(StaticText.fullTime),
                SizedBox(
                  width: 8,
                ),
                Pill(StaticText.junior),
              ],
            ),
          ),
          VerticalSpace(
            value: 16,
            ctx: context,
          ),
          if (salary != null)
            Text(
              salary!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColorStyles.pureWhite,
              ),
            ),
        ],
      ),
    );
  }
}
