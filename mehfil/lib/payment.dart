import 'package:flutter/material.dart';
import 'package:mehfil/services/stripe_service.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            StripeService.instance.makePayment(); 
            // Action to perform when the button is tapped
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Button tapped!')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              'Pay Now',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
