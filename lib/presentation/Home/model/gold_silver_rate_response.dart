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
      data:
          (json['data'] as List<dynamic>?)
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

  GoldSilverData({required this.gold, required this.silver});

  factory GoldSilverData.fromJson(Map<String, dynamic> json) {
    return GoldSilverData(gold: json['GOLD'], silver: json['silver']);
  }

  Map<String, dynamic> toJson() => {'gold': gold, 'silver': silver};
}
