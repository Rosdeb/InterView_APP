// Controller/ProductController/product_controller.dart
//
// Owns: product lists per category + single product detail.
// Pure GetX — no BuildContext, no setState, no mounted checks.

import 'dart:convert';
import 'package:app_interview/Utils/AppConstant/app_contants.dart';
import 'package:app_interview/Utils/Logger/logger.dart';
import 'package:get/get.dart';
import '../../Models/product_model/product_model.dart';
import 'package:http/http.dart' as http;

enum LoadState { idle, loading, success, error }

class ProductController extends GetxController {
  // ── Tab config ────────────────────────────────────────────────────────────
  static const List<String> tabLabels = ['All', "Men's", "Women's"];

  static const _allKey     = 'all';
  static const _mensKey    = "men's clothing";
  static const _womensKey  = "women's clothing";
  static const List<String> _categoryKeys = [_allKey, _mensKey, _womensKey];

  static String keyForTab(int index) => _categoryKeys[index];

  // ── State: product lists ───────────────────────────────────────────────────
  final RxMap<String, List<ProductModel>> productMap =
      <String, List<ProductModel>>{}.obs;

  final Rx<LoadState> loadState   = LoadState.idle.obs;
  final RxString      errorMessage = ''.obs;

  // ── State: single product detail ──────────────────────────────────────────
  final Rx<ProductModel?> selectedProduct  = Rx<ProductModel?>(null);
  final Rx<LoadState> detailLoadState  = LoadState.idle.obs;
  final RxString detailError      = ''.obs;

  // ── Helpers ────────────────────────────────────────────────────────────────
  List<ProductModel> productsForTab(int index) => productMap[_categoryKeys[index]] ?? [];
  RxBool isLoading = false.obs;
  RxBool wishlisted = false.obs;
  RxString error = ''.obs;
  RxInt quantity = 1.obs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  // ── Fetch single product by ID ────────────────────────────────────────────
  // Called from ProductDetailScreen — no widget state involved.
  Future<void> fetchProductById(int id) async {
    detailLoadState.value = LoadState.loading;
    detailError.value     = '';
    selectedProduct.value = null;
    isLoading.value = true;
    try {
      final res = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/products/$id'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        selectedProduct.value = ProductModel.fromJson(data);
        detailLoadState.value = LoadState.success;
        isLoading.value = false;
      } else {
        throw Exception('HTTP ${res.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      detailError.value     = e.toString().replaceAll('Exception:$e ', '');
      Logger.log("$e");
      detailLoadState.value = LoadState.error;
    }finally{
      isLoading.value = false;
    }
  }

  // ── Fetch all tab lists ───────────────────────────────────────────────────
  Future<void> fetchAll() async {
    loadState.value    = LoadState.loading;
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _fetchAllProducts(),
        _fetchProductsByCategory(_mensKey),
        _fetchProductsByCategory(_womensKey),
      ]);
      productMap[_allKey]    = results[0];
      productMap[_mensKey]   = results[1];
      productMap[_womensKey] = results[2];
      loadState.value = LoadState.success;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      loadState.value    = LoadState.error;
    }
  }

  Future<void> refresh() => fetchAll();

  // ── Private network calls ─────────────────────────────────────────────────
  Future<List<ProductModel>> _fetchAllProducts() async {
    final res = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/products'),
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch products');
  }

  Future<List<ProductModel>> _fetchProductsByCategory(
      String category) async {
    final encoded = Uri.encodeComponent(category);
    final res = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/products/category/$encoded'),
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch products for $category');
  }

  // fetchCategories kept public in case needed elsewhere
  Future<List<String>> fetchCategories() async {
    final res = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/products/categories'),
    );
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List<dynamic>).cast<String>();
    }
    throw Exception('Failed to fetch categories');
  }
}