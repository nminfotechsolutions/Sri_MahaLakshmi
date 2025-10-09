import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/utility/app_loader.dart';
import 'package:sri_mahalakshmi/core/utility/app_textstyles.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/screens/customer_details_screen.dart';
import '../controller/scheme_controller.dart';

class JoinNowScreens extends StatelessWidget {
  final SchemeController controller = Get.put(SchemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                  color: const Color(
                    0xFF8B6F47,
                  ), // elegant antique gold spinner
                  backgroundColor: const Color(
                    0xFFFFF8E1,
                  ), // soft gold background
                  onRefresh: () async {
                    await controller.fetchSchemes(); // your refresh method
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
                                          Color(0xFFF7DFA7), // creamy champagne
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
                                      color: Colors.brown.shade200.withOpacity(
                                        0.5,
                                      ),
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

                                  // 🔘 View Button
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
                                        Get.to(CustomerDetailsScreen());
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
