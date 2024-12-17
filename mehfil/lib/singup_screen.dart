import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mehfil/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Loading state
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Attendee'; // Default role is Attendee

  // Sign Up Function
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Get email and password from the TextField controllers
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        // Show error if fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both email and password')),
        );
        return;
      }

      // Create a new user with FirebaseAuth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure user UID is valid
      if (userCredential.user?.uid == null) {
        throw Exception('Failed to get user UID');
      }

      // Store user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': _selectedRole,
        'newLogin': true, // Add the newLogin parameter
      });

      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // Navigate to the LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Handle sign-up errors
      print('Error during sign up: $e'); // Log error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase(); // Ensure Firebase is initialized
  }

  // Initialize Firebase
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase initialization error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing Firebase: $e')),
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
            // Logo
            Center(child: Image.asset("assets/batch-0---random-assets-2-high-resolution-logo-transparent.png", width: 250)),
            const SizedBox(height: 25),
            // Create an Account Text
            Center(
              child: Text(
                "Create an Account",
                style: GoogleFonts.raleway(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Subtext
            Center(
              child: Text(
                "Please fill in these details to create an account",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.white38,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email TextField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                style: GoogleFonts.raleway(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  hintStyle: GoogleFonts.raleway(color: Colors.white38),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/icons8-email-48.png",
                      width: 10,
                      height: 10,
                      color: const Color(0xffF20587),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.white38,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Color(0xffF20587),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xff26141C),
                ),
              ),
            ),

            // Password TextField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                style: GoogleFonts.raleway(color: Colors.white, fontSize: 18),
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  hintStyle: GoogleFonts.raleway(color: Colors.white38),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/icons8-lock-48.png",
                      width: 10,
                      height: 10,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        _isPasswordVisible
                            ? 'assets/icons/icons8-eye-48.png'
                            : 'assets/icons/icons8-invisible-48.png',
                        width: 10,
                        height: 10,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.white38,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Color(0xffF20587),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xff26141C),
                ),
              ),
            ),

            // Role Dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                items: <String>['Attendee', 'Organizer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.raleway(color: Colors.pinkAccent, fontSize: 18),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff26141C),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.white38,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Color(0xffF20587),
                    ),
                  ),
                ),
              ),
            ),

            // Sign Up Button
            GestureDetector(
              onTap: _isLoading ? null : _signUp, // Disable button if loading
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: _isLoading
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                          )
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffF20587),
                              Color(0xffF2059F),
                              Color(0xffF207CB),
                            ],
                          ),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            "Sign Up",
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Already have an account Text
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();   
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: GoogleFonts.raleway(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: GoogleFonts.raleway(color: const Color(0xffF20587), fontSize: 18),
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
}
