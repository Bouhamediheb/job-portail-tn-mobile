import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../constants/assets_location.dart';
import '../controllers/controller.dart';
import '../themes/color_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<Controller>(
      init: Controller(),
      builder: (controller) => Scaffold(
        body: controller.switchScreen(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: controller.currentIndex == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.navbarHome,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 24, // Set width to ensure consistent sizing
                          height: 24, // Set height to ensure consistent sizing
                        ),
                        const SizedBox(height: 4), // Adjust spacing as needed
                        SvgPicture.asset(
                          Assets.navbarSelectedDot,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 8, // Set width to ensure consistent sizing
                          height: 8, // Set height to ensure consistent sizing
                        ),
                      ],
                    )
                  : SvgPicture.asset(
                      Assets.navbarHome,
                      width: 24, // Set width to ensure consistent sizing
                      height: 24, // Set height to ensure consistent sizing
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.currentIndex == 1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.navbarMsg,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 24, // Set width to ensure consistent sizing
                          height: 24, // Set height to ensure consistent sizing
                        ),
                        const SizedBox(height: 4), // Adjust spacing as needed
                        SvgPicture.asset(
                          Assets.navbarSelectedDot,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 8, // Set width to ensure consistent sizing
                          height: 8, // Set height to ensure consistent sizing
                        ),
                      ],
                    )
                  : SvgPicture.asset(
                      Assets.navbarMsg,
                      width: 24, // Set width to ensure consistent sizing
                      height: 24, // Set height to ensure consistent sizing
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.currentIndex == 2
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.navbarBookbar,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 24, // Set width to ensure consistent sizing
                          height: 24, // Set height to ensure consistent sizing
                        ),
                        const SizedBox(height: 4), // Adjust spacing as needed
                        SvgPicture.asset(
                          Assets.navbarSelectedDot,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 8, // Set width to ensure consistent sizing
                          height: 8, // Set height to ensure consistent sizing
                        ),
                      ],
                    )
                  : SvgPicture.asset(
                      Assets.navbarBookbar,
                      width: 24, // Set width to ensure consistent sizing
                      height: 24, // Set height to ensure consistent sizing
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.currentIndex == 3
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.navbarCategory,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 24, // Set width to ensure consistent sizing
                          height: 24, // Set height to ensure consistent sizing
                        ),
                        const SizedBox(height: 4), // Adjust spacing as needed
                        SvgPicture.asset(
                          Assets.navbarSelectedDot,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 8, // Set width to ensure consistent sizing
                          height: 8, // Set height to ensure consistent sizing
                        ),
                      ],
                    )
                  : SvgPicture.asset(
                      Assets.navbarCategory,
                      width: 24, // Set width to ensure consistent sizing
                      height: 24, // Set height to ensure consistent sizing
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.currentIndex == 4
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.navbarBookbar,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 24, // Set width to ensure consistent sizing
                          height: 24, // Set height to ensure consistent sizing
                        ),
                        const SizedBox(height: 4), // Adjust spacing as needed
                        SvgPicture.asset(
                          Assets.navbarSelectedDot,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.defaultMainColor,
                            BlendMode.srcIn,
                          ),
                          width: 8, // Set width to ensure consistent sizing
                          height: 8, // Set height to ensure consistent sizing
                        ),
                      ],
                    )
                  : SvgPicture.asset(
                      Assets.navbarBookbar,
                      width: 24, // Set width to ensure consistent sizing
                      height: 24, // Set height to ensure consistent sizing
                    ),
              label: '',
            ),
          ],
          currentIndex: controller.currentIndex,
          selectedItemColor: ColorStyles.defaultMainColor,
          backgroundColor: ColorStyles.pureWhite,
          onTap: (index) {
            controller.currentIndex = index;
          },
        ),
      ),
    );
  }
}
