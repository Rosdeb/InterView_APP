import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/Auth/User_Controller/user_controller.dart';
import '../../../../Models/user_model/user_model.dart';
import '../../../Base/AppText/appText.dart';

/// Bottom sheet displaying user profile information and sign out option.
class ProfileSheet extends StatelessWidget {
  final UserModel user;

  const ProfileSheet({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userCtrl = Get.find<UserController>();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF636366)
                  : const Color(0xFFD1D1D6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFFF6B00),
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppText(
            user.fullName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            '@${user.username}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 24),
          _InfoRow(icon: Icons.email_outlined, text: user.email, isDark: isDark),
          _InfoRow(icon: Icons.phone_outlined, text: user.phone, isDark: isDark),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: '${user.street}, ${user.city} ${user.zipcode}',
            isDark: isDark,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              userCtrl.logout();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF3B30).withOpacity(0.3),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFFF3B30),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

/// Info row widget displaying an icon and text label.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDark
                ? const Color(0xFF8E8E93)
                : const Color(0xFF6C6C70),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppText(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFFAEAEB2)
                    : const Color(0xFF3C3C43),
              ),
            ),
          ),
        ],
      ),
    );
  }
}