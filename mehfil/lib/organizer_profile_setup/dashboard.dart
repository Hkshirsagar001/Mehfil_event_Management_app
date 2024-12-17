import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  final String uid;

  const Dashboard({super.key, required this.uid});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic>? organizerData; // Store fetched data
  bool isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    fetchOrganizerData();
  }

  // Function to fetch data from Firestore
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
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
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
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.logout, color: Colors.white),
          )
        ],
        backgroundColor: const Color(0xff26141C),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : organizerData == null
              ? const Center(
                  child: Text('No Data Found',
                      style: TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Section
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.amber),
                              child: ClipOval(
                                child: organizerData!['imagePath'] != null
                                    ? Image.file(
                                        File(organizerData!['imagePath']),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            const Icon(Icons.person, size: 50),
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
                        ]),

                        // Description Section
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            organizerData!['businessDescription'] ??
                                'No Description Available',
                            style: GoogleFonts.raleway(
                                color: Colors.white38,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),

                        // Manage Your Events Section
                        Text(
                          "Manage Your Events",
                          style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const EventInfo();
                                  }));
                                },
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.amber,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Event ${index + 1}",
                                      style: GoogleFonts.raleway(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class EventInfo extends StatefulWidget {
  const EventInfo({super.key});

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Event Details")),
    );
  }
}
