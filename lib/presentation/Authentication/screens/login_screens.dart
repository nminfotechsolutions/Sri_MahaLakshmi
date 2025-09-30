import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/widgets/animated_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/screens/register_screen.dart';
import 'package:sri_mahalakshmi/presentation/Home/Screens/home_screen.dart';

import '../../../core/utility/app_colors.dart';
import '../../../core/widgets/animated_navigation.dart';

class LoginScreens extends StatelessWidget {
  const LoginScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffaf4f2), // Soft beach white
                const Color(0xFFffaf4f2), // Soft beach white
                const Color(0xFFffaf4f2), // Soft beach white
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20),
                Hero(
                  tag: 'appLogo', // unique tag
                  child: Image.asset(
                    AppImages.log_2,
                    height: 150,
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 15,
                    ),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo / Title
                            Column(
                              children: [
                                // Text(
                                //   "ஸ்ரீ மகாலெக்ஷ்மி",
                                //   style: TextStyle(
                                //     fontSize: 28,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.teal.shade600,
                                //     letterSpacing: 1.5,
                                //     shadows: [
                                //       Shadow(
                                //         blurRadius: 8,
                                //         color: Colors.black.withOpacity(0.2),
                                //         offset: const Offset(1, 1),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Text(
                                  'Welcome back',
                                  style: GoogleFonts.ibmPlexSans(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                    letterSpacing: 2.5,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.darkTeal,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Login to Continue",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            Row(
                              children: [
                                Text(
                                  'Mobile Number',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Enter your Mobile Number",
                                hintStyle: const TextStyle(
                                  color: Colors.black45,
                                ),
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: Colors.teal,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.teal,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.teal,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Text(
                                  'Password',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Enter your Password",
                                hintStyle: const TextStyle(
                                  color: Colors.black45,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.teal,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.teal,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.teal,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),

                            AnimatedButton(text: 'Login', onPressed: () {
                              AnimatedNavigation.navigateWithAnimation(
                                context,
                                const HomeScreen(),
                              );
                            }),
                            SizedBox(height: 30),

                            Text.rich(
                              TextSpan(
                                text: "Don't have an Account? ",
                                style: const TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: "Sign up",
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.lightBlack.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        AnimatedNavigation.navigateWithAnimation(
                                          context,
                                          const RegisterScreen(),
                                        );
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
