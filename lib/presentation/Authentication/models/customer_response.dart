import 'dart:convert';

class CustomerResponse {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? aadhar;
  final String? pan;
  final String? address1;
  final String? address2;
  final String? city;
  final String? pincode;
  final String? state;
  final String? country;
  final String? mobileNo;
  final String? mpin;
  final String? password;

  CustomerResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.aadhar,
    this.pan,
    this.address1,
    this.address2,
    this.city,
    this.pincode,
    this.state,
    this.country,
    this.mobileNo,
    this.mpin,
    this.password,
  });

  // ✅ Create object from individual customer JSON
  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      id: json['ID'],
      firstName: json['FNAME'],
      lastName: json['LNAME'],
      email: json['EMAIL'],
      aadhar: json['AADHAR'],
      pan: json['PAN'],
      address1: json['ADDRESS1'],
      address2: json['ADDRESS2'],
      city: json['CITY'],
      pincode: json['PINCODE'],
      state: json['STATE'],
      country: json['COUNTRY'],
      mobileNo: json['MOBILENO'],
      mpin: json['MPIN'],
      password: json['PASSWORD'],
    );
  }

  // ✅ Convert object to JSON (to save to SharedPreferences)
  Map<String, dynamic> toJson() => {
    'ID': id,
    'FNAME': firstName,
    'LNAME': lastName,
    'EMAIL': email,
    'AADHAR': aadhar,
    'PAN': pan,
    'ADDRESS1': address1,
    'ADDRESS2': address2,
    'CITY': city,
    'PINCODE': pincode,
    'STATE': state,
    'COUNTRY': country,
    'MOBILENO': mobileNo,
    'MPIN': mpin,
    'PASSWORD': password,
  };

  // ✅ Encode object to string (to store in SharedPreferences)
  static String encode(CustomerResponse model) => jsonEncode(model.toJson());

  /// ✅ Decode from raw API response stored as string:
  /// expects format: {"success":..., "message":..., "data": [ {customer fields} ]}
  static CustomerResponse decode(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    if (jsonMap.containsKey('data') &&
        jsonMap['data'] is List &&
        jsonMap['data'].isNotEmpty) {
      final customerJson = jsonMap['data'][0];
      return CustomerResponse.fromJson(customerJson);
    } else {
      throw Exception("❌ No customer data found in JSON.");
    }
  }
}
