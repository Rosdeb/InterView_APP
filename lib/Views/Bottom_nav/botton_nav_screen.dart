// botton_nav_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Utils/AppColor/app_colors.dart';

class IOSStyledBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const IOSStyledBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  Color _getColor(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (index == currentIndex) return const Color(0xFF007AFF);
    return isDark ? AppColors.DarkThemeSecondaryText : AppColors.DarkGray;
  }

  static const List<String> icons = [
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/Icone_dasboard.svg',
  ];

  static const List<String> iconsSelected = [
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/Icone_dasboard.svg',
  ];

  static const List<String> labels = [
    'Home',
    'Home',
    'Home',
    'Home',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(

            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark
                  ? Colors.white70.withOpacity(0.10)
                  : Colors.white70.withOpacity(0.8),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.12),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 12 : 10,
              horizontal: isTablet ? 4 : 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                labels.length,
                    (index) => Expanded(
                  child: _buildNavItem(context, index, isTablet),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, bool isTablet) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // pill dimensions
    final double pillW = isTablet ? 40 : 40;
    final double pillH = isTablet ? 40 : 40;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── icon area ──
          SizedBox(
            width: pillW,
            height: pillH,
            child: Stack(
              alignment: Alignment.center,
              children: [

                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        width: pillW,
                        height: pillH,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isDark
                              ? Colors.white54.withOpacity(0.10) // Dark mode: Subtle white tint
                              : Colors.white54.withOpacity(0.5), // Light mode: Frosted white tint
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                              blurRadius: 20,
                              spreadRadius: -2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            // The "Rim Light" effect—crucial for the glass look
                            color: isDark
                                ? Colors.white.withOpacity(0.15)
                                : Colors.white.withOpacity(0.6),
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.fastOutSlowIn,
                  child: SvgPicture.asset(
                    isSelected ? iconsSelected[index] : icons[index],
                    height: isTablet ? 22 : 20,
                    width: isTablet ? 22 : 20,
                    colorFilter: ColorFilter.mode(
                      _getColor(context, index),
                      BlendMode.srcIn,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 4),

          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.fastOutSlowIn,
            style: TextStyle(
              fontSize: isSelected
                  ? (isTablet ? 11.5 : 11.0)
                  : (isTablet ? 11.0 : 10.5),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: _getColor(context, index),
              letterSpacing: -0.2,
            ),
            child: Text(
              labels[index].tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}