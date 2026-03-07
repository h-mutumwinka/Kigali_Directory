import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../widgets/listing_cards.dart';
import 'cafes_screen.dart';
import 'edit_place_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({Key? key}) : super(key: key);

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kigali City"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Category buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CafesScreen(),
                    ),
                  );
                },
                child: const Text("Cafés"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // You can add other screens like PharmaciesScreen here
                },
                child: const Text("Pharmacies"),
              ),
            ],
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for service",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.toLowerCase();
                });
              },
            ),
          ),

          // Near You label
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Near You",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // List of places
          Expanded(
            child: StreamBuilder(
              stream: placeProvider.getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final places = snapshot.data!
                    .where((place) => place.name.toLowerCase().contains(searchQuery))
                    .toList();

                if (places.isEmpty) {
                  return const Center(
                    child: Text(
                      "No services found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];

                    return PlaceCard(
                      place: place,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditPlaceScreen(place: place),
                          ),
                        );
                      },
                      onDelete: () {
                        placeProvider.deletePlace(place.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}