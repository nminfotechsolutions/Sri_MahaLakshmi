import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

/// Razorpay Service
class RazorpayService {
  late Razorpay _razorpay;

  RazorpayService() {
    _razorpay = Razorpay();
  }

  /// Initialize Razorpay listeners
  void init({
    required Function(String paymentId) onSuccess,
    required Function(String code, String message) onError,
    Function(String wallet)? onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      onSuccess(response.paymentId!);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      onError(response.code.toString(), response.message ?? "Error");
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      if (onExternalWallet != null) onExternalWallet(response.walletName ?? '');
    });
  }

  /// Create Razorpay order via API
  Future<String> createOrder(double amount, {String currency = 'INR'}) async {
    final url = Uri.parse('https://api.razorpay.com/v1/orders');
    const apiKey = 'rzp_live_RJnEb064whmCZZ';
    const apiSecret = 'yvv0xU0n6qeIOC7KnddLArUH';

    final headers = {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret')),
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'amount': (amount * 100).toInt(), // amount in paise
      'currency': currency,
      'payment_capture': 1
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to create Razorpay order');
    }
  }




  void openCheckout({
    required String orderId,
    required double amount,
    required String name,
    String description = '',
    String contact = '',
    String email = '',
  }) {
    final options = {
      'key': 'rzp_live_RJnEb064whmCZZ',
      'amount': (amount * 100).toInt(),
      'name': name,
      'description': description,
      'order_id': orderId,
      'prefill': {'contact': contact, 'email': email},
      'retry': {'enabled': true, 'max_count': 1},
      'external': {'wallets': ['paytm']},
    };
    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
