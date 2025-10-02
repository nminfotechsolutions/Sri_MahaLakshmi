import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sri_mahalakshmi/api/api_url.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/models/register_response.dart';
import 'dart:convert';

import 'package:sri_mahalakshmi/presentation/Home/Screens/home_screen.dart';

class LoginController extends GetxController {
  // Observable variables
  var isLoading = false.obs; // <--- make it observable
  var user = Rxn<RegisterResponse>(); // nullable reactive UserModel
  var errorMessage = ''.obs;

  Future<void> registerUser({
    required String fName,
    required String lName,
    required String email,
    required String mobileNo,
    required String aadhar,
    required String pan,
    required String address1,
    String? address2,
    required String city,
    required String state,
    required String country,
    required String password,
    required String mpin,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // successMessage.value = '';

      final url = Uri.parse(ApiUrl.customerSignUp);

      // Prepare JSON body
      final body = jsonEncode({
        "FNAME": fName,
        "LNAME": lName,
        "EMAIL": email,
        "MOBILENO": mobileNo,
        "AADHAR": aadhar,
        "PAN": pan,
        "ADDRESS1": address1,
        "ADDRESS2": address2 ?? '',
        "CITY": city,
        "STATE": state,
        "COUNTRY": country,
        "PASSWORD": password,
        "MPIN": mpin,
        "ACT": "Y",
      });

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == 200) {
        print(data.toString());
        print(response.body);
        Get.to(HomeScreen());
        print(data['message']);
        // successMessage.value = data['message'] ?? 'Registered successfully';
      } else {
        print('Login Failed');
        errorMessage.value = data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      print(e);
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchUser(String email) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     // Replace with your real API URL
  //     final url = Uri.parse('https://your-api-url.com/login?email=$email');
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //
  //       if (jsonData['success'] == 200 && jsonData['data'] != null) {
  //         user.value = RegisterResponse.fromJson(jsonData['data'][0]);
  //       } else {
  //         errorMessage.value = jsonData['message'] ?? 'No user found';
  //       }
  //     } else {
  //       errorMessage.value = 'Server error: ${response.statusCode}';
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'Error: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void logout() {
    user.value = null;
  }
}
