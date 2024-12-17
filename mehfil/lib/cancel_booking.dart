import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CancelBookingApp());
}

class CancelBookingApp extends StatelessWidget {
  const CancelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CancelBookingScreen(),
    );
  }
}

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? _selectedReason;
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      appBar: AppBar(
        title: Text(
          'Cancel Booking',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: const Color(0xff26141C),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please select the reason for cancellation',
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                   color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildRadioOption('I have better deal'),
            _buildRadioOption('Some other work, can’t come'),
            _buildRadioOption('I want to book another event'),
            _buildRadioOption('Venue location is too far from my location'),
            _buildRadioOption('Another reason'),
            if (_selectedReason == 'Another reason') ...{
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'Tell us Reason',
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.white),
              ),

            },
            
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Handle cancel booking logic
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                     begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffF20587),
                        Color(0xffF2059F),
                        Color(0xffF207CB)
                      ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Cancel Booking',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: GoogleFonts.raleway(
          textStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      value: title,
      groupValue: _selectedReason,
      activeColor: const Color(0xFFFF0099),
      onChanged: (value) {
        setState(() {
          _selectedReason = value;
        });
      },
    );
  }
}
