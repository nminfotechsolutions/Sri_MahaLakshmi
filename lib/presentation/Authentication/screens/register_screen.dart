import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/widgets/animated_buttons.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/controllers/login_controller.dart';

import '../../Home/Screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String? mobileNumber;
  const RegisterScreen({super.key, this.mobileNumber});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

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
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();

  final LoginController controller = Get.put(LoginController());

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFffaf4f2),
                Color(0xFFffaf4f2),
                Color(0xFFffaf4f2),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'appLogo',
                      child: Center(
                        child: Image.asset(AppImages.log_2, height: 200),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 30),

                    // First Name
                    _buildTextFormField(
                      label: 'First Name',
                      controller: fNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter first name';
                        return null;
                      },
                      hintText: 'Enter your First Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),

                    // Last Name
                    _buildTextFormField(
                      label: 'Last Name',
                      controller: lNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter last name';
                        return null;
                      },
                      hintText: 'Enter your Last Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),

                    // Email
                    _buildTextFormField(
                      label: 'Email ID',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter email';
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                        ).hasMatch(value)) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                      hintText: 'Enter your Email ID',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),

                    // Mobile
                    _buildTextFormField(
                      label: 'Mobile Number',
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      readOnly: isReadOnly,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter mobile number';
                        if (!RegExp(r'^\d{10}$').hasMatch(value))
                          return 'Enter valid 10-digit number';
                        return null;
                      },
                      hintText: 'Enter your Mobile Number',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _buildTextFormField(
                      label: 'Password',
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                      hintText: 'Enter your Password',
                      icon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    _buildTextFormField(
                      label: 'Confirm Password',
                      controller: confirmPassController,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Confirm your password';
                        if (value != passwordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                      hintText: 'Re-enter your Password',
                      icon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // MPIN
                    _buildTextFormField(
                      label: 'Set MPIN',
                      controller: mpinController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter MPIN';
                        if (value.length != 4) return 'MPIN must be 4 digits';
                        return null;
                      },
                      hintText: 'Set your MPIN',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 30),

                    // Error message & Register Button
                    // Obx(() {
                    //   return Column(
                    //     children: [
                    //       if (controller.errorMessage.isNotEmpty)
                    //         Padding(
                    //           padding: const EdgeInsets.only(bottom: 10),
                    //           child: Text(
                    //             // controller.errorMessage.value,'',
                    //             '',
                    //             style: const TextStyle(color: Colors.red),
                    //           ),
                    //         ),
                    //
                    //     ],
                    //   );
                    // }),
                    AnimatedButton(
                      text: 'Register',
                      isLoading: controller.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await controller.registerUser(
                            pinCode: '',
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
                          if (success) {
                            Get.offAll(() => HomeScreen());
                          } else {
                            // ❌ Show error message from controller
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(controller.errorMessage.value),
                              ),
                            );
                          }
                        }
                      },
                    ),
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
                              ..onTap = () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColor.lightBlack,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          style: const TextStyle(color: Colors.black),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black45),
            prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
