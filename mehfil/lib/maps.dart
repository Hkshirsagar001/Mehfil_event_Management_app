import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  String _distance = '';
  List<LatLng> _routePoints = [];
  GoogleMapController? _mapController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required to use this feature.')),
      );
    }
  }

  Future<void> _findRoute() async {
    final start = _startController.text.split(',').map((e) => e.trim()).toList();
    final end = _endController.text.split(',').map((e) => e.trim()).toList();

    if (start.length == 2 && end.length == 2) {
      final startLat = double.tryParse(start[0]);
      final startLng = double.tryParse(start[1]);
      final endLat = double.tryParse(end[0]);
      final endLng = double.tryParse(end[1]);

      if (startLat != null && startLng != null && endLat != null && endLng != null) {
        setState(() {
          _isLoading = true;
          _distance = '';
          _routePoints = [];
        });

        final url =
            'http://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat?overview=full&geometries=geojson';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final distance = data['routes'][0]['distance'] / 1000; // Convert to kilometers
          final geometry = data['routes'][0]['geometry']['coordinates'] as List;

          final points = geometry
              .map((point) => LatLng(point[1] as double, point[0] as double))
              .toList();

          setState(() {
            _distance = '${distance.toStringAsFixed(2)} km';
            _routePoints = points;
            _isLoading = false;
          });

          // Move the camera to the route
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(
                _getLatLngBounds(points),
                50,
              ),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
            _distance = 'Failed to fetch route';
          });
        }
      } else {
        _showError('Invalid coordinates');
      }
    } else {
      _showError('Enter valid start and end points');
    }
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
      _distance = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Finder'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            onMapCreated: (controller) => _mapController = controller,
            polylines: {
              if (_routePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('route'),
                  color: Colors.blue,
                  width: 5,
                  points: _routePoints,
                ),
            },
            markers: {
              if (_routePoints.isNotEmpty)
                Marker(
                  markerId: const MarkerId('start'),
                  position: _routePoints.first,
                ),
              if (_routePoints.isNotEmpty)
                Marker(
                  markerId: const MarkerId('end'),
                  position: _routePoints.last,
                ),
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        labelText: 'Start Point (lat,lng)',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _endController,
                      decoration: const InputDecoration(
                        labelText: 'End Point (lat,lng)',
                        prefixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _findRoute,
                      child: const Text('Find Route'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_distance.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  'Distance: $_distance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
