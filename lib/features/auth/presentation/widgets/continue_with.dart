import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portail_tn/constants/named_routes.dart';
import 'package:portail_tn/features/auth/data/services/firebase/auth_service.dart';
import 'package:portail_tn/constants/dimensions.dart';
import 'package:portail_tn/features/widgets/failure_snack_bar.dart';
import 'package:portail_tn/themes/font_styles.dart';
import 'package:portail_tn/constants/assets_location.dart';

class ContinueWithOtherAccounts extends StatelessWidget {
  const ContinueWithOtherAccounts({super.key, required this.isLogin});

  // To check if it is for the login page or register page
  // On basis of this, we direct user to different pages
  final bool isLogin;

  // When user sign in with google
  Future<void> onTapSignInWithGoogle(BuildContext context) async {
    final result = await AuthService().signInWithGoogle();
    if (result.user == null) {
      failureBar('User not found', context);
    } 
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // It creates continue with text with dividers
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Color(
                  0xFFAFB0B6,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: scaleHeight(8, context)),
              child: const Text(
                'Ou avec',
                style: TextStyle(
                  color: Color(0xFFAFB0B6),
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Color(
                  0xFFAFB0B6,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: scaleHeight(35, context),
        ),

        // ACCOUNT ICONS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                // Nothing
              },
              child: SvgPicture.asset(
                Assets.appleSvg,
              ),
            ),
            InkWell(
              onTap: () => onTapSignInWithGoogle(context),
              child: SvgPicture.asset(
                Assets.googleSvg,
              ),
            ),
            InkWell(
              onTap: () async {
                await AuthService().signInWithFacebook();
              },
              child: SvgPicture.asset(
                Assets.facebookSvg,
              ),
            ),

            // SvgPicture.asset(Assets.facebookSvg),
          ],
        ),

        
      ],
    );
  }
}
