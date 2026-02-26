import 'dart:ui';
import 'package:app_interview/Views/Feature/Auth/Login_screen/login_screen.dart';
import 'package:app_interview/Views/Feature/Splash_Screen/widgets/glassBottomCard.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
                  Color(0xFFFF8C00),
                  Color(0xFFF4F0E4),
                  Color(0xFFFF8C00),
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
            top: 120,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Welcome to back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
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
