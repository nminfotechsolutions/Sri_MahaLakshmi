class GoldSilverRateResponse {
  final int success;
  final String message;
  final List<GoldSilverData> data;

  GoldSilverRateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GoldSilverRateResponse.fromJson(Map<String, dynamic> json) {
    return GoldSilverRateResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GoldSilverData.fromJson(e))
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

class GoldSilverData {
  final int gold;
  final int silver;
  final DateTime dateTime;

  GoldSilverData({
    required this.gold,
    required this.silver,
    required this.dateTime,
  });

  factory GoldSilverData.fromJson(Map<String, dynamic> json) {
    return GoldSilverData(
      gold: json['GOLD'] ?? 0,
      silver: json['SILVER'] ?? 0,
      dateTime: DateTime.tryParse(json['DATETIME'] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() => {
    'GOLD': gold,
    'SILVER': silver,
    'DATETIME': dateTime.toIso8601String(),
  };
}
