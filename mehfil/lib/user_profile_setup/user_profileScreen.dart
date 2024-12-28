import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mehfil/login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;

  const UserProfileScreen({super.key, required this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  String? selectedGender;
  String? selectedCountry;
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('attendee_profiles')
          .doc(widget.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data();
          selectedGender = userData?['gender'];
          selectedCountry = userData?['country'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context) {
        return const  LoginScreen(); 
      },),  
      (route){ 
        return false; 
      }); // Adjust route as needed
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      appBar: AppBar(
        backgroundColor: const Color(0xff26141C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.raleway(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'signOut') {
                _signOut();
              }
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'signOut',
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xffF20587)),
            )
          : userData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No data found',
                        style: GoogleFonts.raleway(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'UID: ${widget.uid}',
                        style: GoogleFonts.raleway(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : userData?['imagePath'] != null &&
                                          userData!['imagePath'].isNotEmpty
                                      ? FileImage(File(userData!['imagePath']))
                                      : const AssetImage(
                                              'assets/profile_placeholder.png')
                                          as ImageProvider,
                              child: _imageFile == null &&
                                      (userData?['imagePath'] == null ||
                                          userData!['imagePath'].isEmpty)
                                  ? Icon(Icons.camera_alt,
                                      size: 50, color: Colors.grey[700])
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: userData!['username'] ?? 'Unknown',
                            hintText: 'Enter your name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            label: userData!['email'] ?? 'example@example.com',
                            hintText: 'Enter your email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildDropdown(
                            label: selectedGender ?? 'Select Gender',
                            items: ['Male', 'Female', 'Other'],
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            label: userData!['phone'] ?? '(000) 000-0000',
                            hintText: 'Enter your phone number',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildDropdown(
                            label: selectedCountry ?? 'Select Country',
                            items: ['United States', 'India', 'Canada'],
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          _buildUpdateButton(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.raleway(color: Colors.white),
        hintText: hintText,
        hintStyle: GoogleFonts.raleway(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffF20587)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffF20587)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: GoogleFonts.raleway(color: Colors.white),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final isValidValue = items.contains(label);

    return DropdownButtonFormField<String>(
      value: isValidValue ? label : null,
      onChanged: onChanged,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.raleway(color: Colors.white),
              ),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.raleway(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white38, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffF20587), width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color(0xff26141C),
      ),
      dropdownColor: const Color(0xff26141C),
      style: GoogleFonts.raleway(color: Colors.white),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      decoration: BoxDecoration(
        color: const Color(0xffF20587),
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xffF20587), Color(0xffF2059F), Color(0xffF207CB)],
        ),
      ),
      child: TextButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              final docRef = FirebaseFirestore.instance
                  .collection('attendee_profiles')
                  .doc(widget.uid);
              final updateData = {
                'gender': selectedGender,
                'country': selectedCountry,
              };
              await docRef.update(updateData);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error updating profile: $e'),
                ),
              );
            }
          }
        },
        child: Text(
          'Update',
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
