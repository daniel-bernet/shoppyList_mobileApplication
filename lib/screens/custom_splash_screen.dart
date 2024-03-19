import 'package:flutter/material.dart';

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF434153);
    Color gradientEndColor =
        const Color(0xFF2B2A3A);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              primaryColor,
              gradientEndColor,
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo/shoppylist.png',
            width: 220,
            height: 220,
          ),
        ),
      ),
    );
  }
}
