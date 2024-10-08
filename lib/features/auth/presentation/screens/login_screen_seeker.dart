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

class LogInSeeker extends StatefulWidget {
  const LogInSeeker({super.key});

  @override
  State<LogInSeeker> createState() => _LogInSeekerState();
}

class _LogInSeekerState extends State<LogInSeeker> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  bool isErrorMail = false;
  bool isErrorPassword = false;
  bool isErrorFull = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //if already logged in sharedpref , redirect to home
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    bool isLoggedIn = await AuthFunctions.checkIfAlreadyLoggedInUser(context);
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, NamedRoutes.homeScreenSeeker);
    }
  });
}



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
                  smallText: StaticText.applyToJobs,
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
                      VerticalSpace(value: 32, ctx: context),
                      LoginButton(
                        loginText: StaticText.logIn,
                        onTapButton: () => AuthFunctions.loginUser(
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

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      NamedRoutes.forgotPassword,
                    );
                  },
                  child: Text(
                    'Mot de passe oublié?',
                    style: TextStyle(
                      fontSize: scaleWidth(15, context),
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 146, 150, 163),
                    ),
                  ),
                ),

                VerticalSpace(value: 48, ctx: context),

                // * CONTINUE WITH
                const ContinueWithOtherAccounts(isLogin: true),

                VerticalSpace(value: 36, ctx: context),

                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vous n\'avez pas de compte ?',
                  style: TextStyle(
                    fontSize: scaleWidth(12, context),
                    color: Color.fromARGB(255, 146, 150, 163),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      NamedRoutes.registerScreenSeeker,
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
    ),
  ),
);

  }
}
