import 'package:app_interview/Views/Feature/Home/widgets/home_constant.dart';
import 'package:app_interview/Views/Feature/Home/widgets/productTabPage.dart';
import 'package:app_interview/Views/Feature/Home/widgets/tapBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Auth/User_Controller/user_controller.dart';
import '../../../Controller/ProductController/product_controller.dart';
import 'widgets/header_delegate.dart';

/// Home screen with collapsible header, search, and category tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _productCtrl = Get.find<ProductController>();
  final _userCtrl = Get.find<UserController>();

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
                searchController: _productCtrl.searchController,
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
            children: List.generate(
              ProductController.tabLabels.length,
              (i) => ProductTabPage(
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