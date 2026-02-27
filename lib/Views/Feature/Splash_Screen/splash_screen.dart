import 'package:app_interview/Controller/NetworkService/networkservice.dart';
import 'package:app_interview/Utils/Token_Services/token_services.dart';
import 'package:app_interview/Views/Feature/Auth/Login_screen/login_screen.dart';
import 'package:app_interview/Views/Feature/Splash_Screen/widgets/glassBottomCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Splash screen with app initialization and navigation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    initializeApp();
    //_startApp();
  }


  // Future<void> _startApp() async{
  //   await Future.delayed(const Duration(milliseconds:900 ));
  //   await TokenService().init();
  //   final token = TokenService().getToken();
  //   if (token != null && token.isNotEmpty){
  //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => BottomMenuWrappers()), (Route<dynamic> route) => false,);
  //   }else{
  //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false,);
  //     }
  //   }


  Future<void> initializeApp() async {
    await TokenService().init();
    Get.put(NetworkController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //---> Background Gradient color ---->
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF84B179),
                  Color(0xFFE8F5BD),
                  Color(0xFFC7EABB),
                ],
                stops: [0.1, 0.5, 0.9],
              ),
            ),
          ),

          //-----> Glowing orb effects
          Positioned(
            bottom: 100,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.deepPurple.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          //<----> Main Character Image
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/ai_icon1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          //-----> Bottom frosted glass card
          GlassBottomCard(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );

            },
          )
        ],
      ),
    );
  }
}
