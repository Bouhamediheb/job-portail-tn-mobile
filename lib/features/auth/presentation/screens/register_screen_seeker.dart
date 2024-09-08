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

class RegisterScreenSeeker extends StatefulWidget {
  const RegisterScreenSeeker({super.key});

  @override
  State<RegisterScreenSeeker> createState() => _RegisterScreenSeekerState();
}

class _RegisterScreenSeekerState extends State<RegisterScreenSeeker> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isErrorFirstName = false;
  bool isErrorLastName = false;
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
                      scale: 5,
                    )              ],
            ),
            VerticalSpace(value: 8, ctx: context),
            // * Welcome text
            const WelcomeText(
              welcomePath: Assets.thumbsUpSvg,
              welcomeText: StaticText.registration,
              smallText: "Créez un compte pour postuler à des offres d'emploi",
            ),
            VerticalSpace(value: 32, ctx: context),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Nom',
                    textIcon: Assets.profileSvg,
                    isPassword: false,
                    textType: TextInputType.name,
                    controller: _firstNameController,
                    isErrorfull: isErrorFirstName,
                    inputType: InputType.name,
                    formKey: _formKey,
                  ),
                  VerticalSpace(value: 16, ctx: context),
                  CustomTextField(
                    hintText: 'Prénom',
                    textIcon: Assets.profileSvg,
                    isPassword: false,
                    textType: TextInputType.name,
                    controller: _lastNameController,
                    isErrorfull: isErrorLastName,
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
                    onTapButton: () => AuthFunctions.registerUser(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
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
              value: 32,
              ctx: context,
            ),
            const ContinueWithOtherAccounts(
              isLogin: false,
            ),
            VerticalSpace(
              value: 36,
              ctx: context,
            ),
            //already have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vous avez déjà un compte ?',
                  style: TextStyle(
                    fontSize: scaleWidth(12, context),
                    color: Color.fromARGB(255, 146, 150, 163),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      NamedRoutes.LogInSeeker,
                    );
                  },
                  child: Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: scaleWidth(12, context),
                      color: Color.fromARGB(255, 0, 114, 188),
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
