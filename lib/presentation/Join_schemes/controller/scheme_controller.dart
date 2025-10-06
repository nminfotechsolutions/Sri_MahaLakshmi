import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/scheme_type_response.dart';

import '../../../api/api_url.dart';

class SchemeController extends GetxController {
  var isLoading = true.obs;
  var schemeList = <SchemeData>[].obs;

  @override
  void onInit() {
    fetchSchemes();
    super.onInit();
  }

  Future<void> fetchSchemes() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiUrl.schemeList));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = SchemeTypeResponse.fromJson(data);
        schemeList.assignAll(result.data);
      }
    } catch (e) {
      print("Error fetching schemes: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
