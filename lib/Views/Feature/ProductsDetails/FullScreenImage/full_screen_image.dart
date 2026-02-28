import 'dart:io';
import 'package:app_interview/Views/Base/AppText/appText.dart';
import 'package:app_interview/utils/AppColor/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/FullScreenImageController/fullScreen_Image_Controller.dart';

class FullScreenImageViewer extends GetView<FullScreenImageController> {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FullScreenImageController>()) {
      Get.put(FullScreenImageController());
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<FullScreenImageController>();
        return true;
      },
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFAF8F5),
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() => AnimatedOpacity(
                opacity: controller.isDragging.value ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: AppBar(
                  backgroundColor:
                      isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFAF8F5),
                  elevation: 0,
                  iconTheme: const IconThemeData(color: AppColors.Black),
                  actions: [
                    if (!controller.isZoomedIn.value)
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Center(
                          child: AppText(
                            'Pinch or double-tap to zoom',
                            style: TextStyle(
                              color: AppColors.Black,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    if (controller.isZoomedIn.value)
                      IconButton(
                        icon: const Icon(Icons.zoom_out_map,
                            color: AppColors.Black),
                        onPressed: controller.resetZoom,
                      ),
                  ],
                ),
              )),
        ),
        body: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              color: isDark
                  ? const Color(0xFF0F0F0F)
                  : const Color(0xFFFAF8F5),
              child: GestureDetector(
                onVerticalDragUpdate: controller.onVerticalDragUpdate,
                onVerticalDragEnd: controller.onVerticalDragEnd,
                onDoubleTap: () => controller.onDoubleTap(context),
                child: AnimatedSlide(
                  duration: controller.isDragging.value
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  offset: Offset(
                    0,
                    controller.dragOffset.value /
                        MediaQuery.of(context).size.height,
                  ),
                  curve: Curves.easeOutCubic,
                  child: Hero(
                    tag: heroTag,
                    child: InteractiveViewer(
                      transformationController: controller.transformationController,
                      minScale: 0.8,
                      maxScale: 6.0,
                      onInteractionEnd: (_) =>
                          controller.isDragging.value = false,
                      child: Center(
                        child: _buildImage(),
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (_, __) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) =>
          const Icon(Icons.broken_image, size: 64, color: Colors.white),
    );
  }
}
