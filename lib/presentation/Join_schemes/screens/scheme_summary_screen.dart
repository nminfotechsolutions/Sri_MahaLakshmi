import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/controller/scheme_controller.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/model/scheme_type_response.dart';
import 'package:sri_mahalakshmi/presentation/my_schemes/model/my_scheme_response.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../../../core/utility/app_textstyles.dart';
import '../../Home/controller/home_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SchemeSummaryScreen extends StatefulWidget {
  final String fullName;
  final String address;
  final String state;
  final String country;
  final String pinCode;
  final String mobile;
  final String aadhar;
  final String pAN;
  final String page;

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
    required this.page,
  });

  @override
  State<SchemeSummaryScreen> createState() => _SchemeSummaryScreenState();
}

class _SchemeSummaryScreenState extends State<SchemeSummaryScreen> {
  final HomeController controller = Get.put(HomeController());
  final SchemeController schemeController = Get.put(SchemeController());

  final today = DateFormat('dd MMM yyyy').format(DateTime.now());

  late final Object scheme;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>;
    final schemeJson = args['scheme'] as Map<String, dynamic>;

    scheme = widget.page == 'MyPlan'
        ? MySchemeData.fromJson(schemeJson)
        : SchemeData.fromJson(schemeJson);

    controller.fetchTodayRate();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // Helper getters
  String get schemeName => widget.page == 'MyPlan'
      ? (scheme as MySchemeData).schemeName
      : (scheme as SchemeData).schemeName;

  String? get accNo =>
      widget.page == 'MyPlan' ? (scheme as MySchemeData).accNo : null;

  num get schemeAmount => widget.page == 'MyPlan'
      ? (scheme as MySchemeData).schemeAmount
      : (scheme as SchemeData).amount;

  String get noOfIns => widget.page == 'MyPlan'
      ? (scheme as MySchemeData).noIns
      : (scheme as SchemeData).noIns;

  int? get regNo =>
      widget.page == 'MyPlan' ? (scheme as MySchemeData).regNo : null;

  int get chitId => widget.page == 'MyPlan'
      ? (scheme as MySchemeData).chitId
      : (scheme as SchemeData).chitId;

  // Razorpay order creation
  Future<String> _createRazorpayOrder(double amount) async {
    final url = Uri.parse('https://api.razorpay.com/v1/orders');
    const apiKey = 'rzp_live_RJnEb064whmCZZ';
    const apiSecret = 'yvv0xU0n6qeIOC7KnddLArUH';

    final headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret')),
      'Content-Type': 'application/json',
    };

    final body = convert.jsonEncode({
      'amount': (amount * 100).toInt(), // amount in paise
      'currency': 'INR',
      'payment_capture': 1,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to create Razorpay order');
    }
  }

  void _openRazorpayCheckout(double amount) async {
    try {
      final orderId = await _createRazorpayOrder(amount);
      var options = {
        'key': 'rzp_live_RJnEb064whmCZZ',
        'amount': (amount * 100).toInt(),
        'name': widget.fullName,
        'description': 'Gold Chits',
        'order_id': orderId,
        'prefill': {'contact': widget.mobile, 'email': ''},
        'retry': {'enabled': true, 'max_count': 1},
        'external': {
          'wallets': ['paytm'],
        },
      };
      _razorpay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
      Get.snackbar('Error', 'Failed to open payment gateway');
    }
  }

  // Razorpay Callbacks
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    // Call your API after successful payment
    final goldRate = controller.goldAndSilverRateData.first.gold;
    final silverRate = controller.goldAndSilverRateData.first.silver;

