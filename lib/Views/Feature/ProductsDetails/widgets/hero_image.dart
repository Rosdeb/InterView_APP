import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final String imageUrl;
  final int productId;
  final String? heroTag;
  final bool isDark;

  const HeroImage({
    required this.imageUrl,
    required this.productId,
    required this.heroTag,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.fromLTRB(40, 80, 40, 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
          minWidth: 200,
        ),
        child: Hero(
          tag: heroTag ?? 'product_$productId',
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => Icon(
              Icons.image_not_supported_outlined,
              size: 60,
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFD1D1D6),
            ),
            placeholder: (_, __) => const Center(
              child: CupertinoActivityIndicator(
                color: Color(0xFFFF6B00),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
