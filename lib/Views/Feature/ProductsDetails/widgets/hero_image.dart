import 'package:app_interview/Views/Base/Ios_effect/iosTapEffect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../Controller/FullScreenImageController/fullScreen_Image_Controller.dart';
import '../FullScreenImage/full_screen_image.dart';

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
    final String tag = heroTag ?? 'product_$productId';
    return IosTapEffect(
      onTap: (){
        Get.to(() => FullScreenImageViewer(heroTag: tag, imageUrl: imageUrl,),
          binding: BindingsBuilder(() {
            Get.put(FullScreenImageController());
          }),
        );

      },
      child: Container(
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
      ),
    );
  }
}
