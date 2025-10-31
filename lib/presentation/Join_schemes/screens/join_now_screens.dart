import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/utility/app_loader.dart';
import 'package:sri_mahalakshmi/core/utility/app_textstyles.dart';
import 'package:sri_mahalakshmi/presentation/Home/controller/home_controller.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/screens/customer_details_screen.dart';
import '../controller/scheme_controller.dart';

class JoinNowScreens extends StatelessWidget {
  final SchemeController controller = Get.put(SchemeController());

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
            image: AssetImage(AppImages.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.chevron_left),
                    ),
                    AppTextStyles.textWith600(text: 'Join New Schemes'),
                    Text(''),
                  ],
                ),
              ),

              Expanded(
                child: Obx(() {
                  return RefreshIndicator(
                    color: const Color(0xFF8B6F47),
                    backgroundColor: const Color(
                      0xFFFFF8E1,
                    ), // soft gold background
                    onRefresh: () async {
                      await controller.fetchSchemes();
                    },
                    child: controller.isLoading.value
                        ? Center(child: AppLoader.circularLoader())
                        : controller.schemeList.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: const Center(
                                child: Text(
                                  "No Schemes Found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5A4636),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.schemeList.length,
                            itemBuilder: (context, index) {
                              final scheme = controller.schemeList[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // 🟡 Background Card
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFDF3E7), // pale ivory
                                            Color(0xFFFFE6A7), // mild gold
                                            Color(
                                              0xFFF7DFA7,
                                            ), // creamy champagne
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.brown.shade200
                                                .withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(4, 6),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ✨ Decorative shimmer
                                    Positioned(
                                      right: -40,
                                      top: -40,
                                      child: Container(
                                        height: 130,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.3),
                                              Colors.transparent,
                                            ],
                                            radius: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 🪙 Logo
                                    Positioned(
                                      top: 16,
                                      left: 18,
                                      child: Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.9),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.brown.shade100,
                                              blurRadius: 5,
                                              offset: const Offset(2, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Image.asset(
                                            AppImages.log_2,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 🏷 Scheme name
                                    Positioned(
                                      top: 20,
                                      left: 90,
                                      right: 16,
                                      child: Text(
                                        scheme.schemeName,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5A4636),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),

                                    // 💬 Type
                                    Positioned(
                                      top: 60,
                                      left: 90,
                                      child: Text(
                                        "Type: ${scheme.schemeType}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.brown.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // 🔸 Divider line
                                    Positioned(
                                      top: 95,
                                      left: 30,
                                      right: 30,
                                      child: Container(
                                        height: 1.2,
                                        color: Colors.brown.shade200
                                            .withOpacity(0.5),
                                      ),
                                    ),

                                    // 💰 Amount & installments
                                    Positioned(
                                      top: 115,
                                      left: 30,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _info("Amount", "₹${scheme.chitAmt}"),
                                          const SizedBox(height: 8),
                                          _info("Installments", scheme.noIns),
                                        ],
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 18,
                                      right: 18,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF8B6F47,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          elevation: 6,
                                        ),
                                        onPressed: () {
                                          if (scheme.chitAmt == 'FLEXIBLE') {
                                            enteredAmount.value = 0;
                                            Get.bottomSheet(
                                              _flexibleAmountBottomSheet(
                                                scheme,
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(25),
                                                    ),
                                              ),
                                            );
                                          } else {
                                            Get.to(
                                              () => CustomerDetailsScreen(),
                                              arguments: scheme,
                                            );
                                          }
                                        },

                                        child: const Text(
                                          "Join Now",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final RxDouble enteredAmount = 0.0.obs;

  Widget _flexibleAmountBottomSheet(dynamic scheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.shade200.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top handle
            Center(
              child: Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),

            // Title
            Text(
              "Enter Flexible Amount",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Amount Input
            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: "Amount (₹)",
                labelStyle: TextStyle(color: Colors.brown.shade600),
                filled: true,
                fillColor: Colors.brown.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown.shade800,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                double val = double.tryParse(value) ?? 0.0;
                enteredAmount.value = val;
              },
            ),
            const SizedBox(height: 16),

            // Gold Weight Display
            Obx(() {
              double goldRate = homeController.goldAndSilverRateData.first.gold
                  .toDouble();
              double weight = (goldRate > 0)
                  ? enteredAmount.value / goldRate
                  : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gold Rate:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade600,
                    ),
                  ),
                  Text(
                    "₹${goldRate.toStringAsFixed(3)}/g",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            Obx(() {
              double goldRate = homeController.goldAndSilverRateData.first.gold
                  .toDouble();
              double weight = (goldRate > 0)
                  ? enteredAmount.value / goldRate
                  : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Equivalent Gold Weight:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade600,
                    ),
                  ),
                  Text(
                    "${weight.toStringAsFixed(2)} g",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Proceed Button with gradient
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (enteredAmount.value > 0) {
                    Get.back(); // Close BottomSheet
                    Get.to(
                          () => CustomerDetailsScreen(enteredAmount: enteredAmount.value), // ✅ pass .value
                      arguments: scheme,
                    );

                  } else {
                    Get.snackbar(
                      "Invalid Amount",
                      "Please enter a valid amount.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.shade100,
                      colorText: Colors.brown.shade700,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.orange.shade100,
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,

                    color: AppColor.black,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return RichText(
      text: TextSpan(
        text: "$title: ",
        style: const TextStyle(
          color: Color(0xFF6D4C41), // elegant brown
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Color(0xFF3E2723), // darker brown for contrast
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
