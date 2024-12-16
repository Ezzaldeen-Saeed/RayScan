import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key, required this.nextScreen});

  final Widget nextScreen;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/Lottie/2.json",
            ),
          ),
        ],
      ),
      splashIconSize: 500,
      nextScreen: nextScreen,
      backgroundColor: Colors.white,
      duration: 500,
    );
  }
}
