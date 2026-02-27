
import 'package:app_interview/Controller/ProductController/product_controller.dart';
import 'package:app_interview/Views/Base/AppText/appText.dart';
import 'package:app_interview/Views/Base/Ios_effect/iosTapEffect.dart';
import 'package:app_interview/Views/Feature/ProductsDetails/widgets/enable_dicription.dart';
import 'package:app_interview/Views/Feature/ProductsDetails/widgets/hero_image.dart';
import 'package:app_interview/Views/Feature/ProductsDetails/widgets/pinned_back_button.dart';
import 'package:app_interview/Views/Feature/ProductsDetails/widgets/price_quatity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../Models/product_model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final String? heroTag;

  const ProductDetailScreen({
    required this.productId,
    this.heroTag,
    super.key,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  final ProductController controller = Get.find<ProductController>();

  late final AnimationController _enterAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final void Function(dynamic) _stateListener;

  @override
  void initState() {
    super.initState();
    _enterAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _enterAnim, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterAnim, curve: Curves.easeOutCubic));
    _stateListener = (state) {
      if (state == LoadState.success && mounted) {
        _enterAnim.forward(from: 0);
      }
    };
    ever(controller.detailLoadState, _stateListener);
    controller.fetchProductById(widget.productId);
  }



  @override
  void dispose() {
    _enterAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFAF8F5),
      body: Obx(() {
        if (controller.isLoading.value) return _buildLoader(isDark);
        if (controller.detailError.value.isNotEmpty) return _buildError(isDark);
        if (controller.selectedProduct.value == null) return _buildLoader(isDark);
        return _buildContent(isDark);
      }),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _buildLoader(bool isDark) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: Color(0xFFFF6B00),
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  Widget _buildError(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 48,
              color: isDark
                  ? const Color(0xFF636366)
                  : const Color(0xFFAEAEB2)),
          const SizedBox(height: 16),
          Obx((){
            return AppText("${controller.error}" ?? 'Something went wrong',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF8E8E93)
                      : const Color(0xFF6C6C70),
                ));
          }),

          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              controller.fetchProductById(widget.productId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Retry',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────────────────────
  Widget _buildContent(bool isDark) {
    final p = controller.selectedProduct.value!;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 380,
              pinned: true,
              backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFAF8F5),
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: PinnedBackButton(isDark: isDark),
                ),
              ),
              actions: [
                Obx((){
                  return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _WishlistButton(
                        wishlisted: controller.wishlisted.value,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          controller.wishlisted.value  =! controller.wishlisted.value;
                        },
                        isDark: isDark,
                      ));
                })


              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: HeroImage(
                  imageUrl: p.image,
                  productId: p.id,
                  heroTag: widget.heroTag,
                  isDark: isDark,
                ),
              ),
            ),



            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFAF8F5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              _CategoryChip(label: p.category, isDark: isDark),
                              const Spacer(),
                              _RatingBadge(rate: p.ratingRate, count: p.ratingCount, isDark: isDark),
                            ],
                          ),
                          const SizedBox(height: 14),


                          AppText(
                            p.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              letterSpacing: -0.5,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // ── Price + Quantity ─────────────────
                          Obx(()=> PriceQuantityRow(
                            price: p.price,
                            quantity: controller.quantity.value,
                            isDark: isDark,
                            onDecrement: () {
                              if (controller.quantity > 1) {
                                HapticFeedback.selectionClick();
                                controller.quantity--;
                              }
                            },
                            onIncrement: () {
                              HapticFeedback.selectionClick();
                              controller.quantity++;
                            },
                          ),),


                          const SizedBox(height: 28),
                          _Divider(isDark: isDark),
                          const SizedBox(height: 24),

                          // ── Description heading ──────────────
                          AppText(
                            'Description',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: isDark
                                  ? const Color(0xFF8E8E93)
                                  : const Color(0xFF8E8E93),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ── Description text ──────────────────
                          ExpandableDescription(
                            text: p.description,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 28),
                          _Divider(isDark: isDark),
                          const SizedBox(height: 24),


                          SpecsRow(product: p, isDark: isDark),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SliverToBoxAdapter(child: SizedBox(height: 20 + bottomPad)),

            SliverToBoxAdapter(child: StickyCartBar(isDark: isDark, bottomPad: bottomPad)),

            SliverToBoxAdapter(child: SizedBox(height: 100 + bottomPad)),
          ],
        ),
      ),
    );
  }
}


class _BackButton extends StatelessWidget {
  final bool isDark;
  const _BackButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.07),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

class _WishlistButton extends StatefulWidget {
  final bool wishlisted;
  final VoidCallback onTap;
  final bool isDark;

  const _WishlistButton({
    required this.wishlisted,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<_WishlistButton> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IosTapEffect(
      onTap: () {
        widget.onTap();
        _anim.forward(from: 0);
      },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.black.withOpacity(0.07),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.wishlisted ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            size: 20,
            color: widget.wishlisted ? const Color(0xFFFF2D55) : (widget.isDark ? Colors.white : const Color(0xFF1A1A1A)),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _CategoryChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B00).withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B00).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFF6B00),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rate;
  final int count;
  final bool isDark;

  const _RatingBadge({
    required this.rate,
    required this.count,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final filled = i < rate.floor();
            final half = !filled && i < rate;
            return Icon(
              filled
                  ? Icons.star_rounded
                  : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
              size: 14,
              color: const Color(0xFFFF9500),
            );
          }),
        ),
        const SizedBox(width: 5),
        AppText(
          rate.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFFAEAEB2) : const Color(0xFF6C6C70),
          ),
        ),
        AppText(
          ' ($count)',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? const Color(0xFF636366) : const Color(0xFFAEAEB2),
          ),
        ),
      ],
    );
  }
}

class SpecsRow extends StatelessWidget {
  final ProductModel product;
  final bool isDark;

  const SpecsRow({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final specs = [
      const Spec(icon: Icons.verified_rounded, label: 'Genuine', sub: 'Product'),
      const Spec(icon: Icons.local_shipping_outlined, label: 'Free', sub: 'Delivery'),
      const Spec(icon: Icons.replay_rounded, label: '30-Day', sub: 'Returns'),
      const Spec(icon: Icons.shield_outlined, label: '1-Year', sub: 'Warranty'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: specs.map((s) => _SpecCard(spec: s, isDark: isDark))
          .toList(),
    );
  }
}

class Spec {
  final IconData icon;
  final String label;
  final String sub;
  const Spec({required this.icon, required this.label, required this.sub});
}

class _SpecCard extends StatelessWidget {
  final Spec spec;
  final bool isDark;
  const _SpecCard({required this.spec, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E1E1E)
                : const Color(0xFFEEEBE6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            spec.icon,
            size: 20,
            color: const Color(0xFFFF6B00),
          ),
        ),
        const SizedBox(height: 6),
        AppText(
          spec.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        AppText(
          spec.sub,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: isDark
          ? Colors.white.withOpacity(0.08)
          : Colors.black.withOpacity(0.07),
    );
  }
}

class StickyCartBar extends StatelessWidget {
  final bool isDark;
  final double bottomPad;

  const StickyCartBar({
    required this.isDark,
    required this.bottomPad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPad + 14),
      child: Row(
        children: [
          // Cart icon button
          IosTapEffect(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEEEBE6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Add to cart button
          Expanded(
            child: IosTapEffect(
              onTap: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added to cart!'),
                    backgroundColor: const Color(0xFFFF6B00),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B00).withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_rounded,color: Colors.white, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}