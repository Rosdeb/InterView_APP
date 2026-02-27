import 'package:app_interview/Views/Base/AppText/appText.dart';
import 'package:app_interview/Views/Feature/ProductsDetails/widgets/steper_button.dart';
import 'package:flutter/material.dart';

class PriceQuantityRow extends StatelessWidget {
  final double price;
  final int quantity;
  final bool isDark;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const PriceQuantityRow({
    required this.price,
    required this.quantity,
    required this.isDark,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${(price * quantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            if (quantity > 1)
              Text(
                '\$${price.toStringAsFixed(2)} each',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8E8E93),
                ),
              ),
          ],
        ),

        const Spacer(),


        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEEEBE6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StepperBtn(
                icon: Icons.remove,
                onTap: onDecrement,
                isDark: isDark,
                enabled: quantity > 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: AppText(
                  '$quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              StepperBtn(
                icon: Icons.add,
                onTap: onIncrement,
                isDark: isDark,
                enabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
