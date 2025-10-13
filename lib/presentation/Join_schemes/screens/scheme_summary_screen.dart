import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/models/customer_response.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/controller/scheme_controller.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/model/scheme_type_response.dart';

import '../../../core/widgets/animated_buttons.dart';
import '../../../core/utility/app_textstyles.dart';
import '../../Home/controller/home_controller.dart';

class SchemeSummaryScreen extends StatefulWidget {
  final String fullName;
  final String address;
  final String state;
  final String country;
  final String pinCode;
  final String mobile;
  final String aadhar;
  final String pAN;

  const SchemeSummaryScreen({
    super.key,
    required this.fullName,
    required this.address,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.mobile,
    required this.aadhar,
    required this.pAN,
  });

  @override
  State<SchemeSummaryScreen> createState() => _SchemeSummaryScreenState();
}

class _SchemeSummaryScreenState extends State<SchemeSummaryScreen> {
  final HomeController controller = Get.put(HomeController());
  final SchemeController schemeController = Get.put(SchemeController());

  final today = DateFormat('dd MMM yyyy').format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.fullName);
    controller.fetchTodayRate();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final scheme = SchemeData.fromJson(args['scheme'] as Map<String, dynamic>);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    SizedBox(width: 20),
                    AppTextStyles.textWith600(text: 'Scheme Summary'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF009688), Color(0xFF4DB6AC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Monthly Gold Savings Plan ${scheme.schemeName}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white54),
                        const SizedBox(height: 12),

                        // Amount & Installments
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Scheme Amount",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "₹${scheme.amount.toString() ?? ''} / month",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Installments",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${scheme.noIns} months",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Date
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Date: $today",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🪙 Gold & Silver Rate Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  color: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Gold Rate",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 6),
                              Obx(() {
                                if (controller.goldAndSilverRateData.isEmpty) {
                                  return Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '₹${controller.goldAndSilverRateData.first.gold}/ gram',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Today's Silver Rate",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 6),
                              Obx(() {
                                if (controller.goldAndSilverRateData.isEmpty) {
                                  return Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '₹${controller.goldAndSilverRateData.first.silver}/ gram',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Image.asset(AppImages.guarante),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: AnimatedButton(
            text: 'Join New Scheme',
            onPressed: () {
              final goldRate = controller.goldAndSilverRateData.first.gold;
              final silverRate = controller.goldAndSilverRateData.first.silver;
              schemeController.newSchemeJoin(
                schemeName: scheme.schemeName,
                schemeId: '1',
                groupCode: '',
                schemeAmount: scheme.chitAmt.toString(),
                regNo: '',
                name: widget.fullName,
                address1: widget.address.toString()?? '',
                city: '',
                state: widget.state,
                country: widget.country,
                pincode: widget.pinCode,
                mobileNo: widget.mobile,
                aadharNo: widget.aadhar,
                panNo: widget.pAN,
                chitId: scheme.chitId,
                goldRate:goldRate,
                silverRate: silverRate

              );
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text("Successfully Joined the Scheme!"),
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
