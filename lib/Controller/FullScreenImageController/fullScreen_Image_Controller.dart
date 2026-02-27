import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenImageController extends GetxController {
  final TransformationController transformationController =
      TransformationController();

  var dragOffset = 0.0.obs;
  var backgroundOpacity = 1.0.obs;
  var isDragging = false.obs;
  var isZoomedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    transformationController.addListener(_updateZoomState);
  }

  void _updateZoomState() {
    final scale = transformationController.value.getMaxScaleOnAxis();
    isZoomedIn.value = scale > 1.05;
  }

  void resetZoom() {
    transformationController.value = Matrix4.identity();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (isZoomedIn.value) return;

    isDragging.value = true;
    dragOffset.value += details.delta.dy;

    backgroundOpacity.value =
        (1.0 - (dragOffset.value.abs() / 300)).clamp(0.0, 1.0);
  }

  void onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (dragOffset.value.abs() > 120 || velocity.abs() > 600) {
      Get.back();
    } else {
      dragOffset.value = 0.0;
      backgroundOpacity.value = 1.0;
      isDragging.value = false;
    }
  }

  void onDoubleTap(BuildContext context) {
    if (isZoomedIn.value) {
      resetZoom();
    } else {
      final position = Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      );

      transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 1.5, -position.dy * 1.5)
        ..scale(2.5);
    }
  }


  @override
  void onClose() {
    transformationController.dispose();
    super.onClose();
  }
}