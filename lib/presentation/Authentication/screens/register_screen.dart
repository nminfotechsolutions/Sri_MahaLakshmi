import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/widgets/animated_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/controllers/login_controller.dart';

import '../../../core/utility/app_colors.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  final String? mobileNumber;
  const RegisterScreen({super.key, this.mobileNumber});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confrimPassController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();

  final LoginController controller = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    if (widget.mobileNumber != null && widget.mobileNumber!.isNotEmpty) {
      mobileController.text = widget.mobileNumber!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly =
        widget.mobileNumber != null && widget.mobileNumber!.isNotEmpty;
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
                const Color(0xFFffaf4f2),
                const Color(0xFFffaf4f2),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20),
                Hero(
                  tag: 'appLogo',
                  child: Image.asset(AppImages.log_2, height: 150),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
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
                        "Sign up to get started",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'First Name',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: fNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your First Name",
                          hintStyle: const TextStyle(color: Colors.black45),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.teal),
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
                      Text(
                        'Last Name',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: lNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your Last Name",
                          hintStyle: const TextStyle(color: Colors.black45),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.teal),
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

                      // Email
                      Text(
                        'Email ID',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your Email ID",
                          hintStyle: const TextStyle(color: Colors.black45),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.teal),
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

                      Text(
                        'Mobile Number',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        readOnly: isReadOnly,
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your Mobile Number",
                          hintStyle: const TextStyle(color: Colors.black45),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.teal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.teal),
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

                      // Password
                      Text(
                        'Password',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your Password",
                          hintStyle: const TextStyle(color: Colors.black45),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.teal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.teal),
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

                      // Confirm Password
                      Text(
                        'Confirm Password',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: confrimPassController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Re-enter your Password",
                          hintStyle: const TextStyle(color: Colors.black45),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.teal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.teal),
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
                      const SizedBox(height: 30),
                      Obx(() {
                        return Column(
                          children: [
                            if (controller.errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            AnimatedButton(
                              text: 'Register',
                              isLoading: controller.isLoading,
                              onPressed: () {
                                controller.registerUser(
                                  fName: fNameController.text.trim(),
                                  lName: lNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  mobileNo: mobileController.text.trim(),
                                  aadhar: aadharController.text.trim(),
                                  pan: panController.text.trim(),
                                  address1: address1Controller.text.trim(),
                                  city: cityController.text.trim(),
                                  state: stateController.text.trim(),
                                  country: countryController.text.trim(),
                                  password: passwordController.text.trim(),
                                  mpin: mpinController.text.trim(),
                                );
                              },
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 30),

                      // Sign In Link
                      Text.rich(
                        TextSpan(
                          text: "Already have an Account? ",
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColor.lightBlack.withOpacity(0.5),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
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
