import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/screens/scheme_summary_screen.dart';
import '../../../core/utility/app_textstyles.dart';
import '../../../core/widgets/animated_buttons.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final panController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFE0F7FA)], // soft teal blend
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // 🔹 Header with Back button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.teal,
                        size: 22,
                      ),
                    ),
                    AppTextStyles.textWith600(
                      text: 'Customer Details',
                      color: Colors.teal.shade800,
                      fontSize: 18,
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),

                Column(
                  children: [
                    buildTextField(
                      "Full Name",
                      nameController,
                      icon: Icons.person_outline,
                    ),
                    buildTextField(
                      "Address",
                      addressController,
                      icon: Icons.home_outlined,
                    ),
                    buildTextField(
                      "State",
                      stateController,
                      icon: Icons.map_outlined,
                    ),
                    buildTextField(
                      "Country",
                      countryController,
                      icon: Icons.public,
                    ),
                    buildTextField(
                      "Pincode",
                      pincodeController,
                      icon: Icons.pin_drop_outlined,
                      keyboard: TextInputType.number,
                    ),
                    buildTextField(
                      "Mobile Number",
                      mobileController,
                      icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                    ),
                    buildTextField(
                      "Aadhar Number",
                      aadharController,
                      icon: Icons.credit_card_outlined,
                      keyboard: TextInputType.number,
                    ),
                    buildTextField(
                      "PAN Number",
                      panController,
                      icon: Icons.badge_outlined,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 🔹 Continue Button
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: AnimatedButton(
                text: 'Submit',
                onPressed: () {
                  Get.to(SchemeSummaryScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.teal.shade600)
              : null,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.teal.shade300, width: 1.3),
          ),
        ),
      ),
    );
  }
}
