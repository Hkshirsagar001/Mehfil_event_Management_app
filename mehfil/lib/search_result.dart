import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mehfil/event_detail.dart';

class SearchResultsScreen extends StatefulWidget {
  final User user;

  const SearchResultsScreen({super.key, required this.user});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events from Firestore
    searchController.addListener(() {
      filterEvents(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchEvents() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('events').get();

      final fetchedEvents = snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              })
          .where((event) => event['eventName'] != null)
          .toList();

      setState(() {
        allEvents = fetchedEvents;
        filteredEvents = fetchedEvents;
      });
    } catch (error) {
      debugPrint('Error fetching events: $error');
    }
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredEvents = allEvents;
      });
    } else {
      setState(() {
        filteredEvents = allEvents
            .where((event) =>
                event['eventName']
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff26141C),
        title: const Text('Search Events'),
      ),
      backgroundColor: const Color(0xff26141C),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                hintText: 'Search events...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),
          ),
          Expanded(
            child: filteredEvents.isEmpty
                ? const Center(
                    child: Text(
                      'No events found',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(
                                  event: event, user: widget.user),
                            ),
                          );
                        },
                        child: Card(
  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  color: const Color(0xff1F1A24),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: event['eventImage'] != null && event['eventImage'] != ''
              ? Image.file(
                  File(event['eventImage']!),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.image,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['eventName'] ?? 'No Event Name',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Text(
                event['date'] ?? 'Date not available',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                event['time'] ?? 'Time not available',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        const Icon(
          Icons.favorite_border,
          color: Colors.pink,
          size: 24.0,
        ),
      ],
    ),
  ),
),

                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
