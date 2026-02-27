// Controller/UserController/user_controller.dart
// Owns: fetched user profile + logout.
// Token management stays in TokenService (already exists in your project).

import 'dart:convert';
import 'package:app_interview/Utils/Logger/logger.dart';
import 'package:app_interview/Views/Feature/Auth/Login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Models/user_model/user_model.dart';
import '../../../Utils/AppConstant/app_contants.dart';
import '../../../Utils/Token_Services/token_services.dart';

class UserController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading    = false.obs;

  //<----->  FakeStore always returns user id=1 for test credentials. <------>
  Future<void> fetchUser({int id = 1}) async {
    isLoading.value = true;
    try {
      final res = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/users/$id'),
      );
      if (res.statusCode == 200) {
        user.value = UserModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
        Logger.log("successfully");
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }
  void logout() {
    user.value = null;
    TokenService().clearAll();
    Get.offAll(const LoginScreen());
  }
}