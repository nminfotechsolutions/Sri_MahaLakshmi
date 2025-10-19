import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
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

  Future<void> newSchemeJoin({
    required String schemeName,
    required String schemeId,
    required String groupCode,
    required String schemeAmount,
    required String regNo,
    required String name,
    required String accNo,
    required String address1,
    String? address2,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String mobileNo,
    required String aadharNo,
    required String panNo,
    required int chitId,
    required int goldRate,
    required int silverRate,

  }) async {
    try {
      isLoading.value = true;

      // successMessage.value = '';

      final url = Uri.parse(ApiUrl.schemeJoin);

      // Prepare JSON body
      final body = jsonEncode({
        "SCHEMENAME": schemeName,
        "SCHEMEID": schemeId,
        "GROUPCODE": groupCode,
        "SCHEMEAMT": schemeAmount,
        "REGNO": regNo,
        "NAME": name,
        "ADDRESS1": address1,
        "ADDRESS2": address2 ?? '',
        "ADDRESS3": address2 ?? '',
        "CITY": city,
        "STATE": state,
        "COUNTRY": country,
        "PINCODE": pincode,
        "MOBILENO": mobileNo,
        "CASH": 0,
        "CARD": 0,
        "CARDNAME": "",
        "EMPLOYEEID": "1",
        "ACCNO": accNo,
        "GOLDRATE": goldRate,
        "SILVERRATE": silverRate,
        "REMARKS": "",
        "NOMINI": "",
        "ADHARNO": aadharNo,
        "PANNO": panNo,
        "CHITID": chitId,
        "METID": "",
        "TRANS_ID": "Testing",
        "STATUS": "Testing",
      });

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      AppLogger.log.i(body.toString());

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == 200) {

        AppLogger.log.i(response.body.toString());

        print(data['message']);
        // successMessage.value = data['message'] ?? 'Registered successfully';
      } else {
        print(data['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
