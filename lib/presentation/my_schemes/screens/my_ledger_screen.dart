import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sri_mahalakshmi/presentation/my_schemes/controller/my_scheme_controller.dart';

import '../../../core/utility/app_images.dart';
import '../../../core/utility/app_textstyles.dart';
import 'package:get/get.dart';

class MyLedgerScreen extends StatefulWidget {
  final String accNo;
  final String name;
  final String noIns;
  const MyLedgerScreen({
    super.key,
    required this.accNo,
    required this.name,
    required this.noIns,
  });

  @override
  State<MyLedgerScreen> createState() => _MyLedgerScreenState();
}

class _MyLedgerScreenState extends State<MyLedgerScreen> {
  final List<Map<String, dynamic>> ledgerData = [
    {
      "voucherNo": "V001",
      "weight": 5.0,
      "paidDate": DateTime(2025, 10, 1),
      "paidAmount": 5000,
      "goldRate": 10502,
    },
    {
      "voucherNo": "V002",
      "weight": 5.0,
      "paidDate": DateTime(2025, 11, 1),
      "paidAmount": 5000,
      "goldRate": 10600,
    },
    {
      "voucherNo": "V003",
      "weight": 5.0,
      "paidDate": DateTime(2025, 12, 1),
      "paidAmount": 5000,
      "goldRate": 10750,
    },
  ];
  final MySchemeController controller = Get.put(MySchemeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.myLedger(accNo: widget.accNo);
    });
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                  AppTextStyles.textWith600(text: 'My Ledger'),
                  Text(''),
                ],
              ),
              Expanded(
                child: Obx(() {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF26A69A), Color(0xFF80CBC4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left side
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${widget.name}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Acc No: ${widget.accNo}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right side
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'No Ins: ${widget.noIns}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ✅ Ledger header
                      Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Voucher No',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Weight',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Paid Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amount',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Gold Rate',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ✅ Ledger list
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.myLedgerData.length,
                          itemBuilder: (context, index) {
                            final item = controller.myLedgerData[index];

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text('V001')),
                                  Expanded(flex: 2, child: Text('2.0')),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.date != null
                                          ? DateFormat(
                                              'dd MMM yyyy',
                                            ).format(item.date!)
                                          : '',
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('₹${item.chitAmount}'),
                                  ),
                                  Expanded(flex: 2, child: Text('₹5000')),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
