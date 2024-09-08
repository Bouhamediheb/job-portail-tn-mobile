import 'package:flutter/material.dart';
import 'package:portail_tn/constants/dimensions.dart';
import 'package:portail_tn/features/widgets/vetical_space.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: scaleWidth(280, context),
        padding: EdgeInsets.fromLTRB(
          scaleWidth(24, context),
          scaleHeight(24, context),
          scaleWidth(22, context),
          scaleHeight(20, context),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            scaleRadius(24, context),
          ),
          color: Colors.grey[300],
        ),
        child: SingleChildScrollView( // Added SingleChildScrollView here
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: scaleWidth(40, context),
                    height: scaleHeight(40, context),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(scaleRadius(12, context)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: scaleWidth(120, context),
                        height: scaleHeight(16, context),
                        color: Colors.grey[400],
                      ),
                      VerticalSpace(value: 3, ctx: context),
                      Container(
                        width: scaleWidth(80, context),
                        height: scaleHeight(14, context),
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  Container(
                    width: scaleWidth(24, context),
                    height: scaleHeight(24, context),
                    color: Colors.grey[400],
                  ),
                ],
              ),
              VerticalSpace(value: 24, ctx: context),
              Row(
                children: [
                  Container(
                    width: scaleWidth(60, context),
                    height: scaleHeight(16, context),
                    color: Colors.grey[400],
                  ),
                  SizedBox(width: scaleWidth(8, context)),
                  Container(
                    width: scaleWidth(60, context),
                    height: scaleHeight(16, context),
                    color: Colors.grey[400],
                  ),
                  SizedBox(width: scaleWidth(8, context)),
                  Container(
                    width: scaleWidth(60, context),
                    height: scaleHeight(16, context),
                    color: Colors.grey[400],
                  ),
                ],
              ),
              VerticalSpace(value: 24, ctx: context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: scaleWidth(60, context),
                    height: scaleHeight(13, context),
                    color: Colors.grey[400],
                  ),
                  Container(
                    width: scaleWidth(60, context),
                    height: scaleHeight(13, context),
                    color: Colors.grey[400],
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
