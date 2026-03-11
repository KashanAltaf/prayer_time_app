import 'package:prayer_time_app/res/routes/routes_name.dart';
import 'package:prayer_time_app/view/home_screen.dart';
import 'package:prayer_time_app/view/qibla_screen.dart';
import 'package:prayer_time_app/view/main_screen.dart';
import '../../view/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RoutesName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: RoutesName.mainScreen,
          page: () => const MainScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: RoutesName.homeScreen,
          page: () => const HomeScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        GetPage(
          name: RoutesName.qiblaScreen,
          page: () => const QiblaScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 250),
        ),
      ];
}