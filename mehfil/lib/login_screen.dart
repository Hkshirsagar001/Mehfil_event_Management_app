import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mehfil/organizer_profile_setup/organizer_profile.dart';

import 'package:mehfil/singup_screen.dart';
import 'package:mehfil/home_screen.dart';
import 'package:mehfil/user_profile_setup/create_username.dart';

import 'organizer_profile_setup/dasboard_menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in process

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final String uid = userCredential.user!.uid;

      // Fetch user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      _navigateBasedOnRole(userDoc, uid);
    } catch (e) {
      log('Error Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Email/Password Login
  Future<void> _login() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Login Successful! Welcome, ${userCredential.user!.email}')),
      );

      // Fetch user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      _navigateBasedOnRole(userDoc, uid);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      }
      if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password provided for that user.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Navigate based on user role and newLogin
  void _navigateBasedOnRole(DocumentSnapshot userDoc, String uid) {
    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      String role = userData['role'] ?? '';
      bool newLogin = userData['newLogin'] ?? false;

      if (role == 'Organizer' && newLogin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OrganizerProfilePage()),
        );
      } else if (role == 'Attendee' && newLogin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CreateUsername()),
        );
      } else if (role == 'Organizer' && !newLogin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashMenu(uid: uid)),
        );
      } else if (role == 'Attendee' && !newLogin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      log('User data not found');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User data not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 100),
            Center(
              child: Image.asset(
                "assets/batch-0---random-assets-2-high-resolution-logo-transparent.png",
                width: 250,
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Text(
                "Welcome Back !",
                style: GoogleFonts.raleway(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              hint: 'Enter Email',
              iconPath: "assets/icons/icons8-test-account-48.png",
            ),
            const SizedBox(height: 5),
            _buildTextField(
              controller: _passwordController,
              hint: 'Enter Password',
              iconPath: "assets/icons/icons8-lock-48.png",
              obscureText: !_isPasswordVisible,
              isPassword: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Forgot Password ?",
                style: GoogleFonts.raleway(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _login,
              child: _buildGradientButton("Login"),
            ),
            const SizedBox(height: 10),
            _buildDividerWithText("OR"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _signInWithGoogle,
              child: _buildGoogleLoginButton(),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account?",
                    style:
                        GoogleFonts.raleway(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(
                        text: " Sign Up",
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    bool obscureText = false,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.raleway(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.raleway(color: Colors.white38),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(iconPath,color:const Color(0xffF20587) , width: 10, height: 10),
          ),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      _isPasswordVisible
                          ? 'assets/icons/icons8-eye-48.png'
                          : 'assets/icons/icons8-invisible-48.png',
                      width: 10,
                      height: 10,
                    ),
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffF20587), width: 2),
          ),
          filled: true,
          fillColor: const Color(0xff26141C),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xffF20587), Color(0xffF2059F), Color(0xffF207CB)],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Colors.white38, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.raleway(color: Colors.white, fontSize: 18),
          ),
        ),
        const Expanded(
          child: Divider(color: Colors.white38, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white38, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/icons8-google-48.png",
                width: 30, height: 30),
            const SizedBox(width: 10),
            Text(
              "Sign In with Google",
              style: GoogleFonts.raleway(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
