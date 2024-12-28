import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mehfil/services/stripe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_setup/MapScreen.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final User user;

  const EventDetailsScreen(
      {super.key, required this.event, required this.user});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    logEventData(); // Log the fetched event data to the console
  }

  void logEventData() {
    log("Event Data: ${widget.event}");
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event; // Access the event data

    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: event['eventImage'] != null && event['eventImage'] != ''
                    ? Image.file(
                        File(event['eventImage']), // Local image file
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image, size: 200, color: Colors.white54),
              ),
              const SizedBox(height: 16),

              // Event Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event['eventName'] ?? 'No Event Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    event['ticketPrice'] != null
                        ? "\$${event['ticketPrice']}"
                        : "Free",
                    style: const TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location and Date
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.pink, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    event['venueName'] ?? 'No Venue',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today,
                      color: Colors.pink, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    event['startDate'] != null
                        ? DateFormat('d MMMM yyyy').format(
                            event['startDate'] is DateTime
                                ? event['startDate']
                                : event['startDate']
                                    .toDate(), // For Firestore Timestamp
                          )
                        : 'No Date',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // About Section
              const Text(
                "About",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${event['eventDescription'] ?? 'No Description Available'}\n\n'
                'Venue Address: ${event['venueLocation'] ?? 'No Address'}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Organizers and Attendees
              const Text(
                "Organizers and Attendees",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage('assets/icons/icons8-person-100.png'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Organizers: ${event['organizerName'] ?? 'Unknown'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle chat action
                    },
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Section
              const Text(
                "Location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  if (event['venueLocation'] != null) {
                    final geoPoint =
                        event['venueLocation']; // Firestore GeoPoint
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          eventLocation:
                              LatLng(geoPoint.latitude, geoPoint.longitude),
                          venueName: event['venueName'] ?? 'Event Venue',
                          eventName: event['eventName'] ?? 'Event Name',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No location data available.')),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.white10,
                    child: Column(
                      children: [
                        Image.network(
                          event['locationImage'] ??
                              'https://static1.makeuseofimages.com/wordpress/wp-content/uploads/2022/07/route-marked-on-a-map.jpg',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "See Location",
                          style: TextStyle(color: Colors.pink, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Buy Ticket Button
   GestureDetector(
  onTap: () async {
    try {
      final String userName = widget.user.displayName ?? "Harsh";

      final String date = event['startDate'] != null
          ? DateFormat('d MMMM yyyy').format(
              event['startDate'] is DateTime
                  ? event['startDate']
                  : event['startDate'].toDate(),
            )
          : "No Date";
      final String location = event['venueName'] ?? "Unknown Location";

      // Pass ticketPrice to makePayment
      final int ticketPrice = event['ticketPrice'] != null
          ? int.tryParse(event['ticketPrice'].toString()) ?? 0
          : 0;

      await StripeService.instance.makePayment(
        context,
        userName: userName,
        date: date,
        location: location,
        ticketPrice: ticketPrice, // Pass the ticket price here
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  },
  child: Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: const LinearGradient(
        colors: [
          Color(0xffF20587),
          Color(0xffF2059F),
          Color(0xffF207CB),
        ],
      ),
    ),
    child: Center(
      child: Text(
        'Buy Ticket',
        style: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
