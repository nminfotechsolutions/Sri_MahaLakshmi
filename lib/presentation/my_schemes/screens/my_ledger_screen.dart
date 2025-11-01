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
  final MySchemeController controller = Get.put(MySchemeController());

  @override
  void initState() {
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
              // 🔹 App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    AppTextStyles.textWith600(text: 'My Ledger'),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: Obx(() {
                  final ledgerList = controller.myLedgerData;

                  final totalAmount = ledgerList.fold<num>(0, (sum, item) {
                    final amt = num.tryParse(item.collection.toString()) ?? 0;
                    return sum + amt;
                  });

                  final totalMetValue = ledgerList.fold<num>(
                    0,
                        (sum, item) => sum + (item.metValue ?? 0),
                  );

                  final showMetValue = ledgerList.any(
                        (item) => item.TYPE == "G",
                  );

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
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total Collection: ₹${totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.grey.shade200,
                              ),
                              dataRowColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                states.contains(MaterialState.selected)
                                    ? Colors.teal.shade50
                                    : Colors.white,
                              ),
                              columnSpacing: 24,
                              border: TableBorder.symmetric(
                                inside: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.2,
                                ),
                              ),
                              columns: [
                                const DataColumn(label: Text('SNo')),
                                if (showMetValue)
                                  const DataColumn(label: Text('Weight')),
                                const DataColumn(label: Text('Paid Date')),
                                const DataColumn(label: Text('Amount')),
                                const DataColumn(label: Text('Gold Rate')),
                                const DataColumn(label: Text('TransId')),
                              ],
                              rows: [
                                ...List.generate(ledgerList.length, (index) {
                                  final item = ledgerList[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      if (showMetValue)
                                        DataCell(
                                          Text(
                                            (item.metValue ?? 0)
                                                .toStringAsFixed(3),
                                          ),
                                        ),
                                      DataCell(
                                        Text(
                                          item.date != null
                                              ? DateFormat(
                                            'dd MMM yyyy',
                                          ).format(item.date!)
                                              : '',
                                        ),
                                      ),
                                      DataCell(
                                        Text('₹${item.collection ?? ''}'),
                                      ),
                                      DataCell(
                                        Text(item.goldRate?.toString() ?? ''),
                                      ),
                                      DataCell(
                                        Text(item.transId?.toString() ?? ''),
                                      ),
                                    ],
                                  );
                                }),

                                // 🔹 Total Row
                                DataRow(
                                  color: MaterialStateProperty.all(
                                    Colors.teal.shade50,
                                  ),
                                  cells: [
                                    const DataCell(
                                      Text(
                                        'TOTAL',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                    if (showMetValue)
                                      DataCell(
                                        Text(
                                          totalMetValue.toStringAsFixed(3),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    const DataCell(Text('')),
                                    DataCell(
                                      Text(
                                        '₹${totalAmount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
              // 🔹 App Bar Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  AppTextStyles.textWith600(text: 'My Ledger'),
                  const SizedBox(width: 48), // For spacing symmetry
                ],
              ),

              // 🔹 Ledger Content
              Expanded(
                child: Obx(() {
                  final ledgerList = controller.myLedgerData;

                  // 🧮 Calculate totals using `collection` instead of `chitAmount`
                  final totalAmount = ledgerList.fold<num>(0, (sum, item) {
                    final amt =
                        num.tryParse(item.collection.toString() ?? '0') ?? 0;
                    return sum + amt;
                  });

                  final totalMetValue = ledgerList.fold<num>(0, (sum, item) {
                    return sum + (item.metValue ?? 0);
                  });

                  // ⚙️ Show weight column only if any entry has metValue
                  final showMetValue = ledgerList.any(
                        (item) => item.metValue != 0,
                  );

                  return Column(
                    children: [
                      // 🔹 Header Info Box
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
                              // Left Info
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
                                    Text(
                                      'Total Collection: ₹${totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right Info
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

                      // 🔹 Table Header
                      Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'SNo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (showMetValue)
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  'Weight',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Paid Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Amount',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Gold Rate ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'TransId',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔹 Ledger List
                      Expanded(
                        child: ListView.builder(
                          itemCount: ledgerList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == ledgerList.length) {
                              // ✅ Total Row
                              return Container(
                                color: Colors.teal.shade50,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Text(
                                        'TOTAL',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                    if (showMetValue)
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          totalMetValue.toStringAsFixed(2),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    const Expanded(flex: 3, child: SizedBox()),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '₹${totalAmount.toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Expanded(flex: 2, child: SizedBox()),
                                    const Expanded(flex: 2, child: SizedBox()),
                                  ],
                                ),
                              );
                            }

                            final item = ledgerList[index];
                            final rowColor = index.isEven
                                ? Colors.white
                                : Colors.grey[50];

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: rowColor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(item.sNo ?? ''),
                                  ),
                                  if (showMetValue)
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.metValue.toString(),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.date != null
                                          ? DateFormat(
                                        'dd MMM yyyy',
                                      ).format(item.date!)
                                          : '',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '₹${item.collection ?? ''}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      item.goldRate?.toString() ?? '',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      item.transId?.toString() ?? '',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
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
