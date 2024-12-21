import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mehfil/consts.dart';
import 'package:mehfil/splash_screen.dart';



void main() async {
  await _setup();
  runApp(const MyApp());
}

Future<void> _setup() async {
  // Firebase initialization
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyATGkCXfjJGOQzq3D_XzCwex331bUSuHf8', 
        appId: '148012898013', 
        messagingSenderId: "1:148012898013:android:7d1d179316c33518646d34", 
        projectId: "eventaura-3700e"
      ),
    );
    log("Firebase successfully initialized!");

    // Stripe setup
    Stripe.publishableKey = stripePublishableLey; 
    log("Stripe successfully initialized!");

  } catch (e) {
    print("Initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),  
    );
  }
}
