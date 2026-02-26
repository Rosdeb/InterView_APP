
import 'dart:convert';
import 'package:app_interview/Utils/Logger/logger.dart';
import 'package:app_interview/Utils/Token_Services/token_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/AppConstant/app_contants.dart';


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

  void selectTab(int index) {
    selectedIndex.value = index;
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> loginUser({required BuildContext context,String? name, String? password}) async {

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

        }
        return true;
      } else if (response.statusCode == 400) {
        Logger.log("Invalid credentials");
        return false;
      } else {
        Logger.log("Server error");
        return false;
      }
    } catch (e) {
      Logger.log("Exception: $e");
      return false;
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