    schemeController.newSchemeJoin(
      accNo: accNo ?? '',
      schemeName: schemeName,
      schemeId: '1',
      groupCode: '',
      schemeAmount: schemeAmount.toString(),
      regNo: regNo.toString() ?? '',
      name: widget.fullName,
      address1: widget.address.toString(),
      city: '',
      state: widget.state,
      country: widget.country,
      pincode: widget.pinCode,
      mobileNo: widget.mobile,
      aadharNo: widget.aadhar,
      panNo: widget.pAN,
      chitId: chitId,
      goldRate: goldRate,
      silverRate: silverRate,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Failed: ${response.code} - ${response.message}');
    Get.snackbar('Payment Failed', response.message ?? 'Error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet Selected: ${response.walletName}');
  }

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
                      const SizedBox(width: 20),
                      AppTextStyles.textWith600(text: 'Scheme Summary'),
                    ],
                  ),
                ),

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
                            "Monthly Gold Savings Plan $schemeName",
                            style: const TextStyle(
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
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Scheme Amount",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₹$schemeAmount/month",
                                      style: const TextStyle(
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
                                    const Text(
                                      "Installments",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$noOfIns months",
                                      style: const TextStyle(
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

                // Gold & Silver Rate Card
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
                                const Text(
                                  "Today's Gold Rate",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Obx(() {
                                  if (controller
                                      .goldAndSilverRateData
                                      .isEmpty) {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      '₹${controller.goldAndSilverRateData.first.gold}/ gram',
                                      style: const TextStyle(
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
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Today's Silver Rate",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Obx(() {
                                  if (controller
                                      .goldAndSilverRateData
                                      .isEmpty) {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      '₹${controller.goldAndSilverRateData.first.silver}/ gram',
                                      style: const TextStyle(
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
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: AnimatedButton(
            text: 'Join New Scheme',
            onPressed: () {
              double amount = schemeAmount.toDouble();
              _openRazorpayCheckout(amount);
            },
          ),
        ),
      ),
    );
  }
}

//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
// import 'package:sri_mahalakshmi/core/utility/app_images.dart';
// import 'package:sri_mahalakshmi/presentation/Authentication/models/customer_response.dart';
// import 'package:sri_mahalakshmi/presentation/Join_schemes/controller/scheme_controller.dart';
// import 'package:sri_mahalakshmi/presentation/Join_schemes/model/scheme_type_response.dart';
//
// import '../../../core/widgets/animated_buttons.dart';
// import '../../../core/utility/app_textstyles.dart';
// import '../../Home/controller/home_controller.dart';
// import '../../my_schemes/model/my_scheme_response.dart';
//
// class SchemeSummaryScreen extends StatefulWidget {
//   final String fullName;
//   final String address;
//   final String state;
//   final String country;
//   final String pinCode;
//   final String mobile;
//   final String aadhar;
//   final String pAN;
//   final String page;
//
//   const SchemeSummaryScreen({
//     super.key,
//     required this.fullName,
//     required this.address,
//     required this.state,
//     required this.country,
//     required this.pinCode,
//     required this.mobile,
//     required this.aadhar,
//     required this.pAN,
//     required this.page,
//   });
//
//   @override
//   State<SchemeSummaryScreen> createState() => _SchemeSummaryScreenState();
// }
//
// class _SchemeSummaryScreenState extends State<SchemeSummaryScreen> {
//   final HomeController controller = Get.put(HomeController());
//   final SchemeController schemeController = Get.put(SchemeController());
//
//   final today = DateFormat('dd MMM yyyy').format(DateTime.now());
//
//   late final Object scheme;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Load scheme data from Get.arguments
//     final args = Get.arguments as Map<String, dynamic>;
//     final schemeJson = args['scheme'] as Map<String, dynamic>;
//
//     scheme = widget.page == 'MyPlan'
//         ? MySchemeData.fromJson(schemeJson)
//         : SchemeData.fromJson(schemeJson);
//
//     controller.fetchTodayRate();
//   }
//
//   // ✅ Helper getters to safely access fields
//   String get schemeName => widget.page == 'MyPlan'
//       ? (scheme as MySchemeData).schemeName
//       : (scheme as SchemeData).schemeName;
//
//   String? get accNo =>
//       widget.page == 'MyPlan' ? (scheme as MySchemeData).accNo : null;
//
//   num get schemeAmount => widget.page == 'MyPlan'
//       ? (scheme as MySchemeData).schemeAmount
//       : (scheme as SchemeData).amount;
//
//   String get noOfIns => widget.page == 'MyPlan'
//       ? (scheme as MySchemeData).noIns
//       : (scheme as SchemeData).noIns;
//
//   int? get regNo =>
//       widget.page == 'MyPlan' ? (scheme as MySchemeData).regNo : null;
//
//   int get chitId => widget.page == 'MyPlan'
//       ? (scheme as MySchemeData).chitId
//       : (scheme as SchemeData).chitId;
//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments as Map<String, dynamic>;
//     final scheme = SchemeData.fromJson(args['scheme'] as Map<String, dynamic>);
//
//     // Dynamically decide model type based on available keys or context
//
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             colorFilter: ColorFilter.mode(
//               Colors.white.withOpacity(0.8),
//               BlendMode.lighten,
//             ),
//             image: AssetImage(AppImages.bg),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 15,
//                     horizontal: 15,
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => Get.back(),
//                         icon: const Icon(Icons.chevron_left),
//                       ),
//                       SizedBox(width: 20),
//                       AppTextStyles.textWith600(text: 'Scheme Summary'),
//                     ],
//                   ),
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF009688), Color(0xFF4DB6AC)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.teal.withOpacity(0.3),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 24,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Monthly Gold Savings Plan ${scheme.schemeName}",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 0.5,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 12),
//                           const Divider(color: Colors.white54),
//                           const SizedBox(height: 12),
//
//                           // Amount & Installments
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Scheme Amount",
//                                       style: TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       "₹$schemeAmount/month",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "Installments",
//                                       style: TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       "${scheme.noIns} months",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 16),
//
//                           Align(
//                             alignment: Alignment.bottomRight,
//                             child: Text(
//                               "Date: $today",
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // 🪙 Gold & Silver Rate Card
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Card(
//                     color: AppColor.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 18,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Today's Gold Rate",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                                 SizedBox(height: 6),
//                                 Obx(() {
//                                   if (controller
//                                       .goldAndSilverRateData
//                                       .isEmpty) {
//                                     return Text(
//                                       'Loading...',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                       ),
//                                     );
//                                   } else {
//                                     return Text(
//                                       '₹${controller.goldAndSilverRateData.first.gold}/ gram',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 17,
//                                         color: Colors.black87,
//                                       ),
//                                     );
//                                   }
//                                 }),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "Today's Silver Rate",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                                 SizedBox(height: 6),
//                                 Obx(() {
//                                   if (controller
//                                       .goldAndSilverRateData
//                                       .isEmpty) {
//                                     return Text(
//                                       'Loading...',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                       ),
//                                     );
//                                   } else {
//                                     return Text(
//                                       '₹${controller.goldAndSilverRateData.first.silver}/ gram',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 17,
//                                         color: Colors.black87,
//                                       ),
//                                     );
//                                   }
//                                 }),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//                 Image.asset(AppImages.guarante),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//           child: AnimatedButton(
//             text: 'Join New Scheme',
//             onPressed: () {
//               final goldRate = controller.goldAndSilverRateData.first.gold;
//               final silverRate = controller.goldAndSilverRateData.first.silver;
//               schemeController.newSchemeJoin(
//                 accNo: accNo ?? '',
//                 schemeName: scheme.schemeName,
//                 schemeId: '1',
//                 groupCode: '',
//                 schemeAmount: schemeAmount.toString() ?? '',
//                 regNo: regNo.toString() ?? '',
//                 name: widget.fullName,
//                 address1: widget.address.toString() ?? '',
//                 city: '',
//                 state: widget.state,
//                 country: widget.country,
//                 pincode: widget.pinCode,
//                 mobileNo: widget.mobile,
//                 aadharNo: widget.aadhar,
//                 panNo: widget.pAN,
//                 chitId: scheme.chitId,
//                 goldRate: goldRate,
//                 silverRate: silverRate,
//               );
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   const SnackBar(
//               //     content: Text("Successfully Joined the Scheme!"),
//               //   ),
//               // );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
