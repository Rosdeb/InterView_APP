import 'package:app_interview/Views/Base/AppText/appText.dart';
import 'package:flutter/material.dart';
import '../../../../Models/user_model/user_model.dart';
import 'home_constant.dart';
import 'profile_sheet.dart';

class HomeBanner extends StatelessWidget {
  final bool isDark;
  final double topPad;
  final UserModel? user;

  const HomeBanner({
    required this.isDark,
    required this.topPad,
    required this.user,
    super.key,
  });

  static double get contentHeight => kHeaderMax - kHeaderMin;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2C1810), const Color(0xFF1C1C1E)]
                : [const Color(0xFFFFF3EC), const Color(0xFFF2F2F7)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [

            Positioned(
              top: topPad - 10,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B00).withOpacity(0.08),
                ),
              ),
            ),

            Positioned(
              top: topPad + 12,
              left: 18,
              right: 18,
              height: contentHeight - 12,
              child: _BannerContent(
                isDark: isDark,
                user: user,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BannerContent extends StatelessWidget {
  final bool isDark;
  final UserModel? user;

  const _BannerContent({
    required this.isDark,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            children: [
              const _Pill(label: '🔥 Hot Deals'),
              const Spacer(),
              if (user != null)
                GestureDetector(
                  onTap: () => _openProfile(context),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFFF6B00),
                    child: Text(
                      user!.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Greeting ─────────────────────────────────────────────────
          AppText(
            user != null ? 'Hello, ${user!.firstName}! 👋' : 'Welcome! 👋',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? const Color(0xFF8E8E93)
                  : const Color(0xFF6C6C70),
            ),
          ),

          const SizedBox(height: 4),

          // ── Title ─────────────────────────────────────────────────────
          AppText(
            "Today's Best Deals",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ProfileSheet(user: user!),
    );
  }
}

// ── Small reusable pill chip ───────────────────────────────────────────────
class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B00).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFF6B00),
        ),
      ),
    );
  }
}