import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utility/app_colors.dart';
import '../../../core/utility/app_textstyles.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../../Authentication/controllers/login_controller.dart';

class KycScreen extends StatefulWidget {
  @override
  _KycScreenState createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final LoginController controller = Get.put(LoginController());
  // User info (already known)
  final String name = "Vignesh Kumar L";
  final String email = "VK@GMAIL.COM";
  final String mobile = "900000000";

  // Controllers for address & ID fields
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();

  bool isSubmitted = false;

  @override
  void dispose() {
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    panController.dispose();
    aadharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  AppTextStyles.textWith600(
                    text: 'KYC Details',
                    fontSize: 22,
                    color: AppColor.darkTeal,
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),

              // Top Card: Name, Email, Mobile
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.darkTeal,
                      AppColor.darkTeal.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Text(
                        name[0],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                email,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                mobile,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Address + ID Form Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField("Address 1", address1Controller),
                      _buildTextField("Address 2", address2Controller),
                      _buildTextField("City", cityController),
                      _buildTextField("State", stateController),
                      _buildTextField("Country", countryController),
                      _buildTextField(
                        "Pincode",
                        pincodeController,
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField("PAN Number", panController),
                      _buildTextField(
                        "Aadhaar Number",
                        aadharController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (isSubmitted) _buildDisplayAddress(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: AnimatedButton(
                  isLoading: controller.isLoading,
                  text: 'Submit',
                  onPressed: () {
                    controller.registerUser(
                      fName: name,
                      lName: name,
                      email: email,
                      mobileNo: mobile,
                      aadhar: aadharController.text.trim(),
                      pan: panController.text.trim(),
                      address1: address1Controller.text.trim(),
                      city: cityController.text.trim(),
                      state: stateController.text.trim(),
                      country: countryController.text.trim(),
                      password: '',
                      mpin: '',
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColor.darkTeal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColor.darkTeal, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayAddress() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: AppColor.darkTeal.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 30),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Saved Details",
              style: GoogleFonts.ibmPlexSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.darkTeal,
              ),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 10),
            _buildDetailRow("Address 1", address1Controller.text),
            _buildDetailRow("Address 2", address2Controller.text),
            _buildDetailRow("City", cityController.text),
            _buildDetailRow("State", stateController.text),
            _buildDetailRow("Country", countryController.text),
            _buildDetailRow("Pincode", pincodeController.text),
            _buildDetailRow("PAN", panController.text),
            _buildDetailRow("Aadhaar", aadharController.text),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
