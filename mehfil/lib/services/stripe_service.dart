import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:mehfil/consts.dart';
import 'package:mehfil/user_profile_setup/qrscreen.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

Future<bool> makePayment(
  BuildContext context, {
  required String userName,
  required String date,
  required String location,
  required int ticketPrice, // Add this parameter
}) async {
  try {
    String? paymentIntentClientSecret = await _createPaymentIntent(
      ticketPrice, // Pass ticketPrice to the payment intent
      "usd",
    );
    log("PAYMENT CLIENT: $paymentIntentClientSecret");
    if (paymentIntentClientSecret == null) return false;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Harsh Kshirsagar",
      ),
    );

    return await _processPayment(context, userName, date, location);
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
      log(response.data.toString());
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      log("Create Payment Intent Error: $e");
      return null;
    }
  }

 Future<bool> _processPayment(
  BuildContext context,
  String userName,
  String date,
  String location,
) async {
  try {
    await Stripe.instance.presentPaymentSheet();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff26141C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green.withOpacity(0.2),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Payment Successful!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your payment was processed successfully. You can view the details or go back to the homepage.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScreen(
                            userName: userName,
                            date: date,
                            location: location,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffF20587),
                            Color(0xffF2059F),
                            Color(0xffF207CB),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pink),
                      ),
                      child: const Center(
                        child: Text(
                          "Go Back",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    await Stripe.instance.confirmPaymentSheetPayment();

    log("Payment success");

    return true;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment failed. Please try again."),
      ),
    );
    log("Process Payment Error: $e");
    return false;
  }
}

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
