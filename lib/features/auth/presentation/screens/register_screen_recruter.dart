import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portail_tn/constants/named_routes.dart';
import 'package:portail_tn/features/auth/data/controllers/auth_functions.dart';
import 'package:portail_tn/features/auth/presentation/widgets/continue_with.dart';
import 'package:portail_tn/features/auth/presentation/widgets/login_button.dart';
import 'package:portail_tn/features/auth/presentation/widgets/text_fields.dart';
import 'package:portail_tn/features/widgets/vetical_space.dart';
import 'package:portail_tn/features/widgets/welcome_text.dart';
import 'package:portail_tn/constants/assets_location.dart';
import 'package:portail_tn/constants/dimensions.dart';
import 'package:portail_tn/constants/strings.dart';
import 'package:portail_tn/features/auth/data/controllers/validation.dart';

class RegisterScreenRecruter extends StatefulWidget {
  const RegisterScreenRecruter({super.key});

  @override
  State<RegisterScreenRecruter> createState() => _RegisterScreenRecruterState();
}

class _RegisterScreenRecruterState extends State<RegisterScreenRecruter> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isErrorFirstName = false;
  bool isErrorEmail = false;
  bool isErrorPassword = false;
  bool isErrorConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          scaleWidth(24, context),
          0,
          scaleWidth(24, context),
          0,
        ),
        child: ListView(
          children: [
            VerticalSpace(value: 23, ctx: context),
            // * SPLASH IMG
            Row(
              children: [
                Image.asset(
                  "assets/images/job.png",
                  scale: 6,
                )
              ],
            ),
            VerticalSpace(value: 8, ctx: context),
            // * Welcome text
            const WelcomeText(
              welcomePath: Assets.thumbsUpSvg,
              welcomeText: StaticText.registration,
              smallText:
                  "Créez votre compte pour pour poster vos offres d'emplois et trouvez les meilleurs candidats",
            ),
            VerticalSpace(value: 32, ctx: context),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Nom de la société', // Or just "Nom"
                    textIcon: Assets.profileSvg,
                    isPassword: false,
                    textType: TextInputType.name,
                    controller: _nameController,
                    isErrorfull:
                        isErrorFirstName, // Reuse the existing error state
                    inputType: InputType.name,
                    formKey: _formKey,
                  ),
                  VerticalSpace(value: 16, ctx: context),
                  CustomTextField(
                    hintText: StaticText.email,
                    textIcon: Assets.mailOutlineSvg,
                    isPassword: false,
                    textType: TextInputType.emailAddress,
                    controller: _emailController,
                    isErrorfull: isErrorEmail,
                    inputType: InputType.email,
                    formKey: _formKey,
                  ),
                  VerticalSpace(value: 16, ctx: context),
                  CustomTextField(
                    hintText: StaticText.password,
                    textIcon: Assets.passwordSvg,
                    isPassword: true,
                    textType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    isErrorfull: isErrorPassword,
                    inputType: InputType.password,
                    formKey: _formKey,
                  ),
                  VerticalSpace(value: 16, ctx: context),
                  CustomTextField(
                    hintText: StaticText.confirmPassword,
                    textIcon: Assets.passwordSvg,
                    isPassword: true,
                    textType: TextInputType.visiblePassword,
                    controller: _confirmPasswordController,
                    isErrorfull: isErrorConfirmPassword,
                    inputType: InputType.confirmPassword,
                    formKey: _formKey,
                  ),
                  VerticalSpace(value: 32, ctx: context),
                  LoginButton(
                    loginText: StaticText.register,
                    onTapButton: () => AuthFunctions.registerCompany(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      formKey: _formKey,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpace(
              value: 48,
              ctx: context,
            ),
            const ContinueWithOtherAccounts(
              isLogin: false,
            ),
            VerticalSpace(
              value: 36,
              ctx: context,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      NamedRoutes.logInRecruiter,
                    );
                  },
                  child: Text(
                    'Vous avez déjà un compte? Connectez-vous',
                    style: TextStyle(
                      fontSize: scaleWidth(12, context),
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 146, 150, 163),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
