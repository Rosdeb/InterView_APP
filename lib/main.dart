import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'Controller/Auth/User_Controller/user_controller.dart';
import 'Controller/ProductController/product_controller.dart';
import 'Helpers/route.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialBinding: _AppBindings(),
    initialRoute: AppRoutes.splashScreen,
    getPages: AppRoutes.page,
    theme: ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6B00),
        brightness: Brightness.light,
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6B00),
        brightness: Brightness.dark,
      ),
    ),
    themeMode: ThemeMode.system,
    );
  }
}

class _AppBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(UserController(), permanent: true);
    Get.put(ProductController(), permanent: true);
  }

}



