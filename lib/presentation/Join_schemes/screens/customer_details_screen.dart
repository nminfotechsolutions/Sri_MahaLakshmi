import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/core/utility/app_logger.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/models/customer_response.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/screens/scheme_summary_screen.dart';
import 'package:sri_mahalakshmi/presentation/my_schemes/model/my_scheme_response.dart';
import '../../../core/utility/app_textstyles.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../model/scheme_type_response.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String? page;
  final double? enteredAmount;
  const CustomerDetailsScreen({super.key, this.page, this.enteredAmount});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late final SchemeData scheme;
  late final MySchemeData mySchemeData;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final panController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  @override
  void initState() {
    super.initState();
    print('Iam Entered Amount ${widget.enteredAmount}');
    if (widget.page == 'MyPlan') {
      mySchemeData = Get.arguments as MySchemeData;
      AppLogger.log.i("🟢 Received MySchemeData: ${mySchemeData.toJson()}");
    } else {
      scheme = Get.arguments as SchemeData;
      AppLogger.log.i("🟢 Received SchemeData: ${scheme.toJson()}");
    }

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    print("Raw user data from SharedPreferences: $userDataString");

    if (userDataString != null) {
      try {
        final decodedMap = jsonDecode(userDataString);

        // decodedMap is the customer JSON directly
        final customer = CustomerResponse.fromJson(decodedMap);

        print("Decoded customer data: ${customer.toJson()}");

        setState(() {
          nameController.text =
              "${customer.firstName ?? ''} ${customer.lastName ?? ''}".trim();
          addressController.text =
              "${customer.address1 ?? ''}, ${customer.address2 ?? ''}, ${customer.city ?? ''}"
                  .replaceAll(', ,', ',')
                  .trim();
          stateController.text = customer.state ?? '';
          countryController.text = customer.country ?? '';
          pincodeController.text = customer.pincode ?? '';
          mobileController.text = customer.mobileNo ?? '';
          aadharController.text = customer.aadhar ?? '';
          panController.text = customer.pan ?? '';
        });
      } catch (e) {
        AppLogger.log.e("Error decoding user data: $e");
      }
    } else {
      AppLogger.log.e("No user data found in SharedPreferences.");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    mobileController.dispose();
    aadharController.dispose();
    panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Form(
              key: _formKey, // Attach the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.teal,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  buildBoldTextField(
                    "Full Name",
                    nameController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter full name";
                      }
                      return null;
                    },
                  ),
                  buildBoldTextField(
                    "Address",
                    addressController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter address";
                      }
                      return null;
                    },
                  ),
                  buildBoldTextField(
                    "State",
                    stateController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter state";
                      }
                      return null;
                    },
                  ),
                  buildBoldTextField(
                    "Country",
                    countryController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter country";
                      }
                      return null;
                    },
                  ),

                  // Pincode (6 digits)
                  buildBoldTextField(
                    "Pincode",
                    pincodeController,
                    keyboard: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return "Please enter pincode";
                      if (!RegExp(r'^[0-9]{6}$').hasMatch(val.trim()))
                        return "Enter valid 6-digit pincode";
                      return null;
                    },
                  ),

                  // Mobile Number (10 digits)
                  buildBoldTextField(
                    "Mobile Number",
                    mobileController,
                    keyboard: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return "Please enter mobile number";
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(val.trim()))
                        return "Enter valid 10-digit mobile number";
                      return null;
                    },
                  ),

                  // Aadhar Number (12 digits)
                  buildBoldTextField(
                    "Aadhar Number",
                    aadharController,
                    keyboard: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return "Please enter Aadhar number";
                      if (!RegExp(r'^[0-9]{12}$').hasMatch(val.trim()))
                        return "Enter valid 12-digit Aadhar number";
                      return null;
                    },
                  ),

                  // PAN Number (10 characters)
                  buildBoldTextField(
                    "PAN Number",
                    panController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[A-Za-z0-9]'),
                      ), // allow letters & numbers
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return "Please enter PAN number";
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: AnimatedButton(
            text: 'Submit',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // All fields are valid
                final updatedData = {
                  'scheme': widget.page == 'MyPlan'
                      ? mySchemeData.toJson()
                      : scheme.toJson(),
                  'FullName': nameController.text,
                  'Address': addressController.text,
                  'State': stateController.text,
                  'Country': countryController.text,
                  'Pincode': pincodeController.text,
                  'Mobile': mobileController.text,
                  'Aadhar': aadharController.text,
                  'PAN': panController.text,
                };

                AppLogger.log.i(updatedData);

                Get.to(
                  () => SchemeSummaryScreen(
                    page: widget.page.toString() ?? '',
                    fullName: nameController.text,
                    enteredAmount: widget.enteredAmount,
                    address: addressController.text,
                    state: stateController.text,
                    country: countryController.text,
                    pinCode: pincodeController.text,
                    mobile: mobileController.text,
                    aadhar: aadharController.text,
                    pAN: panController.text,
                  ),
                  arguments: updatedData,
                );
              } else {
                // Invalid fields, show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all the  form")),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildBoldTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          validator: validator,
          keyboardType: keyboard,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          onChanged: (val) =>
              setState(() {}), // <--- This fixes border after editing
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.teal.shade600)
                : null,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/*class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late final SchemeData scheme;
  late final MySchemeData mySchemeData;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final panController = TextEditingController();


  @override
  void initState() {
    super.initState();
print('Iam Entered Amount ${widget.enteredAmount}');
    if (widget.page == 'MyPlan') {
      mySchemeData = Get.arguments as MySchemeData;
      AppLogger.log.i("🟢 Received MySchemeData: ${mySchemeData.toJson()}");
    } else {
      scheme = Get.arguments as SchemeData;
      AppLogger.log.i("🟢 Received SchemeData: ${scheme.toJson()}");
    }

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    print("Raw user data from SharedPreferences: $userDataString");

    if (userDataString != null) {
      try {
        final decodedMap = jsonDecode(userDataString);

        // decodedMap is the customer JSON directly
        final customer = CustomerResponse.fromJson(decodedMap);

        print("Decoded customer data: ${customer.toJson()}");

        setState(() {
          nameController.text =
              "${customer.firstName ?? ''} ${customer.lastName ?? ''}".trim();
          addressController.text =
              "${customer.address1 ?? ''}, ${customer.address2 ?? ''}, ${customer.city ?? ''}"
                  .replaceAll(', ,', ',')
                  .trim();
          stateController.text = customer.state ?? '';
          countryController.text = customer.country ?? '';
          pincodeController.text = customer.pincode ?? '';
          mobileController.text = customer.mobileNo ?? '';
          aadharController.text = customer.aadhar ?? '';
          panController.text = customer.pan ?? '';
        });
      } catch (e) {
        AppLogger.log.e("Error decoding user data: $e");
      }
    } else {
      AppLogger.log.e("No user data found in SharedPreferences.");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    mobileController.dispose();
    aadharController.dispose();
    panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header with Back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.teal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Customer Details',
                      style: TextStyle(
                        color: Colors.teal.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                buildBoldTextField(
                  "Full Name",
                  nameController,
                  icon: Icons.person_outline,
                ),
                buildBoldTextField(
                  "Address",
                  addressController,
                  icon: Icons.home_outlined,
                ),
                buildBoldTextField(
                  "State",
                  stateController,
                  icon: Icons.map_outlined,
                ),
                buildBoldTextField(
                  "Country",
                  countryController,
                  icon: Icons.public_outlined,
                ),
                buildBoldTextField(
                  "Pincode",
                  pincodeController,
                  icon: Icons.pin_drop_outlined,
                  keyboard: TextInputType.number,
                ),
                buildBoldTextField(
                  "Mobile Number",
                  mobileController,
                  icon: Icons.phone_outlined,
                  keyboard: TextInputType.phone,
                ),
                buildBoldTextField(
                  "Aadhar Number",
                  aadharController,
                  icon: Icons.credit_card_outlined,
                  keyboard: TextInputType.number,
                ),
                buildBoldTextField(
                  "PAN Number",
                  panController,
                  icon: Icons.badge_outlined,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: AnimatedButton(
            text: 'Submit',
            onPressed: () {
              final updatedData = {
                'scheme': widget.page == 'MyPlan'
                    ? mySchemeData.toJson()
                    : scheme.toJson(),

                'FullName': nameController.text,
                'Address': addressController.text,
                'State': stateController.text,
                'Country': countryController.text,
                'Pincode': pincodeController.text,
                'Mobile': mobileController.text,
                'Aadhar': aadharController.text,
                'PAN': panController.text,
              };
              AppLogger.log.i(updatedData);

              Get.to(
                () => SchemeSummaryScreen(
                  page: widget.page.toString()?? '',
                  fullName: nameController.text,
                  enteredAmount: widget.enteredAmount ,
                  address: addressController.text,
                  state: stateController.text,
                  country: countryController.text,
                  pinCode: pincodeController.text,
                  mobile: mobileController.text,
                  aadhar: aadharController.text,
                  pAN: panController.text,
                ),
                arguments: updatedData,
              );
            },
          ),
        ),
      ),
    );
  }

  // 🧩 Custom Bold TextField Builder
  Widget buildBoldTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.teal.shade600)
                : null,
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
      ],
    );
  }
}*/
