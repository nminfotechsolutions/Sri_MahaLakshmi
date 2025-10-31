class LedgerResponse {
  final int success;
  final String message;
  final List<LedgerData> data;

  LedgerResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LedgerResponse.fromJson(Map<String, dynamic> json) {
    return LedgerResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => LedgerData.fromJson(item))
          .toList(),
    );
  }
}

class LedgerData {
  final String? sNo;
  final String accNo;
  final DateTime? date;
  final String schemeName;
  final String? chitAmount;
  final num collection;
  final num metValue;
  final String? transId;
  final String? metId;
  final num? goldRate;

  LedgerData({
    this.sNo,
    required this.accNo,
    this.date,
    required this.schemeName,
    this.chitAmount,
    required this.collection,
    required this.metValue,
    this.transId,
    this.metId,
    this.goldRate,
  });

  factory LedgerData.fromJson(Map<String, dynamic> json) {
    return LedgerData(
      sNo: json['S_NO']?.toString(),
      accNo: json['ACCNO'] ?? '',
      date: json['DATE'] != null && json['DATE'] != ''
          ? DateTime.tryParse(json['DATE'])
          : null,
      schemeName: json['SCHEMENAME'] ?? '',
      chitAmount: json['CHITAMOUNT']?.toString(),
      collection: json['COLLECTION'] ?? 0,
      metValue: json['MET_VALUE'] ?? 0,
      transId: json['TRANS_ID'],
      metId: json['METID'],
      goldRate: json['GOLDRATE'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'S_NO': sNo,
      'ACCNO': accNo,
      'DATE': date?.toIso8601String(),
      'SCHEMENAME': schemeName,
      'CHITAMOUNT': chitAmount,
      'COLLECTION': collection,
      'MET_VALUE': metValue,
      'TRANS_ID': transId,
      'METID': metId,
      'GOLDRATE': goldRate,
    };
  }
}
