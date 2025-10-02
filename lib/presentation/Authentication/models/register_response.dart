class RegisterResponse {
  final String id;
  final String fName;
  final String lName;
  final String email;
  final String aadhar;
  final String pan;
  final String address1;
  final String address2;
  final String city;
  final String pincode;
  final String state;
  final String country;
  final String act;
  final String mobileNo;
  final String mpin;
  final DateTime created;
  final String password;
  final String admin;

  RegisterResponse({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    required this.aadhar,
    required this.pan,
    required this.address1,
    required this.address2,
    required this.city,
    required this.pincode,
    required this.state,
    required this.country,
    required this.act,
    required this.mobileNo,
    required this.mpin,
    required this.created,
    required this.password,
    required this.admin,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['ID'] ?? '',
      fName: json['FNAME'] ?? '',
      lName: json['LNAME'] ?? '',
      email: json['EMAIL'] ?? '',
      aadhar: json['AADHAR'] ?? '',
      pan: json['PAN'] ?? '',
      address1: json['ADDRESS1'] ?? '',
      address2: json['ADDRESS2'] ?? '',
      city: json['CITY'] ?? '',
      pincode: json['PINCODE'] ?? '',
      state: json['STATE'] ?? '',
      country: json['COUNTRY'] ?? '',
      act: json['ACT'] ?? '',
      mobileNo: json['MOBILENO'] ?? '',
      mpin: json['MPIN'] ?? '',
      created: DateTime.parse(
        json['CREATED'] ?? DateTime.now().toIso8601String(),
      ),
      password: json['PASSWORD'] ?? '',
      admin: json['ADMIN'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'FNAME': fName,
      'LNAME': lName,
      'EMAIL': email,
      'AADHAR': aadhar,
      'PAN': pan,
      'ADDRESS1': address1,
      'ADDRESS2': address2,
      'CITY': city,
      'PINCODE': pincode,
      'STATE': state,
      'COUNTRY': country,
      'ACT': act,
      'MOBILENO': mobileNo,
      'MPIN': mpin,
      'CREATED': created.toIso8601String(),
      'PASSWORD': password,
      'ADMIN': admin,
    };
  }
}

class UserResponse {
  final int success;
  final String message;
  final List<RegisterResponse> data;

  UserResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<RegisterResponse>.from(
              json['data'].map((x) => RegisterResponse.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}
