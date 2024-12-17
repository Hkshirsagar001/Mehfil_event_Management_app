
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mehfil/search_result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Adding listener to the FocusNode
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _navigateToAnotherScreen();
      }
    });

    // Adding listener to the TextEditingController
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _navigateToAnotherScreen();
      }
    });
  }

  void _navigateToAnotherScreen() {
    // Add your navigation logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchResultsScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"name": "Business", "icon": "\u{1F4BC}"},
      {"name": "Community", "icon": "\u{1F46B}"},
      {"name": "Music & Entertainment", "icon": "\u{1F3B5}"},
      {"name": "Health", "icon": "\u{2695}"},
      {"name": "Food & Drink", "icon": "\u{1F37D}"},
      {"name": "Family & Education", "icon": "\u{1F468}"},
      {"name": "Sport", "icon": "\u{26BD}"},
      {"name": "Fashion", "icon": "\u{1F457}"},
      {"name": "Film & Media", "icon": "\u{1F3A5}"},
      {"name": "Home & Lifestyle", "icon": "\u{1F3E1}"},
      {"name": "Design", "icon": "\u{1F3A8}"},
      {"name": "Gaming", "icon": "\u{1F3AE}"},
      {"name": "Science & Tech", "icon": "\u{1F4BB}"},
      {"name": "School & Education", "icon": "\u{1F393}"},
      {"name": "Holiday", "icon": "\u{1F384}"},
      {"name": "Travel", "icon": "\u{2708}"},
    ];

    final List<Map<String, String>> upcomingEvents = [
      {
        "event": "Tech Conference 2024",
        "location": "New York",
        "image": "assets/home/axville-5WrxWltrCTg-unsplash.jpg",
      },
      {
        "event": "Food Festival",
        "location": "Los Angeles",
        "image": "assets/home/jason-leung-Xaanw0s0pMk-unsplash.jpg",
      },
    ];

    final List<Map<String, String>> popularNow = [
    {
      'title': 'Going to a Rock Concert',
      'date': 'THU 26 May, 09.00 - FRI 27 May, 10:00',
      'price': '\$30.00',
      'image': 'assets/home/matty-adame-nLUb9GThIcg-unsplash.jpg',
    },
    {
      'title': 'Art Workshop',
      'date': 'SAT 28 May, 14:00 - SAT 28 May, 17:00',
      'price': '\$20.00',
      'image': 'assets/home/vishnu-r-nair-m1WZS5ye404-unsplash.jpg',
    },
    {
      'title': 'Food Festival',
      'date': 'SUN 29 May, 12:00 - SUN 29 May, 18:00',
      'price': '\$15.00',
      'image': 'assets/home/samantha-gades-fIHozNWfcvs-unsplash.jpg',
    },
  ];
    final List<Map<String, String>> recommendations = [
    {
      'title': 'Dance party at the top of the town - 2022',
      'location': 'New York',
      'price': '\$30.00',
      'image': 'assets/home/axville-5WrxWltrCTg-unsplash.jpg',
    },
    {
      'title': 'Festival event at kudasan - 2022',
      'location': 'California',
      'price': 'Free',
      'image': 'assets/home/jason-leung-Xaanw0s0pMk-unsplash.jpg',
    },
    {
      'title': 'Party with friends at night - 2022',
      'location': 'Miami',
      'price': 'Free',
      'image': 'assets/home/matty-adame-nLUb9GThIcg-unsplash.jpg',
    },
    {
      'title': 'Satellite mega festival - 2022',
      'location': 'California',
      'price': '\$30.00',
      'image': 'assets/home/axville-5WrxWltrCTg-unsplash.jpg',
    },
  ];

    return Scaffold(
       backgroundColor: const Color(0xff26141C),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/icons8-location-48.png',
                              width: 25,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Pune, Maharashtra",
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.white10,
                    child: const Icon(Icons.notification_important,color: Colors.white70,),
                  )
                ],
              ),
              const SizedBox(height: 16),
              TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              size: 40,
            ),
            hintText: "Search",
            hintStyle: GoogleFonts.raleway(
              color: Colors.white38,
              fontSize: 18,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Color(0xffF20587),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.white38,
              ),
            ),
          ),
        ),
              
              const SizedBox(height: 15),
              SizedBox(
                height: 60, // Constrain height for ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white38),
                          color: Colors.white38.withOpacity(0.04),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  category['icon']!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  category['name']!,
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
         const SizedBox(height: 15),
              //upcoming Events
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Upcoming Events",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "See All",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      color: Colors.white10,
                      // margin:
                      //     const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Event Image
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(event["image"]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Event Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event["event"]!,
                                    style: GoogleFonts.raleway(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/icons8-location-48.png',
                                        width: 20,
                                        color: Colors.white54,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        event["location"]!,
                                        style: GoogleFonts.raleway(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 90,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xffF20587),
                                                Color(0xffF2059F),
                                                Color(0xffF207CB)
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Join",
                                              style: GoogleFonts.raleway(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        
         const SizedBox(height: 15),
              //popular now
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Popular Now",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "See All",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,), 
          SizedBox(
            height: 220, // Total height for the cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularNow.length,
              itemBuilder: (BuildContext context, int index) {
                final event = popularNow[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top Image Container
                        Container(
                          width: 300,
                          height: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                            ),
                            child: Image.asset(
                              event['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Bottom Details Container
                        Container(
                          width: 300,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title']!,
                                  style: GoogleFonts.raleway(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event['date']!,
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.pink.withOpacity(0.1),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            event['price']!,
                                            style: GoogleFonts.raleway(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
           const SizedBox(height: 15),
           Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Recommendation for you",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "See All",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),
        
          ListView.builder(
            shrinkWrap: true,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final item = recommendations[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                           color:  Colors.white10, // Card background color
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // Image Section
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                              child: Image.asset(
                                item['image']!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Details Section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.white54,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item['location']!,
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Price Section
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF007F).withOpacity(0.1), // Light pink background
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    item['price']!,
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFF007F),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
