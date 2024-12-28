import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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
  final LatLng fixedLocation = const LatLng(18.453878, 73.827750);

  Set<Polyline> _polylines = {};
  String? _totalDistance; // Variable to store total distance
  final String _apiKey = 'AIzaSyA6p-fGFQeiW5wFjjfWLgIALZU5KhvhWus';

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${fixedLocation.latitude},${fixedLocation.longitude}&destination=${widget.eventLocation.latitude},${widget.eventLocation.longitude}&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0]['overview_polyline']['points'];
        final points = _decodePolyline(route);

        // Extract total distance in text format
        final totalDistance = data['routes'][0]['legs'][0]['distance']['text'];

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("route"),
              points: points,
              color: Colors.pink,
              width: 5,
            ),
          };

          _totalDistance = totalDistance; // Update distance variable
        });
      }
    } else {
      print('Failed to fetch directions: ${response.body}');
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> coordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
  }

  void _openInMaps() {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${fixedLocation.latitude},${fixedLocation.longitude}&destination=${widget.eventLocation.latitude},${widget.eventLocation.longitude}&travelmode=driving';
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map Direction',
          style: GoogleFonts.raleway(color: Colors.white),
        ),
        backgroundColor: const Color(0xff26141C),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.eventLocation,
                    zoom: 15,
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
                    Marker(
                      markerId: const MarkerId('fixed_location'),
                      position: fixedLocation,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      infoWindow: const InfoWindow(
                        title: "Starting Point",
                      ),
                    ),
                  },
                  polylines: _polylines,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff26141C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          "Search",
                          style: GoogleFonts.raleway(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xff26141C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                const SizedBox(height: 8),
                if (_totalDistance != null)
                  Text(
                    'Distance: $_totalDistance',
                    style: const TextStyle(
                      color: Color(0xffF20587),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _openInMaps, // Handle the tap event
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffF20587),Color(0xffF2059F), Color(0xffF207CB)]),
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    width: double.infinity, // Full width
                    height: 50, // Fixed height
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center contents
                      children: [
                        Icon(Icons.directions, color: Colors.white), // Icon
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "Open in Maps",
                          style: TextStyle(color: Colors.white), // Text style
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
