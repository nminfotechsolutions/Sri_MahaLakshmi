import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/api/api_url.dart';
import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
import 'package:sri_mahalakshmi/core/utility/snack_bar.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/models/customer_response.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/models/register_response.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/screens/otp_screen.dart';
import 'dart:convert';

import 'package:sri_mahalakshmi/presentation/Home/Screens/home_screen.dart';

import '../screens/register_screen.dart';

class LoginController extends GetxController {
  // Observable variables

  var isPasswordEnabled = false.obs; // 🔹 controls password visibility
  var isLoading = false.obs; // <--- make it observable
  var user = Rxn<RegisterResponse>(); // nullable reactive UserModel
  var errorMessage = ''.obs;

  Future<void> checkMobile(String mobileNo) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isPasswordEnabled.value = false;
      final url = Uri.parse(ApiUrl.customerCheck(mobileNumber: mobileNo));

      final response = await http.get(url);
      final data = jsonDecode(response.body);
      AppLogger.log.i('Api = $url \n $data');

      if (response.statusCode == 200) {
        if (data['message'] == "Data fetched successfully...") {
          isPasswordEnabled.value = true;
        } /*else   (data['message'] == "Data not found..!") {
          CustomSnackBar.showError("User not found. Please register first.");
          Get.off(() => RegisterScreen(mobileNumber: mobileNo));
          // CustomSnackBar.showSuccess("User found. Please enter password.");
        } */ else {
          // errorMessage.value = data['message'] ?? 'Unexpected response';
        }
      } else {
        otpSend(mobileNo: mobileNo);
        isPasswordEnabled.value = false;

        // Get.off(() => RegisterScreen(mobileNumber: mobileNo));
        // errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        final customerJsonList = data['data'];
        if (customerJsonList != null &&
            customerJsonList is List &&
            customerJsonList.isNotEmpty) {
          final customer = CustomerResponse.fromJson(customerJsonList[0]);
          AppLogger.log.i('Shared Prefs Data $customer');
          await prefs.setString('userData', CustomerResponse.encode(customer));

        } else {
          throw Exception("No customer data found in response.");
        }
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

  Future<void> login({
    required String mobileNo,
    required String passwords,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // successMessage.value = '';

      final url = Uri.parse(ApiUrl.customerSignIn);

      // Prepare JSON body
      final body = jsonEncode({"MOBILENO": mobileNo, "PASSWORD": passwords});
      AppLogger.log.i(body);

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        final customerJsonList = data['data'];
        if (customerJsonList != null &&
            customerJsonList is List &&
            customerJsonList.isNotEmpty) {
          final customer = CustomerResponse.fromJson(customerJsonList[0]);
          AppLogger.log.i('Shared Prefs Data ${customer.toJson()}');
          await prefs.setString('userData', CustomerResponse.encode(customer));
        } else {
          throw Exception("No customer data found in response.");
        }

        print(data.toString());

        Get.to(HomeScreen());
      } else {
        print('Login Failed');
        CustomSnackBar.showError('Login Failed');
        errorMessage.value = data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      print(e);
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> otpSend({required String mobileNo}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // successMessage.value = '';

      final url = Uri.parse(ApiUrl.otpSend);

      // Prepare JSON body
      final body = jsonEncode({"MOBILENO": mobileNo});
      AppLogger.log.i(body);

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == 200) {
        Get.to(OtpScreen(mobileNumber: mobileNo));
        CustomSnackBar.showSuccess('Otp sent successfully');
        print(data.toString());

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('isLoggedIn', true);
      } else {
        print('Otp  Failed');
        CustomSnackBar.showError('Otp Failed');
      }
    } catch (e) {
      print(e);
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> otpVerify({
    required String mobileNo,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // successMessage.value = '';

      final url = Uri.parse(ApiUrl.otpVerify);

      // Prepare JSON body
      final body = jsonEncode({"MOBILENO": mobileNo, "OTP": otp});
      AppLogger.log.i(body);

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == 200) {
        Get.offAll(RegisterScreen(mobileNumber: mobileNo));

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('isLoggedIn', true);
      } else {
        print('Otp  Failed');
        CustomSnackBar.showError('Otp Failed');
      }
    } catch (e) {
      print(e);
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    user.value = null;
  }
}
