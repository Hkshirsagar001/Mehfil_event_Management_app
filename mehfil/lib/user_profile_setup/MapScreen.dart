import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final LatLng eventLocation; // Event location passed from the previous screen
  final String venueName; // Venue name to display on the map
  final String eventName; // Event name to display at the bottom

  const MapScreen({
    super.key,
    required this.eventLocation,
    required this.venueName,
    required this.eventName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  void _openInMaps() {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.eventLocation.latitude},${widget.eventLocation.longitude}';
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Event Location', 
        style: GoogleFonts.raleway( 
          color: Colors.white
        ),),
        backgroundColor: const Color(0xff26141C),
        leading: IconButton(
          onPressed:() {
            Navigator.of(context).pop(); 
          }, 
        icon: const Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white, size: 40,)),
      ),
      body: Column(
        children: [
          // Flexible widget for the map
          Flexible(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.eventLocation,
                zoom: 15, // Adjust zoom level as needed
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('event_location'),
                  position: widget.eventLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: widget.venueName,
                    snippet: "Tap for directions",
                  ),
                ),
              },
              zoomControlsEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),

          // Event details at the bottom
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.venueName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _openInMaps,
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text("Open in Maps"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
