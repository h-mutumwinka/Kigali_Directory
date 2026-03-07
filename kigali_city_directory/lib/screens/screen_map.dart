import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place_model.dart';
import 'listing_detail_screen.dart';

class MapScreen extends StatefulWidget {
  final List<Place> places;
  const MapScreen({Key? key, required this.places}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};

  bool get _isMapSupported {
    return kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();

    // Create a marker for each place
    for (var place in widget.places) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.address,
            onTap: () {
              // Navigate to details on marker tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(place: place)),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMapSupported) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
          backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
        ),
        body: const Center(
          child: Text("Map is currently available on Android, iOS, and Web."),
        ),
      );
    }

    final initialLatLng = widget.places.isNotEmpty
        ? LatLng(widget.places.first.latitude, widget.places.first.longitude)
        : const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: initialLatLng, zoom: 12),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
