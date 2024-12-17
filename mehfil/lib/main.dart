import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mehfil/organizer_profile_setup/dasboard_menu.dart';
import 'package:mehfil/splash_screen.dart';







void main() async {
  try{ 
 WidgetsFlutterBinding.ensureInitialized();
 Firebase.initializeApp(options: const FirebaseOptions(
  apiKey: 'AIzaSyATGkCXfjJGOQzq3D_XzCwex331bUSuHf8', appId: '148012898013', messagingSenderId: "1:148012898013:android:7d1d179316c33518646d34", projectId: "eventaura-3700e"));
  runApp(const MainApp());
  log("Firebase successfully!");
  } catch (e) {
    print("Firebas ecxeption: $e");
  }
 
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return    MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home:SplashScreen()
    );
  }
}
