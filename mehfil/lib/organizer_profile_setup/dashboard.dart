import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mehfil/login_screen.dart';

import '../user_profile_setup/create_event.dart';


class Dashboard extends StatefulWidget {
  final String uid;

  const Dashboard({super.key, required this.uid});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic>? organizerData; // Store fetched organizer data
  bool isLoading = true; // Loading indicator
  List<Map<String, dynamic>> events = []; // Store events data

  @override
  void initState() {
    super.initState();
    fetchOrganizerData();
    fetchOrganizerEvents();
  }

  // Function to fetch organizer profile data
  Future<void> fetchOrganizerData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('organizer_profiles')
          .doc(widget.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          organizerData = docSnapshot.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        log('Organizer profile does not exist');
      }
    } catch (e) {
      log('Error fetching organizer data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to fetch events for the organizer
  Future<void> fetchOrganizerEvents() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('OrganizerId', isEqualTo: widget.uid) // Correct Firestore field name
          .get();

      if (querySnapshot.docs.isEmpty) {
        log('No events found for OrganizerId: ${widget.uid}');
      }

      setState(() {
        events = querySnapshot.docs
            .map((doc) => doc.data())
            .toList();
      });
    } catch (e) {
      log('Error fetching events: $e');
    }
  }

  // Function to sign out and navigate to the login screen
  Future<void> _signOutAndNavigate() async {
    try {
      // Sign out the user from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Navigate to the Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),  // Replace with your LoginScreen
      );
    } catch (e) {
      log('Error signing out: $e');
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
        title: Text(
          "Dashboard",
          style: GoogleFonts.raleway(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: _signOutAndNavigate, // Call the sign-out function
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ],
        backgroundColor: const Color(0xff26141C),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : organizerData == null
              ? const Center(
                  child: Text(
                    'No Data Found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Section
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber),
                                child: ClipOval(
                                  child: organizerData!['imagePath'] != null
                                      ? Image.file(
                                          File(organizerData!['imagePath']),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.person,
                                                      size: 50),
                                        )
                                      : const Icon(Icons.person, size: 50),
                                ),
                              ),
                            ),
                            const SizedBox(width: 9),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  organizerData!['businessName'] ?? 'N/A',
                                  style: GoogleFonts.raleway(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  organizerData!['contactEmail'] ?? 'N/A',
                                  style: GoogleFonts.raleway(
                                      color: Colors.white38,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )
                          ],
                        ),

                        // Description Section
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            organizerData!['businessDescription'] ?? 'No Description Available',
                            style: GoogleFonts.raleway(
                              color: Colors.white38,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        // Manage Your Events Section
                        Text(
                          "Manage Your Events",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Display Events
                        events.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'No events to display.',
                                  style: GoogleFonts.raleway(
                                      color: Colors.white38, fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    child: Card(
                                      color: const Color(0xff39202D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.amber,
                                          child: event['eventImage'] != null
                                              ? ClipOval(
                                                  child: Image.file(
                                                    File(event['eventImage']),
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                          Icons.broken_image,
                                                          color: Colors.white);
                                                    },
                                                  ),
                                                )
                                              : const Icon(Icons.event,
                                                  color: Colors.white),
                                        ),
                                        title: Text(
                                          event['eventName'] ?? 'Unnamed Event',
                                          style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          event['eventDescription'] ?? 'No description provided',
                                          style: GoogleFonts.raleway(
                                            color: Colors.white38,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open BottomSheet from EventCreationScreen
          _showEventCreationBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show the EventCreation BottomSheet
  void _showEventCreationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff26141C),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const EventCreationScreen();
      },
    );
  }
}
