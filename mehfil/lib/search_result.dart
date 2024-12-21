import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mehfil/event_detail.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
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
                  borderRadius: BorderRadius.circular(12.0),
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
                          // Navigate to EventDetailsScreen with event data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailsScreen(event: event),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xff1F1A24),
                          child: ListTile(
                            leading: event['eventImage'] != null &&
                                    event['eventImage'] != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 60,
                                        maxHeight: 60,
                                      ),
                                      child: Image.file(
                                        File(event['eventImage']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.image,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                            title: Text(
                              event['eventName'] ?? 'No Event Name',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              event['venueName'] ?? 'No Venue',
                              style: const TextStyle(color: Colors.white54),
                            ),
                            trailing: Text(
                              event['ticketPrice'] != null
                                  ? '\$${event['ticketPrice']}'
                                  : 'Free',
                              style: const TextStyle(color: Colors.pink),
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
