import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/models/customer_response.dart';

import '../../Authentication/controllers/login_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  bool isEditing = false;

  // Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final panController = TextEditingController();

  CustomerResponse? customer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 🔹 Load user data dynamically from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    print("Raw user data from SharedPreferences: $userDataString");

    if (userDataString != null) {
      try {
        final decodedMap = jsonDecode(userDataString);
        final loadedCustomer = CustomerResponse.fromJson(decodedMap);

        print("Decoded customer data: ${loadedCustomer.toJson()}");

        setState(() {
          customer = loadedCustomer;
          nameController.text =
              "${customer?.firstName ?? ''} ${customer?.lastName ?? ''}".trim();
          addressController.text =
              "${customer?.address1 ?? ''}, ${customer?.address2 ?? ''}, ${customer?.city ?? ''}"
                  .replaceAll(', ,', ',')
                  .trim();
          stateController.text = customer?.state ?? '';
          countryController.text = customer?.country ?? '';
          pincodeController.text = customer?.pincode ?? '';
          mobileController.text = customer?.mobileNo ?? '';
          aadharController.text = customer?.aadhar ?? '';
          panController.text = customer?.pan ?? '';
        });
      } catch (e) {
        AppLogger.log.e("Error decoding user data: $e");
      }
    } else {
      AppLogger.log.e("No user data found in SharedPreferences.");
    }
  }

  /// 🔹 Save updates back to SharedPreferences
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar("Invalid Fields", "Please fix validation errors before saving.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }
    if (customer == null) return;

    setState(() {
      isEditing = false;
    });

    // Split first and last name from nameController
    final nameParts = nameController.text.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    // 🔹 Call your LoginController’s registerUser (update endpoint)
    controller.registerUser(
      page: 'profile',
      fName: firstName,
      lName: lastName,
      email: customer?.email ?? '',
      mobileNo: mobileController.text.trim(),
      aadhar: aadharController.text.trim(),
      pan: panController.text.trim(),
      address1: addressController.text.trim(),
      city: customer?.city ?? '',
      state: stateController.text.trim(),
      country: countryController.text.trim(),
      password: customer?.password ?? '',
      mpin: customer?.mpin ?? '',
    );

    // 🔹 Update SharedPreferences for local cache

    // 🔹 Confirmation Snackbar
    Get.snackbar(
      "Profile Updated",
      "Your profile has been saved successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ScaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColor.ScaffoldColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.save_rounded : Icons.edit,
              color: Colors.brown.shade700,
            ),
            tooltip: isEditing ? "Save" : "Edit",
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: customer == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 20),

                      _buildSectionTitle("Personal Details"),
                      _buildTextField("Name", nameController),

                      _buildTextField("Aadhar Number", aadharController),
                      _buildTextField("PAN Number", panController),

                      const SizedBox(height: 10),
                      _buildSectionTitle("Address"),
                      _buildTextField("Address", addressController),
                      _buildTextField("City / State", stateController),
                      _buildTextField("Country", countryController),
                      _buildTextField("Pincode", pincodeController),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// 🔹 Profile Header (Name, Mobile, etc.)
  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.brown.shade300,
            child: Text(
              (customer?.firstName ?? "U")[0],
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${customer?.firstName ?? ''} ${customer?.lastName ?? ''}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer?.email ?? "",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "+91 ${customer?.mobileNo ?? ''}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    List<TextInputFormatter> inputFormatters = [];
    String? Function(String?)? validator;

    if (label.toLowerCase().contains("mobile")) {
      inputFormatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
      validator = (value) {
        if (value == null || value.isEmpty) return null; // not required
        if (value.length != 10) return "Mobile number must be 10 digits";
        return null;
      };
    } else if (label.toLowerCase().contains("aadhar")) {
      inputFormatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ];
      validator = (value) {
        if (value == null || value.isEmpty) return null;
        if (value.length != 12) return "Aadhar number must be 12 digits";
        return null;
      };
    } else if (label.toLowerCase().contains("pan")) {
      inputFormatters = [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
        LengthLimitingTextInputFormatter(10),
      ];
      validator = (value) {
        if (value == null || value.isEmpty) return null;
        if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
          return "Enter valid PAN (e.g., ABCDE1234F)";
        }
        return null;
      };
    } else if (label.toLowerCase().contains("pincode")) {
      inputFormatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ];
      validator = (value) {
        if (value == null || value.isEmpty) return null;
        if (value.length != 6) return "Pincode must be 6 digits";
        return null;
      };
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.brown.shade800,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.shade100.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              readOnly: !isEditing,
              inputFormatters: inputFormatters,
              keyboardType:
              (label.toLowerCase().contains("mobile") ||
                  label.toLowerCase().contains("aadhar") ||
                  label.toLowerCase().contains("pincode"))
                  ? TextInputType.number
                  : TextInputType.text,
              textCapitalization: label.toLowerCase().contains("pan")
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
              validator: validator,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: isEditing ? "Enter $label" : "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
