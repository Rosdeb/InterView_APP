// Views/Feature/Home/home_screen.dart
//
// ═══════════════════════════════════════════════════════════════════════════
// SCROLL ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════
//
// ONE vertical scrollable: NestedScrollView
//   • NestedScrollView owns the single ScrollController.
//   • headerSliverBuilder: HomeHeaderDelegate (banner+search) + HomeTabBarDelegate.
//   • body: TabBarView (PageView internally) — only claims horizontal drags.
//   • Inner ListViews: AlwaysScrollableScrollPhysics so RefreshIndicator works.
//     NestedScrollView coordinator ensures they don't scroll while header
//     is still collapsing — ONE scroll surface at all times.
//
// HORIZONTAL SWIPE:
//   TabBarView/PageView claims horizontal drags. Vertical drags bubble up
//   to NestedScrollView. Flutter's gesture arena separates axes cleanly.
//
// TAB SCROLL POSITION:
//   AutomaticKeepAliveClientMixin (wantKeepAlive=true) keeps each tab alive
//   off-screen. ListView retains its own offset — no manual tracking needed.
//
// PULL-TO-REFRESH:
//   When header is fully collapsed, NestedScrollView forwards overscroll to
//   the inner ListView. RefreshIndicator detects it and fires onRefresh.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:app_interview/Views/Feature/Home/widgets/home_constant.dart';
import 'package:app_interview/Views/Feature/Home/widgets/productTabPage.dart';
import 'package:app_interview/Views/Feature/Home/widgets/tapBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/Auth/User_Controller/user_controller.dart';
import '../../../Controller/ProductController/product_controller.dart';
import 'widgets/error_view.dart';
import 'widgets/header_delegate.dart';
import 'widgets/product_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final _productCtrl = Get.find<ProductController>();
  final _userCtrl    = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ProductController.tabLabels.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.of(context).padding.top;

    return Obx(() {
      final user = _userCtrl.user.value;

      return Scaffold(
        backgroundColor:
        isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
        body: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: HomeHeaderDelegate(
                minExtent: kHeaderMin + topPad,
                maxExtent: kHeaderMax + topPad,
                isDark: isDark,
                user: user,
                searchController: _searchController,
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: HomeTabBarDelegate(
                tabController: _tabController,
                isDark: isDark,
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: List.generate(ProductController.tabLabels.length, (i) => ProductTabPage(
                tabIndex: i,
                productCtrl: _productCtrl,
                isDark: isDark,
              ),
            ),
          ),
        ),
      );
    });
  }
}


