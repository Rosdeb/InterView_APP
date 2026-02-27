import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinnedBackButton extends StatelessWidget {
  final bool isDark;
  const PinnedBackButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.07),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 15,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
