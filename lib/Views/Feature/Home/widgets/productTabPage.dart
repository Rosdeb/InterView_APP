import 'package:app_interview/Views/Feature/Home/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Controller/ProductController/product_controller.dart';
import 'error_view.dart';

/// Displays a list of products for a specific category tab.
class ProductTabPage extends StatefulWidget {
  final int tabIndex;
  final ProductController productCtrl;
  final bool isDark;

  const ProductTabPage({
    required this.tabIndex,
    required this.productCtrl,
    required this.isDark,
  });

  @override
  State<ProductTabPage> createState() => _ProductTabPageState();
}

class _ProductTabPageState extends State<ProductTabPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      final state = widget.productCtrl.loadState.value;
      final products =
          widget.productCtrl.filteredProductsForTab(widget.tabIndex);

      if (state == LoadState.loading && products.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B00)),
        );
      }

      if (state == LoadState.error && products.isEmpty) {
        return HomeErrorView(
          message: widget.productCtrl.errorMessage.value,
          onRetry: widget.productCtrl.refresh,
        );
      }

      return RefreshIndicator(
        onRefresh: widget.productCtrl.refresh,
        color: const Color(0xFFFF6B00),
        backgroundColor:
            widget.isDark ? const Color(0xFF2C2C2E) : Colors.white,
        displacement: 16,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 110),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(product: products[i]),
        ),
      );
    });
  }
}