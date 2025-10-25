import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/utility/app_textstyles.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/screens/login_screens.dart';
import 'dart:async';

import 'package:sri_mahalakshmi/presentation/Home/Screens/home_screen.dart';

import 'core/utility/app_colors.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => LoginScreens());
    }
  }

  @override
  void initState() {
    super.initState();

    // Animation controller for logo
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Timer(Duration(seconds: 4), () {
      // Get.offAll(() => LoginScreens());
      _checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFffaf4f2),
              const Color(0xFFffaf4f2),
              const Color(0xFFffaf4f2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppImages.log_2,
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ஸ்ரீ மகாலக்ஷ்மி நகை மாளிகை',
                      style: GoogleFonts.tiroTamil(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D4C41), // Elegant brown tone
                          letterSpacing: 1.2,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 35),

                    Text(
                      'அழகும் நம்பிக்கையும் ஒன்றாகும் இடம்',
                      style: GoogleFonts.tiroTamil(
                        textStyle: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8D6E63),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
