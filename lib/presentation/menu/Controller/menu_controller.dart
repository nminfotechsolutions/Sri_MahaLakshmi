import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
import 'package:sri_mahalakshmi/presentation/menu/Model/transaction_history.dart';

import '../../../api/api_url.dart';
import '../../Authentication/models/customer_response.dart';

class MenuControllers extends GetxController {
  RxBool isLoading = false.obs;
  RxList<TransactionData> transactionData = <TransactionData>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> transactionHistory() async {
    isLoading.value = true;
    print("🚀 Fetching Transaction History...");

    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      print("🧩 Raw user data: $userDataString");

      if (userDataString == null) {
        print("⚠️ No user data found in SharedPreferences");
        transactionData.clear(); // 🧹 clear previous list
        return;
      }

      final decodedMap = jsonDecode(userDataString);
      final customer = CustomerResponse.fromJson(decodedMap);
      final mobileNumber = customer.mobileNo;

      print("📱 Mobile Number: $mobileNumber");

      if (mobileNumber == null || mobileNumber.isEmpty) {
        print("⚠️ No mobile number found in CustomerResponse");
        transactionData.clear(); // 🧹 clear old data
        return;
      }

      final apiUrl = ApiUrl.transactionHistory(mobileNumber: mobileNumber);
      print("🌐 API URL: $apiUrl");

      final response = await http.post(Uri.parse(apiUrl));

      print("📦 API Response Status: ${response.statusCode}");
      print("🧾 API Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = TransactionHistoryModel.fromJson(data);

        if (result.data.isEmpty) {
          print("⚠️ No transaction data found in API response");
          transactionData.clear(); // 🧹 clear when empty
        } else {
          print("✅ Transactions fetched: ${result.data.length}");
          transactionData.assignAll(result.data); // ✅ correct way
        }
      } else {
        print("❌ Failed to fetch transactions. Status: ${response.statusCode}");
        transactionData.clear(); // 🧹 clear UI when failed
      }
    } catch (e, stack) {
      print("🔥 Error fetching transaction history: $e");
      print(stack);
      transactionData.clear(); // 🧹 clear on error too
    } finally {
      isLoading.value = false;
    }
  }
}
