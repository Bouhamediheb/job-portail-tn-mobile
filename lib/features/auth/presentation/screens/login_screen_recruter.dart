import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class LogInRecruter extends StatefulWidget {
  const LogInRecruter({super.key});

  @override
  State<LogInRecruter> createState() => _LogInRecruterState();
}

class _LogInRecruterState extends State<LogInRecruter> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  bool isErrorMail = false;
  bool isErrorPassword = false;
  bool isErrorFull = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              scaleWidth(24, context),
              0,
              scaleWidth(24, context),
              0,
            ),
            child: ListView(
              children: [
                VerticalSpace(value: 61, ctx: context),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/job.png",
                      scale: 3,
                    )
                  ],
                ),
                VerticalSpace(value: 8, ctx: context),
                const WelcomeText(
                  welcomePath: Assets.helloSvg,
                  welcomeText: StaticText.welcomeBack,
                  smallText: StaticText.lookForCandidats,
                ),
                VerticalSpace(value: 52, ctx: context),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: StaticText.email,
                        textIcon: Assets.mailOutlineSvg,
                        isPassword: false,
                        textType: TextInputType.emailAddress,
                        controller: _emailController,
                        isErrorfull: isErrorFull,
                        inputType: InputType.email,
                        formKey: _formKey,
                      ),
                      VerticalSpace(value: 16, ctx: context),
                      CustomTextField(
                        hintText: StaticText.password,
                        textIcon: Assets.passwordSvg,
                        isPassword: true,
                        textType: TextInputType.visiblePassword,
                        controller: _passWordController,
                        isErrorfull: isErrorFull,
                        inputType: InputType.password,
                        formKey: _formKey,
                      ),
                      // if (isErrorPassword)
                      //   const ValidationError(errorText: 'Invalid password'),
                      VerticalSpace(value: 8, ctx: context),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            NamedRoutes.forgotPassword,
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Mot de passe oublié?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: scaleWidth(12, context),
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 146, 150, 163),
                            ),
                          ),
                        ),
                      ),
                      VerticalSpace(value: 8, ctx: context),
                    

                      LoginButton(
                        loginText: StaticText.logIn,
                        onTapButton: () => AuthFunctions.loginCompany(
                          emailController: _emailController,
                          passWordController: _passWordController,
                          formKey: _formKey,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),

                // FORGOT PASSWORD
                VerticalSpace(value: 32, ctx: context),

                const ContinueWithOtherAccounts(isLogin: true),
                VerticalSpace(value: 16, ctx: context),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          NamedRoutes.registerScreenRecruter,
                        );
                      },
                      child: Text(
                        'Vous n\'avez pas de compte? Inscrivez-vous',
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
        ),
      ),
    );
  }
}
