import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place_model.dart';
import 'reviews_screen.dart';
import 'booking_screen.dart';

class DetailScreen extends StatelessWidget {
  final Place place;

  const DetailScreen({Key? key, required this.place}) : super(key: key);

  Future<void> _launchMapsNavigation() async {
    final lat = place.latitude;
    final lng = place.longitude;
    
    // Try Google Maps app first, fallback to web
    final googleMapsUrl = Uri.parse('google.navigation:q=$lat,$lng');
    final fallbackUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    try {
      final canLaunchGoogleMaps = await canLaunchUrl(googleMapsUrl);
      if (canLaunchGoogleMaps) {
        await launchUrl(googleMapsUrl);
      } else {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Fallback to web URL
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Placeholder image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 60),
            ),
            const SizedBox(height: 20),

            // Name & category
            Text(
              place.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("${place.category} • ${place.address}"),
            const SizedBox(height: 10),

            // Description
            Text(
              place.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Contact
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.blue),
                const SizedBox(width: 8),
                Text(place.contact),
              ],
            ),
            const SizedBox(height: 10),

            // Location coordinates
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Lat: ${place.latitude.toStringAsFixed(4)}, '
                  'Lng: ${place.longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Embedded Map Preview
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(place.latitude, place.longitude),
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.hero.kigali_city',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(place.latitude, place.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Book Now Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(place: place),
                  ),
                );
              },
              icon: const Icon(Icons.event_available, color: Colors.white),
              label: const Text(
                "Book Appointment",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Navigation Button
            ElevatedButton.icon(
              onPressed: _launchMapsNavigation,
              icon: const Icon(Icons.navigation, color: Colors.white),
              label: const Text(
                "Navigate with Google Maps",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Buttons
            ElevatedButton(
              onPressed: () {
                // TODO: implement rating functionality
              },
              child: const Text("Rate this service"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReviewsScreen(place: place),
                  ),
                );
              },
              child: const Text("Reviews"),
            ),
          ],
        ),
      ),
    );
  }
}