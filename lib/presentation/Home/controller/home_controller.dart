import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/gold_silver_rate_response.dart';

import '../../../api/api_url.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var goldAndSilverRateData = <GoldSilverData>[].obs;

  @override
  void onInit() {
    fetchTodayRate();
    super.onInit();
  }

  Future<void> fetchTodayRate() async {
    try {
      isLoading.value = true;

      final body = jsonEncode({"UPDATETYPE": ""});
      final response = await http.post(
        Uri.parse(ApiUrl.rateMastUpdate),

        headers: {"Content-Type": "application/json"},
        body: body
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check API success
        if (data['success'] == 200) {
          // Parse JSON into model
          final result = GoldSilverRateResponse.fromJson(data);

          // Assign data to your observable list
          goldAndSilverRateData.assignAll(result.data);

          // Optional: print to debug
          print(
            "Gold: ${result.data[0].gold}, Silver: ${result.data[0].silver}",
          );
        } else {
          print("API returned failure: ${data['message']}");
        }
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Gold & Silver Rate: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
