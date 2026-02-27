import 'dart:convert';
import 'package:app_interview/Utils/AppConstant/app_contants.dart';
import 'package:app_interview/Utils/Logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Models/product_model/product_model.dart';
import 'package:http/http.dart' as http;

enum LoadState { idle, loading, success, error }

/// Manages product data across categories and search functionality.
class ProductController extends GetxController {
  static const List<String> tabLabels = ['All', "Men's", "Women's"];
  final TextEditingController searchController = TextEditingController();

  static const _allKey = 'all';
  static const _mensKey = "men's clothing";
  static const _womensKey = "women's clothing";
  static const List<String> _categoryKeys = [_allKey, _mensKey, _womensKey];

  static String keyForTab(int index) => _categoryKeys[index];

  final RxMap<String, List<ProductModel>> productMap =
      <String, List<ProductModel>>{}.obs;

  final Rx<LoadState> loadState = LoadState.idle.obs;
  final RxString errorMessage = ''.obs;

  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  final Rx<LoadState> detailLoadState = LoadState.idle.obs;
  final RxString detailError = ''.obs;

  List<ProductModel> productsForTab(int index) =>
      productMap[_categoryKeys[index]] ?? [];

  RxBool isLoading = false.obs;
  RxBool wishlisted = false.obs;
  RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim().toLowerCase();
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void onSearchChanged(String value) {
    searchQuery.value = value.trim().toLowerCase();
  }

  /// Fetches a single product by ID for the detail screen.
  Future<void> fetchProductById(int id) async {
    detailLoadState.value = LoadState.loading;
    detailError.value = '';
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
      detailError.value = e.toString().replaceAll('Exception:$e ', '');
      Logger.log('$e');
      detailLoadState.value = LoadState.error;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches products for all categories.
  Future<void> fetchAll() async {
    loadState.value = LoadState.loading;
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _fetchAllProducts(),
        _fetchProductsByCategory(_mensKey),
        _fetchProductsByCategory(_womensKey),
      ]);
      productMap[_allKey] = results[0];
      productMap[_mensKey] = results[1];
      productMap[_womensKey] = results[2];
      loadState.value = LoadState.success;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      loadState.value = LoadState.error;
    } finally {
      loadState.value = LoadState.success;
    }
  }

  Future<void> refresh() => fetchAll();

  /// Returns filtered products for a tab based on current search query.
  List<ProductModel> filteredProductsForTab(int tabIndex) {
    final key = _categoryKeys[tabIndex];
    final products = productMap[key] ?? [];

    if (searchQuery.isEmpty) return products;

    return products.where((product) {
      return product.title.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

  List<ProductModel> get filteredAllProducts {
    final allProducts = productMap[_allKey] ?? [];

    if (searchQuery.isEmpty) return allProducts;

    return allProducts.where((product) {
      return product.title.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

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

  Future<List<ProductModel>> _fetchProductsByCategory(String category) async {
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