import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Navigator id for the main content area (shell with bottom bar).
/// Use with Get.to(..., id: kMainContentNavigatorId) and Get.back(id: kMainContentNavigatorId)
/// so the bottom bar stays visible.
const int kMainContentNavigatorId = 1;

/// Pushes [page] onto the nested navigator so the bottom bar remains visible.
void toWithBottomBar(Widget page) {
  Get.to(page, id: kMainContentNavigatorId);
}

/// Pops the nested navigator (used from detail screens opened with [toWithBottomBar]).
void backWithBottomBar() {
  Get.back(id: kMainContentNavigatorId);
}