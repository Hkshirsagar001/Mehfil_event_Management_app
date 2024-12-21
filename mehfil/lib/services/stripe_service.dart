import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:mehfil/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        100,
        "usd",
      );
      if (paymentIntentClientSecret == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Harsh Kshirsagar",
        ),
      );

      return await _processPayment();
    } catch (e) {
      log("Payment Error: $e");
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      log("Create Payment Intent Error: $e");
      return null;
    }
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
      return true;
    } catch (e) {
      log("Process Payment Error: $e");
      return false;
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
