// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:sri_mahalakshmi/core/utility/app_loader.dart';
// import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
// import 'package:sri_mahalakshmi/presentation/Authentication/controllers/login_controller.dart';
//
// import '../../../core/widgets/animated_buttons.dart';
//
// class OTPVerificationScreen extends StatefulWidget {
//   final String mobileNumber;
//
//   const OTPVerificationScreen({super.key, required this.mobileNumber});
//
//   @override
//   State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
// }
//
// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   final TextEditingController otpController = TextEditingController();
//   late final LoginController controller;
//   bool isVerifying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(LoginController());
//   }
//
//   @override
//   void dispose() {
//     otpController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return AppLoader.circularLoader();
//         }
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),
//
//                 Text(
//                   "OTP Verification",
//                   style: theme.textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Enter the 5-digit code sent to\n${widget.mobileNumber}",
//                   textAlign: TextAlign.center,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//
//                 PinCodeTextField(
//                   appContext: context,
//                   controller: otpController,
//                   autoDisposeControllers: false,
//                   length: 5,
//                   keyboardType: TextInputType.number,
//                   animationType: AnimationType.scale,
//                   cursorColor: Colors.black,
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(10),
//                     fieldHeight: 55,
//                     fieldWidth: 45,
//                     inactiveColor: Colors.grey.shade300,
//                     activeColor: Colors.blueAccent,
//                     selectedColor: Colors.blue,
//                     activeFillColor: Colors.white,
//                     selectedFillColor: Colors.white,
//                     inactiveFillColor: Colors.white,
//                   ),
//                   enableActiveFill: true,
//                   onChanged: (_) {},
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 TextButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("OTP resent successfully")),
//                     );
//                   },
//                   child: const Text(
//                     "Resend OTP",
//                     style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 AnimatedButton(
//                   text: 'Verify Otp',
//                   onPressed: () {
//                     controller.otpVerify(
//                       mobileNo: widget.mobileNumber.trim(),
//                       otp: otpController.text.trim(),
//                     );
//                   },
//                 ),
//                 const Spacer(),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sri_mahalakshmi/core/utility/app_textstyles.dart';

import '../../../core/utility/app_colors.dart';
import '../../../core/utility/app_loader.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../controllers/login_controller.dart';

class OtpScreen extends StatefulWidget {
  final String? mobileNumber;

  const OtpScreen({super.key, this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otp = TextEditingController();
  final LoginController otpController = LoginController();
  String? otpError;
  String verifyCode = '';
  StreamController<ErrorAnimationType>? errorController;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String mobileNumber = widget.mobileNumber.toString() ?? '';

    return Scaffold(
      body: Obx(() {
        if (otpController.isLoading.value) {
          return AppLoader.circularLoader();
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomContainer.leftSaitArrow(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                SizedBox(height: 40),
                Text(
                  "OTP Verification",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Text(
                //     "Enter the 5-digit code sent to ${widget.mobileNumber} ",
                //     textAlign: TextAlign.center,
                //     style: theme.textTheme.bodyMedium?.copyWith(
                //       color: Colors.grey[600],
                //     ),
                //   ),
                AppTextStyles.textWithSmall(
                  text:
                      'OTP sent to ${widget.mobileNumber}, please check and enter below',
                ),
                // . If you’re not received OTP
                // SizedBox(height: 8),
                // GestureDetector(
                //   onTap: () {},
                //   child: Text(
                //     'Resend OTP',
                //
                //   ),
                // ),
                SizedBox(height: 30),

                Expanded(
                  child: PinCodeTextField(
                    onCompleted: (value) async {},

                    autoFocus: otp.text.isEmpty,
                    appContext: context,
                    // pastedTextStyle: TextStyle(
                    //   color: Colors.green.shade600,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    length: 5,

                    // obscureText: true,
                    // obscuringCharacter: '*',
                    // obscuringWidget: const FlutterLogo(size: 24,),
                    blinkWhenObscuring: true,
                    mainAxisAlignment: MainAxisAlignment.start,
                    autoDisposeControllers: false,

                    // validator: (v) {
                    //   if (v == null || v.length != 4)
                    //     return 'Enter valid 4-digit OTP';
                    //   return null;
                    // },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: 9),
                      inactiveColor: Colors.grey.shade300,
                      activeColor: Colors.blueAccent,
                      selectedColor: Colors.blue,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                    ),
                    cursorColor: AppColor.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    controller: otp,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: AppColor.lightBlack,
                        blurRadius: 5,
                      ),
                    ],
                    // validator: (value) {
                    //   if (value == null || value.length != 4) {
                    //     return 'Please enter a valid 4-digit OTP';
                    //   }
                    //   return null;
                    // },
                    // onCompleted: (value) async {},
                    onChanged: (value) {
                      debugPrint(value);
                      verifyCode = value;

                      if (otpError != null && value.isNotEmpty) {
                        setState(() {
                          otpError = null;
                        });
                      }
                    },

                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                if (otpError != null)
                  Center(child: Text(otpError!, textAlign: TextAlign.center)),
                SizedBox(height: 30),

                AnimatedButton(
                  text: 'Verify Otp',
                  onPressed: () {
                    otpController.otpVerify(
                      mobileNo: widget.mobileNumber.toString(),
                      otp: otp.text.trim(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
