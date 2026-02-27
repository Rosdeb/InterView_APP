
import 'dart:convert';
import 'package:app_interview/Utils/Logger/logger.dart';
import 'package:app_interview/Utils/Token_Services/token_services.dart';
import 'package:app_interview/Views/Bottom_nav/bottom_menu_wrapper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/AppConstant/app_contants.dart';
import '../../NetworkService/networkservice.dart';


class SingInController extends GetxController {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();

  final RxInt selectedIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool accepted = false.obs;
  final RxBool googleLoading = false.obs;
  final RxBool appleLoading = false.obs;


  void toggleAccepted(bool? value) {
    accepted.value = value ?? false;
  }


  Future<void> loginUser({required BuildContext context,String? name, String? password}) async {

    final networkController = Get.find<NetworkController>();

    if (!networkController.isOnline.value) {
      throw Exception('No internet connection');
    }

    final url = "${AppConstants.BASE_URL}/auth/login";
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'password': password,
        }),
      );

      Logger.log("Status Code: ${response.statusCode}");
      Logger.log("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await TokenService().saveToken(token);
        Logger.log("Login success");
        Logger.log("Token: $token");
        _showSnackBar(context, 'Login successful! Welcome back 👋', Colors.green);

        if(context.mounted){
          Get.offAll(BottomMenuWrappers(), transition: Transition.cupertino);
        }
        return;
      } else if (response.statusCode == 400) {
        isLoading.value = false;
        Logger.log("Invalid credentials");
        return;
      } else {
        isLoading.value = false;
        Logger.log("Server error");
        return;
      }
    } catch (e) {
      isLoading.value = false;
      Logger.log("Exception: $e");
      return;
    } finally {
      isLoading.value = false;
    }
  }


  void _showSnackBar(BuildContext context, String message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


}