class TransactionHistoryModel {
  final int success;
  final String message;
  final List<TransactionData> data;

  TransactionHistoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryModel(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionData.fromJson(e))
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

class TransactionData {
  final String sNo;
  final int vouno;
  final DateTime? date;
  final String schemeName;
  final String type;
  final String schemeAmt;
  final double paid;
  final double metVal;
  final String transId;
  final String status;
  final String name;
  final String mobNo;

  TransactionData({
    required this.sNo,
    required this.vouno,
    required this.date,
    required this.schemeName,
    required this.type,
    required this.schemeAmt,
    required this.paid,
    required this.metVal,
    required this.transId,
    required this.status,
    required this.name,
    required this.mobNo,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      sNo: json['S_No']?.toString() ?? '',
      vouno: json['VOUNO'] ?? 0,
      date: json['DATE'] != null ? DateTime.tryParse(json['DATE']) : null,
      schemeName: json['SCHEMENAME']?.toString() ?? '',
      type: json['TYPE']?.toString() ?? '',
      schemeAmt: json['SCHEMEAMT']?.toString() ?? '',
      paid: (json['PAID'] is num)
          ? (json['PAID'] as num).toDouble()
          : double.tryParse(json['PAID'].toString()) ?? 0.0,
      metVal: (json['METVAL'] is num)
          ? (json['METVAL'] as num).toDouble()
          : double.tryParse(json['METVAL'].toString()) ?? 0.0,
      transId: json['TRANS_ID']?.toString() ?? '',
      status: json['STATUS']?.toString() ?? '',
      name: json['NAME']?.toString() ?? '',
      mobNo: json['MOBNO']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'S_No': sNo,
      'VOUNO': vouno,
      'DATE': date?.toIso8601String(),
      'SCHEMENAME': schemeName,
      'TYPE': type,
      'SCHEMEAMT': schemeAmt,
      'PAID': paid,
      'METVAL': metVal,
      'TRANS_ID': transId,
      'STATUS': status,
      'NAME': name,
      'MOBNO': mobNo,
    };
  }
}
