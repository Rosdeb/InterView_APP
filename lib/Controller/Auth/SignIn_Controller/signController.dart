
import 'dart:convert';
import 'package:app_interview/Utils/Logger/logger.dart';
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

  Future<void> loginUser(String email, String password) async {
    final url = "${AppConstants.BASE_URL}/api/v1/auth/login-email";
    //---->  var fcmToken = await PrefsHelper.getString(AppConstants.fcmToken);
    if (!await hasInternetConnection()) {
      Logger.log("No Internet Please check your internet connection.");
      return;
    }
    if (!accepted.value) {
      Logger.log("Terms conditions Please select the terms conditions");
      return;
    }
    //---> user test for this mail test10777@yopmail.com
    final body = {
      'username': email,
      'password': password,
      // 'fcmToken':fcmToken,
    };

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // //<-----> print(" Registered successfully: ${data['message']}"); <----->
        // String accessToken = data['data']['attributes']['tokens']['access']['token'];
        // String refreshToken = data['data']['attributes']['tokens']['refresh']['token'];
        // String userId = data['data']['attributes']['user']['id'];
        // bool isSubscribed = data['data']['attributes']['user']['isSubscribed'];
        // bool isEmailVerified = data['data']['attributes']['user']['isEmailVerified'];
        //
        // print("isSubscribed:$isSubscribed");
        //
        // await TokenService().saveToken(accessToken);
        // await TokenService().saveRefreshToken(refreshToken);
        // await TokenService().saveUserId(userId);
        //await TokenService().saveEmail(email);

        // if(!isEmailVerified){
        //   Get.offAll(()=> VerifyScreen(email: email,verify:false));
        // }
        // else if (isSubscribed==true){
        //    Get.offAll(BottomMenuWrappers());
        // }else{
        //   Get.off(() => const Subscriptions(navigateAfterSuccess: true));
        // }
        // return true;
      } else {
        String message = "Something went wrong";
        try {
          if (response.body.isNotEmpty) {
            final body = jsonDecode(response.body);
            if (body.containsKey('message') && body['message'] != null) {
              message = body['message'].toString();
            }
          }
        } catch (e) {
          Logger.log("Error parsing error response: $e");
        }
        isLoading.value = false;
        return;
      }
    }  finally {
      isLoading.value = false;
    }
  }


}