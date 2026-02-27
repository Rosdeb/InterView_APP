// bottom_menu_wrappers.dart
import 'package:app_interview/Views/Feature/Cards/card_screen.dart';
import 'package:app_interview/Views/Feature/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/BottomMenuController/bottom_menu_controller.dart';
import '../../Utils/AppColor/app_colors.dart';
import '../../Utils/App_navigation/app_navigation.dart';
import 'botton_nav_screen.dart';

class BottomMenuWrappers extends StatefulWidget {
  BottomMenuWrappers({super.key});

  @override
  State<BottomMenuWrappers> createState() => _BottomMenuWrappersState();
}

class _BottomMenuWrappersState extends State<BottomMenuWrappers> {
  final BottomMenuControllers controller = Get.put(BottomMenuControllers());

  final List<Widget> _pages = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  Widget _buildTabbedContent() {
    return Obx(() => IndexedStack(
      index: controller.selectedIndex.value,
      children: _pages,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor:
        isDark ? AppColors.DarkThemeBackground : Colors.white,
        // ── no bottomNavigationBar here ──
        body: Stack(
          children: [
            // ── 1. Full-screen page content ──
            Positioned.fill(
              child: SafeArea(
                top: false,
                child: PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) return;
                    final nestedState =
                        Get.nestedKey(kMainContentNavigatorId)?.currentState;
                    if (nestedState != null && nestedState.canPop()) {
                      nestedState.pop();
                    }
                  },
                  child: Navigator(
                    key: Get.nestedKey(kMainContentNavigatorId),
                    initialRoute: '/',
                    onGenerateRoute: (settings) {
                      if (settings.name == '/' || settings.name == null) {
                        return MaterialPageRoute(
                          builder: (_) => _buildTabbedContent(),
                          settings: settings,
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            // ── 2. Floating glass nav bar ──
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: IOSStyledBottomNav(
                onTap: controller.selectTab,
                currentIndex: controller.selectedIndex.value,
              ),
            ),
          ],
        ),
      );
    });
  }
}