import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(
                  'assets/home/matty-adame-nLUb9GThIcg-unsplash.jpg', // Replace with your image asset
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Event Title and Price
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Party with friends at night - 2022",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "\$30.00",
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Location and Date
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.pink, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "Gandhinagar",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.calendar_today, color: Colors.pink, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "THU 26 May, 09:00",
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
              const Text(
                "We have a team but still missing a couple of people. Let’s play together! "
                "We have a team but still missing a couple of people.",
                style: TextStyle(
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
                  const Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/avatar1.jpg'),
                      ),
                      Positioned(
                        left: 24,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.pink,
                          child: Text(
                            "+15",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Organizers: Wade Warren",
                      style: TextStyle(
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
                  // Handle location view action
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.white10,
                    child: Column(
                      children: [
                        Image.network(
                          'https://tse4.mm.bing.net/th?id=OIP.zkzX0u2OwkUNM222ruYDZQHaEe&pid=Api&P=0&h=180', // Replace with your map placeholder asset
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle ticket purchase action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Buy Ticket",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
