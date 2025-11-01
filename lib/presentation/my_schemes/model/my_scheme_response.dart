class MySchemeResponse {
  final int success;
  final String message;
  final List<MySchemeData> data;

  MySchemeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MySchemeResponse.fromJson(Map<String, dynamic> json) {
    return MySchemeResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MySchemeData.fromJson(e))
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

class MySchemeData {
  final String accNo;
  final String name;
  final String schemeName;
  final String type;
  final double schemeAmount;
  final String intType;
  final String noIns;
  final DateTime doj;
  final String asPay;
  final String METID;
  final DateTime maturityDate;
  final double totalCollection;
  final double metValue;
  final int schemeId;
  final int chitId;
  final int regNo;
  final String groupCode;
  final String add1;
  final String add2;
  final String add3;
  final String city;
  final String state;
  final String country;
  final String mobNo;

  MySchemeData({
    required this.accNo,
    required this.name,
    required this.schemeName,
    required this.type,
    required this.schemeAmount,
    required this.METID,
    required this.intType,
    required this.noIns,
    required this.doj,
    required this.asPay,
    required this.maturityDate,
    required this.totalCollection,
    required this.metValue,
    required this.schemeId,
    required this.chitId,
    required this.regNo,
    required this.groupCode,
    required this.add1,
    required this.add2,
    required this.add3,
    required this.city,
    required this.state,
    required this.country,
    required this.mobNo,
  });

  factory MySchemeData.fromJson(Map<String, dynamic> json) {
    return MySchemeData(
      accNo: json['ACCNO'] ?? '',
      name: json['NAME'] ?? '',
      schemeName: json['SCHEMENAME'] ?? '',
      type: json['TYPE'] ?? '',
      schemeAmount: (json['SCHEMEAMOUNT'] ?? 0).toDouble(),
      intType: json['INTTYPE'] ?? '',
      METID: json['METID'] ?? '',
      noIns: json['NOINS'] ?? '',
      doj: DateTime.tryParse(json['DOJ'] ?? '') ?? DateTime.now(),
      asPay: json['ASPAY'] ?? '',
      maturityDate:
      DateTime.tryParse(json['MATURITYDATE'] ?? '') ?? DateTime.now(),
      totalCollection: (json['TOTAL_COLLECTION'] ?? 0).toDouble(),
      metValue: (json['MET_VALUE'] ?? 0).toDouble(),
      schemeId: json['SCHEMEID'] ?? 0,
      chitId: json['CHITID'] ?? 0,
      regNo: json['REGNO'] ?? 0,
      groupCode: json['GROUPCODE'] ?? '',
      add1: json['ADD1'] ?? '',
      add2: json['ADD2'] ?? '',
      add3: json['ADD3'] ?? '',
      city: json['CITY'] ?? '',
      state: json['STATE'] ?? '',
      country: json['COUNTRY'] ?? '',
      mobNo: json['MOBNO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ACCNO': accNo,
      'NAME': name,
      'SCHEMENAME': schemeName,
      'TYPE': type,
      'SCHEMEAMOUNT': schemeAmount,
      'METID': METID,
      'INTTYPE': intType,
      'NOINS': noIns,
      'DOJ': doj.toIso8601String(),
      'ASPAY': asPay,
      'MATURITYDATE': maturityDate.toIso8601String(),
      'TOTAL_COLLECTION': totalCollection,
      'MET_VALUE': metValue,
      'SCHEMEID': schemeId,
      'CHITID': chitId,
      'REGNO': regNo,
      'GROUPCODE': groupCode,
      'ADD1': add1,
      'ADD2': add2,
      'ADD3': add3,
      'CITY': city,
      'STATE': state,
      'COUNTRY': country,
      'MOBNO': mobNo,
    };
  }
}
