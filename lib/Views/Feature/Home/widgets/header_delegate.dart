import 'package:app_interview/Views/Feature/Home/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import '../../../../Models/user_model/user_model.dart';
import 'banner.dart';
import 'home_constant.dart';


class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final bool isDark;
  final UserModel? user;
  final TextEditingController searchController;

  const HomeHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.isDark,
    required this.user,
    required this.searchController,
  });

  // 0.0 = fully expanded, 1.0 = fully collapsed
  double _progress(double shrinkOffset) =>
      (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext ctx, double shrinkOffset, bool overlapsContent) {
    final t = _progress(shrinkOffset);
    final topPad = MediaQuery.of(ctx).padding.top;

    return Container(
      color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Banner: fades out as header collapses ─────────────────────
          // bottom: kHeaderMin keeps it above the search bar zone
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: kHeaderMin,
            child: Opacity(
              opacity: (1.0 - t * 2.0).clamp(0.0, 1.0),
              child: HomeBanner(
                isDark: isDark,
                topPad: topPad,
                user: user,
              ),
            ),
          ),

          // ── Search bar: always visible at bottom of header ────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: kHeaderMin,
            child: HomeSearchBar(
              isDark: isDark,
              collapsed: t > 0.8,
              user: user,
              searchController: searchController,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(HomeHeaderDelegate old) =>
      old.isDark != isDark ||
          old.minExtent != minExtent ||
          old.maxExtent != maxExtent ||
          old.user != user ||
          old.searchController != searchController;
}