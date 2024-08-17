import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:job_search_app/constants/named_routes.dart';
import 'package:job_search_app/features/auth/presentation/screens/forgot_password.dart';
import 'package:job_search_app/features/auth/presentation/screens/login_screen_recruter.dart';
import 'package:job_search_app/features/auth/presentation/screens/login_screen_seeker.dart';
import 'package:job_search_app/features/auth/presentation/screens/register_screen_recruter.dart';
import 'package:job_search_app/features/auth/presentation/screens/register_screen_seeker.dart';
import 'package:job_search_app/features/auth/presentation/screens/reset_password.dart';
import 'package:job_search_app/features/auth/presentation/screens/verify_code.dart';
import 'package:job_search_app/features/auth/presentation/screens/full_page_job.dart';
import 'package:job_search_app/features/auth/presentation/screens/home_screen.dart';
import 'package:job_search_app/features/main_screen.dart';
import 'package:job_search_app/features/auth/presentation/screens/applied_jobs_list.dart';
import 'package:job_search_app/utils/splash_screen.dart';
import 'package:job_search_app/utils/success_screen.dart';

class GetAppRoutes {
  GetAppRoutes._();

  static List<GetPage<dynamic>> getAppRoutes() {
    return [
      GetPage(
        name: NamedRoutes.homeScreen,
        page: () => const HomeScreen(),
      ),
      GetPage(
        name: NamedRoutes.LogInSeeker,
        page: () => const LogInSeeker(),
      ),
      GetPage(
        name: NamedRoutes.logInRecruiter,
        page: () => const LogInRecruter(),
      ),
      GetPage(
        name: NamedRoutes.registerScreenSeeker,
        page: () => const RegisterScreenSeeker()
      ),
      GetPage(
        name: NamedRoutes.registerScreenRecruter,
        page: () => const RegisterScreenRecruter(),
      ),
      GetPage(
        name: NamedRoutes.splashScreen,
        page: () => const SplashScreen(),
      ),
      GetPage(
        name: NamedRoutes.forgotPassword,
        page: () => const ForgotPassword(),
      ),
      GetPage(
        name: NamedRoutes.resetPassword,
        page: () => ResetPassword(),
      ),
      GetPage(
        name: NamedRoutes.verifyCode,
        page: () => const VerifyCode(),
      ),
      GetPage(
        name: NamedRoutes.successScreen,
        page: () => const SuccessScreen(),
      ),
      GetPage(
        name: NamedRoutes.mainScreen,
        page: () => const MainScreen(),
      ),
      GetPage(
        name: NamedRoutes.fullPageJob,
        page: () => const FullPageJob(),
      ),
      GetPage(
        name: NamedRoutes.savedJobs,
        page: () => SavedJobsScreen(),
      ),
    ];
  }
}
