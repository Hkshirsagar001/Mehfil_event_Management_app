import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mehfil/organizer_profile_setup/dasboard_menu.dart';

class OrganizerProfilePage extends StatefulWidget {
  const OrganizerProfilePage({super.key});

  @override
  State<OrganizerProfilePage> createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? selectedBusinessType = 'Event Planning';
  bool agreedToTerms = false;
  String? _imagePath; // Local image path

  // Controllers for form fields
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  // Function to submit the profile data
  // Function to submit the profile data
Future<void> _submitProfileData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user logged in')));
      return;
    }

    // Save organizer profile data
    await FirebaseFirestore.instance
        .collection('organizer_profiles')
        .doc(user.uid)
        .set({
      'imagePath': _imagePath ?? '',
      'businessName': businessNameController.text,
      'businessType': selectedBusinessType,
      'businessDescription': businessDescriptionController.text,
      'contactEmail': contactEmailController.text,
      'contactPhone': contactPhoneController.text,
      'website': websiteController.text,
      'location': locationController.text,
      'facebook': facebookController.text,
      'instagram': instagramController.text,
      'linkedin': linkedinController.text,
      'agreedToTerms': agreedToTerms,
    });

    // Update 'newLogin' flag to false in the 'users' collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'newLogin': false,
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Submitted Successfully')));

    // Navigate to Dashboard screen and pass uid
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashMenu(uid: user.uid)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      appBar: AppBar(
        title: Text(
          'Organizer Profile',
          style: GoogleFonts.raleway(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff26141C),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPage1(),
                _buildPage2(),
              ],
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LinearProgressIndicator(
        value: (_currentPage + 1) / 2,
        backgroundColor: Colors.white38,
        color:const Color(0xffF20587),
        minHeight: 7,
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _imagePath != null ? FileImage(File(_imagePath!)) : null,
                child: _imagePath == null
                    ? Icon(Icons.add_a_photo_outlined,
                        size: 50, color: Colors.grey[700])
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Business Name'),
          _customTextField(
              controller: businessNameController, hint: 'EventAura'),
          _sectionTitle('Business Type'),
          _customDropdown(['Event Planning', 'Catering', 'Photography'],
              selectedBusinessType, (value) {
            setState(() => selectedBusinessType = value);
          }),
          _sectionTitle('Business Description'),
          _customTextField(
              controller: businessDescriptionController,
              hint: 'We organize events.',
              maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _sectionTitle('Contact Email'),
          _customTextField(
              controller: contactEmailController, hint: 'info@eventaura.com'),
          _sectionTitle('Contact Phone'),
          _customTextField(
              controller: contactPhoneController, hint: '1234567890'),
          _sectionTitle('Website URL'),
          _customTextField(
              controller: websiteController, hint: 'www.eventaura.com'),
          _sectionTitle('Location'),
          _customTextField(
              controller: locationController, hint: 'New York, NY'),
          _sectionTitle('Social Links'),
          _customTextField(
              controller: facebookController, hint: 'facebook.com/eventaura'),
          _customTextField(
              controller: instagramController, hint: 'instagram.com/eventaura'),
          _customTextField(
              controller: linkedinController,
              hint: 'linkedin.com/company/eventaura'),
          CheckboxListTile(
            value: agreedToTerms,
            title: const Text('I agree to the Terms and Conditions',
                style: TextStyle(color: Colors.white)),
            checkColor:const Color(0xffF20587),
            fillColor: const WidgetStatePropertyAll(Color(0xff26141C)),
            onChanged: (value) => setState(() => agreedToTerms = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          if (_currentPage < 1) {
            setState(() {
              _currentPage++;
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            });
          } else {
            _submitProfileData();
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xffF20587), Color(0xffF207CB)],
            ),
          ),
          child: Center(
            child: Text(
              _currentPage < 1 ? "Next" : "Submit",
              style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.raleway(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
  }) {
    return TextFormField(
  controller: controller,
  maxLines: maxLines,
  decoration: InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white38),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Color(0xffF20587), 
        width: 2.0,         
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.white38, // Default border color when not focused
      ),
    ),
  ),
  style: const TextStyle(color: Colors.white),
);

  }

  Widget _customDropdown(
    List<String> items, String? value, ValueChanged<String?> onChanged) {
  return DropdownButtonFormField(
    value: value,
    items: items
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList(),
    onChanged: onChanged,
    dropdownColor: Colors.black,
    style: const TextStyle(color: Colors.white),
    decoration: const InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.white38, // Default border color when not focused
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.white38, // Default border color
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color(0xffF20587), 
          width: 2.0,
        ),
      ),
    ),
  );
}

}
