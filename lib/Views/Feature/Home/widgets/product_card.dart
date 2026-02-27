import 'package:app_interview/Views/Base/AppText/appText.dart';
import 'package:app_interview/Views/Base/Ios_effect/iosTapEffect.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../../../Models/product_model/product_model.dart';
import '../../ProductsDetails/product_details.dart';

/// Product card displaying product image, title, price, rating, and actions.
class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({required this.product, super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _wishlisted = false;
  late final AnimationController _heartAnim;
  late final Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _heartScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.45, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartAnim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _heartAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IosTapEffect(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.22 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  productId: product.id,
                  heroTag: 'product_${product.id}',
                ),
              ),
            );
            HapticFeedback.selectionClick();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : const Color(0xFFF9F9F9),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFFAEAEB2),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFF6B00),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00)
                              .withOpacity(isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppText(
                          product.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B00),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppText(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1C1C1E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFFF9500),
                          ),
                          const SizedBox(width: 2),
                          AppText(
                            product.ratingRate.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF8E8E93)
                                  : const Color(0xFF6C6C70),
                            ),
                          ),
                          AppText(
                            '(${product.ratingCount})',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFF636366)
                                  : const Color(0xFFAEAEB2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _wishlisted = !_wishlisted);
                        _heartAnim.forward(from: 0);
                      },
                      child: ScaleTransition(
                        scale: _heartScale,
                        child: Icon(
                          _wishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          size: 20,
                          color: _wishlisted
                              ? const Color(0xFFFF2D55)
                              : isDark
                                  ? const Color(0xFF636366)
                                  : const Color(0xFFAEAEB2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF1C1C1E),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => HapticFeedback.lightImpact(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}