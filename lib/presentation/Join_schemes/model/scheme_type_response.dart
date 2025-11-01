class SchemeTypeResponse {
  final int success;
  final String message;
  final List<SchemeData> data;

  SchemeTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SchemeTypeResponse.fromJson(Map<String, dynamic> json) {
    return SchemeTypeResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => SchemeData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SchemeData {
  final String schemeName;
  final int chitId;
  final double amount;
  final String noIns;
  final String schemeType;
  final String chitAmt;
  final String SCHCODE;
  final String METID;

  SchemeData({
    required this.schemeName,
    required this.chitId,
    required this.amount,
    required this.noIns,
    required this.schemeType,
    required this.chitAmt,
    required this.SCHCODE,
    required this.METID,
  });

  factory SchemeData.fromJson(Map<String, dynamic> json) {
    return SchemeData(
      schemeName: json['SCHEMENAME'] ?? '',
      chitId: json['CHITID'] ?? 0,
      amount: (json['AMOUNT'] ?? 0).toDouble(),
      noIns: json['NOINS'] ?? '',
      schemeType: json['SCHEMETYPE'] ?? '',
      chitAmt: json['CHITAMT'] ?? '',
      SCHCODE: json['SCHCODE'] ?? '',
      METID: json['METID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SCHEMENAME': schemeName,
      'CHITID': chitId,
      'AMOUNT': amount,
      'NOINS': noIns,
      'SCHEMETYPE': schemeType,
      'CHITAMT': chitAmt,
      'METID': METID,
      'SCHCODE': SCHCODE,
    };
  }
}
