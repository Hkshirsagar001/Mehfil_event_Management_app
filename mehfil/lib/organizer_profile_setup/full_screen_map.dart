import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenMapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng) onLocationSelected;

  const FullScreenMapScreen({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  _FullScreenMapScreenState createState() => _FullScreenMapScreenState();
}

class _FullScreenMapScreenState extends State<FullScreenMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? const LatLng(18.5204, 73.8567); // Default to Pune
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: const Color(0xffF20587),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation!,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLocation!,
                      infoWindow: const InfoWindow(title: 'Selected Location'),
                    ),
                  }
                : {},
            zoomControlsEnabled: false, // Disable default zoom controls
            mapToolbarEnabled: false, // Disable map toolbar
          ),
          Positioned(
            left: 10,
            bottom: 50,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    _mapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                  mini: true,
                  backgroundColor: const Color(0xffF20587),
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    _mapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                  mini: true,
                  backgroundColor: const Color(0xffF20587),
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedLocation != null) {
            widget.onLocationSelected(_selectedLocation!);
            Navigator.pop(context);
          }
        },
        backgroundColor: const Color(0xffF20587),
        child: const Icon(Icons.check),
      ),
    );
  }
}
