import 'package:flutter/material.dart';
import '../../../../Controller/ProductController/product_controller.dart';
import 'home_constant.dart';

/// Sliver delegate for the sticky category tab bar.
class HomeTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final bool isDark;

  const HomeTabBarDelegate({
    required this.tabController,
    required this.isDark,
  });

  @override
  double get minExtent => kTabBarH;

  @override
  double get maxExtent => kTabBarH;

  @override
  Widget build(BuildContext ctx, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: kTabBarH,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.black.withOpacity(0.06),
            width: 0.5,
          ),
        ),
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TabBar(
        controller: tabController,
        labelColor: const Color(0xFFFF6B00),
        unselectedLabelColor: const Color(0xFF8E8E93),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: Color(0xFFFF6B00), width: 2.5),
          borderRadius: BorderRadius.circular(2),
          insets: const EdgeInsets.symmetric(horizontal: 24),
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: ProductController.tabLabels.map((l) => Tab(text: l)).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(HomeTabBarDelegate old) => old.isDark != isDark;
}