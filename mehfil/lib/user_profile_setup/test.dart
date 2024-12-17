// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// // Main Dashboard Screen
// class DashboardScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> events = [
//     {"name": "Music Concert", "date": "Jan 20, 2025", "status": "Ongoing"},
//     {"name": "Art Exhibition", "date": "Feb 10, 2025", "status": "Scheduled"},
//     {"name": "Tech Meetup", "date": "Mar 15, 2025", "status": "Completed"},
//   ];

//   final Map<String, dynamic> insights = {
//     "totalRevenue": 12000,
//     "totalBookings": 450,
//     "averageRating": 4.5,
//     "topEvents": [
//       {"name": "Music Concert", "bookings": 200, "revenue": 8000},
//       {"name": "Art Exhibition", "bookings": 150, "revenue": 3000},
//     ]
//   };

//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Organizer Dashboard',
//             style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Welcome back, Organizer!',
//                 style: GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),

//             // Quick Stats Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   QuickStatCard(
//                       title: 'Total Revenue', value: '\$${insights["totalRevenue"]}'),
//                   QuickStatCard(
//                       title: 'Total Bookings', value: '${insights["totalBookings"]}'),
//                   QuickStatCard(
//                       title: 'Average Rating', value: '${insights["averageRating"]} ⭐'),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Upcoming Events Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'Upcoming Events',
//                 style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 150,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: events.length,
//                 itemBuilder: (context, index) {
//                   return EventCard(
//                     name: events[index]["name"],
//                     date: events[index]["date"],
//                     status: events[index]["status"],
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Insights Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'Insights',
//                 style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: insights["topEvents"].length,
//               itemBuilder: (context, index) {
//                 var event = insights["topEvents"][index];
//                 return InsightCard(
//                   name: event["name"],
//                   bookings: event["bookings"],
//                   revenue: event["revenue"],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Quick Stats Card
// class QuickStatCard extends StatelessWidget {
//   final String title;
//   final String value;

//   const QuickStatCard({super.key, required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.teal.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(title,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.raleway(
//                   fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
//           const SizedBox(height: 8),
//           Text(value,
//               style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

// // Event Card Widget
// class EventCard extends StatelessWidget {
//   final String name;
//   final String date;
//   final String status;

//   const EventCard({super.key, required this.name, required this.date, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       margin: const EdgeInsets.only(left: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, spreadRadius: 1)
//         ],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(name,
//               style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 5),
//           Text(date, style: GoogleFonts.raleway(fontSize: 14, color: Colors.black54)),
//           const SizedBox(height: 10),
//           Text('Status: $status',
//               style: GoogleFonts.raleway(fontSize: 12, color: Colors.teal)),
//         ],
//       ),
//     );
//   }
// }

// // Insights Card Widget
// class InsightCard extends StatelessWidget {
//   final String name;
//   final int bookings;
//   final int revenue;

//   const InsightCard({super.key, required this.name, required this.bookings, required this.revenue});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, spreadRadius: 1)
//         ],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(name,
//                   style: GoogleFonts.raleway(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//               const SizedBox(height: 5),
//               Text('Bookings: $bookings',
//                   style: GoogleFonts.raleway(fontSize: 14, color: Colors.black54)),
//               Text('Revenue: \$$revenue',
//                   style: GoogleFonts.raleway(fontSize: 14, color: Colors.teal)),
//             ],
//           ),
//           const Icon(Icons.bar_chart, color: Colors.teal, size: 30),
//         ],
//       ),
//     );
//   }
// }
