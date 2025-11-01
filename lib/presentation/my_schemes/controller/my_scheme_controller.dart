import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
import 'package:sri_mahalakshmi/presentation/my_schemes/model/my_scheme_response.dart';

import '../../../api/api_url.dart';
import '../../Authentication/models/customer_response.dart';
import '../model/ledger_response.dart';

class MySchemeController extends GetxController {
  var isLoading = true.obs;
  var mySchemeList = <MySchemeData>[].obs;
  var myLedgerData = <LedgerData>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> mySchemes() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      print("Raw user data from SharedPreferences: $userDataString");

      if (userDataString == null) {
        print("⚠️ No user data found in SharedPreferences");
        return;
      }

      // Decode user data JSON
      final decodedMap = jsonDecode(userDataString);
      final customer = CustomerResponse.fromJson(decodedMap);

      // ✅ Access mobile number
      final mobileNumber = customer.mobileNo;

      if (mobileNumber == null || mobileNumber.isEmpty) {
        print("⚠️ No mobile number found in CustomerResponse");
        return;
      }

      print("📱 Mobile number from SharedPreferences: $mobileNumber");

      isLoading.value = true;

      // ✅ Pass the mobile number dynamically
      final response = await http.get(
        Uri.parse(ApiUrl.mySchemeList(mobileNumber: mobileNumber)),
      );
      AppLogger.log.i(ApiUrl.mySchemeList(mobileNumber: mobileNumber));
      if (response.statusCode == 200) {
        isLoading.value = false;
        final data = jsonDecode(response.body);
        final result = MySchemeResponse.fromJson(data);
        mySchemeList.assignAll(result.data);
        AppLogger.log.i(data);
      } else {
        isLoading.value = false;
        AppLogger.log.e("❌ API Error: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e("❗ Error fetching schemes: $e");
      print("Error fetching schemes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> myLedger({required String accNo}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      print("Raw user data from SharedPreferences: $userDataString");

      // Check if user data exists
      if (userDataString == null) {
        print("⚠️ No user data found in SharedPreferences");
        return;
      }

      // Decode user data JSON
      final decodedMap = jsonDecode(userDataString);
      final customer = CustomerResponse.fromJson(decodedMap);

      final mobileNumber = customer.mobileNo;

      if (mobileNumber == null || mobileNumber.isEmpty) {
        print("⚠️ No mobile number found in CustomerResponse");
        return;
      }

      print("📱 Mobile number from SharedPreferences: $mobileNumber");

      isLoading.value = true;

      // ✅ Pass the mobile number dynamically
      final response = await http.get(
        Uri.parse(ApiUrl.myLedger(mobileNumber: mobileNumber, accNo: accNo)),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final data = jsonDecode(response.body);
        final result = LedgerResponse.fromJson(data);
        myLedgerData.assignAll(result.data);
        AppLogger.log.i(data);
      } else {
        isLoading.value = false;
        AppLogger.log.e("❌ API Error: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e("❗ Error fetching schemes: $e");
      print("Error fetching schemes: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
