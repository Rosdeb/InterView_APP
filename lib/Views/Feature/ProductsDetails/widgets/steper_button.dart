import 'package:flutter/material.dart';

class StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool enabled;

  const StepperBtn({
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFFF6B00)
              : (isDark
              ? const Color(0xFF3A3A3C)
              : const Color(0xFFD8D4CF)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? Colors.white
              : (isDark ? const Color(0xFF636366) : const Color(0xFFAEAEB2)),
        ),
      ),
    );
  }
}