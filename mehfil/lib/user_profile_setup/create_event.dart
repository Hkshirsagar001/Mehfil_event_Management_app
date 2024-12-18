import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _venueNameController = TextEditingController();
  final TextEditingController _venueAddressController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _ticketLimitController = TextEditingController();

  // Date controller
  DateTime _startDate = DateTime.now();

  // Variables for image selection
  XFile? _eventImage;

  // Dropdown variables
  String? _eventCategory;
  String? _eventType = 'In-person';
  List<String> categories = ['Music', 'Sports', 'Workshop', 'Conference'];

  // Firebase Firestore and Auth references
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _eventNameController,
                    label: 'Event Name',
                    validator: 'Please enter the event name',
                  ),
                  _buildDropdownField(
                    label: 'Event Category',
                    value: _eventCategory,
                    items: categories,
                    onChanged: (value) {
                      setState(() {
                        _eventCategory = value;
                      });
                    },
                  ),
                  _buildTextField(
                    controller: _eventDescriptionController,
                    label: 'Event Description',
                    validator: 'Please enter a description',
                    maxLines: 3,
                  ),
                  _buildDropdownField(
                    label: 'Event Type',
                    value: _eventType,
                    items: ['In-person', 'Virtual', 'Hybrid'],
                    onChanged: (value) {
                      setState(() {
                        _eventType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  _buildDatePickerField(
                    label: 'Event Date',
                    date: _startDate,
                    onTap: () async {
                      await _selectStartDate();
                    },
                  ),
                  _buildTextField(
                    controller: _venueNameController,
                    label: 'Venue Name',
                    validator: 'Please enter the venue name',
                  ),
                  _buildTextField(
                    controller: _venueAddressController,
                    label: 'Venue Address',
                    validator: 'Please enter the venue address',
                  ),
                  _buildImagePicker(),
                  _buildTextField(
                    controller: _ticketPriceController,
                    label: 'Ticket Price',
                    keyboardType: TextInputType.number,
                    validator: 'Please enter a ticket price',
                  ),
                  _buildTextField(
                    controller: _ticketLimitController,
                    label: 'Number of Tickets',
                    keyboardType: TextInputType.number,
                    validator: 'Please enter the ticket limit',
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Common TextFormField builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validator,
    int? maxLines,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: GoogleFonts.raleway(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.raleway(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xffF20587), width: 2.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validator;
          }
          return null;
        },
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }

  // DropdownButtonFormField builder
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: GoogleFonts.raleway(
                  color: const Color(0xffF20587), fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.raleway(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xffF20587), width: 2.0),
          ),
        ),
      ),
    );
  }

  // Date picker field builder
  Widget _buildDatePickerField({
    required String label,
    required DateTime date,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: AbsorbPointer(
        child: TextFormField(
          style: GoogleFonts.raleway(color: Colors.white),
          controller: TextEditingController(
            text: DateFormat('EEEE, dd MMMM').format(date),
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.raleway(color: Colors.white),
            hintText: DateFormat('EEEE, dd MMMM').format(date),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xffF20587), width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  // Image Picker button
  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Upload Event Image',
              style: GoogleFonts.raleway(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: TextButton.icon(
                  onPressed: _pickEventImage,
                  icon: const Icon(
                    Icons.upload_file,
                    color: Color(0xffF20587),
                  ),
                  label: Text(
                    'Choose Image',
                    style: GoogleFonts.raleway(
                        color: const Color(0xffF20587),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle image picking
  Future<void> _pickEventImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
    );
    setState(() {
      _eventImage = pickedFile;
    });
  }

  // Submit button
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
         if (_formKey.currentState?.validate() ?? false) {
          _submitEvent();
        }
      },
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
              "Create Event",
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

  // Submit event logic
  Future<void> _submitEvent() async {
    final user = _auth.currentUser;
    if (user == null) {
      // If user is not authenticated, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to create an event.')),
      );
      return;
    }

    String? imagePath = _eventImage?.path;

    // Store event data in Firestore
    await _firestore.collection('events').add({
      'eventName': _eventNameController.text,
      'eventDescription': _eventDescriptionController.text,
      'venueName': _venueNameController.text,
      'venueAddress': _venueAddressController.text,
      'ticketPrice': _ticketPriceController.text,
      'ticketLimit': _ticketLimitController.text,
      'startDate': _startDate,
      'eventCategory': _eventCategory,
      'eventType': _eventType,
      'eventImage': imagePath,  // Store local image path
      'OrganizerId': user.uid,  // Store UID of the user who created the event
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created successfully!')),
    );

    // Optionally, navigate back or clear form
    Navigator.pop(context);
  }

  // Select start date
  Future<void> _selectStartDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }
}
