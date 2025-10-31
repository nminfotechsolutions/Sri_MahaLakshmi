import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import '../../../core/utility/app_loader.dart';
import '../Controller/menu_controller.dart';
import '../Model/transaction_history.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final MenuControllers controller = Get.put(MenuControllers());

  @override
  void initState() {
    super.initState();
    controller.transactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.ScaffoldColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0,

        title: const Text(
          "Transaction History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.transactionHistory();
          },
          child: controller.isLoading.value
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children:   [
              SizedBox(
                height: 400,
                child: Center(child: AppLoader.circularLoader()),
              ),
            ],
          )
              : controller.transactionData.isEmpty
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 250),
              Center(
                child: Text(
                  "No transactions available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          )
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(16),
            itemCount: controller.transactionData.length,
            itemBuilder: (context, index) {
              final item = controller.transactionData[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _buildTransactionCard(item),
              );
            },
          ),
        );
      }),

    );
  }

  Widget _buildTransactionCard(TransactionData item) {
    final dateFormat = DateFormat("dd MMM yyyy");
    final formattedDate = item.date != null
        ? dateFormat.format(item.date!)
        : "-";

    // 🟢 Status color & icon
    Color statusColor;
    IconData icon;
    switch (item.status.toLowerCase()) {
      case "success":
        statusColor = Colors.green.shade600;
        icon = Icons.check_circle_rounded;
        break;
      case "pending":
        statusColor = Colors.orange.shade700;
        icon = Icons.timelapse_rounded;
        break;
      case "failed":
        statusColor = Colors.red.shade600;
        icon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.grey.shade600;
        icon = Icons.info_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.brown.shade50.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade200.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Top — Scheme name & date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.schemeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // 👤 Customer Name
            Text(
              item.name ?? "Unknown Name",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // 💰 Paid Amount
            Row(
              children: [
                Icon(
                  Icons.currency_rupee_rounded,
                  color: Colors.brown.shade700,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  item.paid.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade700,
                  ),
                ),
              ],
            ),

            // 💎 Show gold grams only if TYPE == "G"
            if (item.type.toLowerCase() == "g") ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.scale_rounded,
                    color: Colors.amber.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${item.metVal.toStringAsFixed(3)} g",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),

            // 🆔 Transaction ID
            Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 16,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Transaction ID: ${item.transId}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✅ Status badge
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: statusColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      item.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
