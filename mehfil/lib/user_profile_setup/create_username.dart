import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mehfil/home_screen.dart';

class CreateUsername extends StatefulWidget {
  const CreateUsername({super.key});

  @override
  State<CreateUsername> createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  File? _selectedImage; // To store the selected image locally
  final ImagePicker _picker = ImagePicker();
  final Set<String> selectedCategories = {};
  final TextEditingController _usernameController = TextEditingController();

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to save data into Firestore
  // Function to save data into Firestore and update 'newLogin' flag
Future<void> _saveDataToFirestore() async {
  final String username = _usernameController.text.trim();
  final String imagePath = _selectedImage?.path ?? '';
  final List<String> categories = selectedCategories.toList();

  if (username.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a username.")),
    );
    return;
  }

  try {
    // Save profile data to Firestore
    await FirebaseFirestore.instance.collection('attendee_profiles').add({
      'username': username,
      'imagePath': imagePath, // Storing the local image path
      'categories': categories,
      'createdAt': Timestamp.now(),
    });

    log('Profile successfully stored in Firestore');

    // After profile is saved, update the 'newLogin' flag in the 'users' collection
    final user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'newLogin': false, // Set 'newLogin' flag to false
      });
      log('newLogin flag updated to false');
    }

    // Navigate to HomeScreen after saving the profile
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>  HomeScreen(user: user!),
      ),
    );
  } catch (e) {
    log('Error storing profile: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to save data. Please try again.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            LinearProgressBar(
              maxSteps: 3,
              currentStep: _currentPage + 1,
              progressColor:const Color(0xffF20587),
              backgroundColor: Colors.white24,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Page 1: Username
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Create username",
                        style: GoogleFonts.raleway(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Profile can be changed at any time.",
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          color: Colors.white38,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xffF20587)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xffF20587),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xffF20587),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xff26141C),
                        ),
                      ),
                      const Spacer(),
                      _buildNextButton(),
                    ],
                  ),
                  // Page 2: Profile Photo
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Title text
                        Text(
                          "Choose your profile photo",
                          style: GoogleFonts.raleway(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Subtitle text
                        Text(
                          "Username can be changed at any time.",
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            color: Colors.white38,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Image Picker
                        GestureDetector(
                          onTap: _pickImage, // Open the image picker on tap
                          child: Center(
                            child: Stack(
                              children: [
                                // Image Container
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff26141C),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14)),
                                    border: Border.all(
                                      color: const Color(0xffF20587),
                                      width: 4,
                                    ),
                                  ),
                                  child: Center(
                                    // If an image is selected, display it, otherwise show the placeholder icon
                                    child: _selectedImage != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                              width: 180,
                                              height: 180,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/icons/icons8-add-image-96.png',
                                            width: 100,
                                            height: 100,
                                          ),
                                  ),
                                ),
                                // "X" icon for removing the image
                                if (_selectedImage != null)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImage =
                                                null; // Remove the selected image
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/icons/icons8-cancel-48.png')),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Next button
                        GestureDetector(
                          onTap: () {
                            if (_currentPage < 2) {
                              _pageController.animateToPage(
                                _currentPage + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
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
                                child: Text(
                                  _currentPage < 2 ? "Next" : "Finish",
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
                      ],
                    ),

                  // Page 3: Categories
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose your favorite event",
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _buildCategoryButtons(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _saveDataToFirestore,
                        child: _buildFinishButton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryButtons() {
    final categories = [
      "Business",
      "Community",
      "Music & Entertainment",
      "Health",
      "Food & Drink",
      "Family & Education",
      "Sport",
      "Fashion",
      "Film & Media",
      "Home & Lifestyle",
      "Gaming",
    ];

    return categories.map((category) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (selectedCategories.contains(category)) {
              selectedCategories.remove(category);
            } else {
              selectedCategories.add(category);
            }
          });
        },
        child: Chip(
          backgroundColor: selectedCategories.contains(category)
              ? const Color(0xffF20587)
              : Colors.grey[800],
          label: Text(
            category,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffF20587),
                  Color(0xffF2059F),
                  Color(0xffF207CB)
                ])),
        alignment: Alignment.center,
        child: const Text(
          "Next",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffF20587),
                  Color(0xffF2059F),
                  Color(0xffF207CB)
                ])),
      child: const Center(
        child: Text(
          "Finish",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
