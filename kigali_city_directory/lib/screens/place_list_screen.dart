import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../widgets/listing_cards.dart';
import 'create_place_screen.dart';
import 'edit_place_screen.dart';
import 'screen_map.dart';
import 'listing_detail_screen.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  String searchQuery = "";
  String selectedCategory = "All";

  final List<String> categories = [
    "All",
    "Hospital",
    "Police Station",
    "Library",
    "Restaurant",
    "Café",
    "Park",
    "Tourist Attraction",
    "Pharmacy",
    "School",
    "Bank",
    "Hotel"
  ];

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kigali Directory"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () async {
              final snapshot = await placeProvider.getPlaces().first;
              if (snapshot.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(places: snapshot),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name or category...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.toLowerCase();
                });
              },
            ),
          ),

          // Category Filter Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
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

                // Filter places by search query and category
                final places = snapshot.data!
                    .where((place) =>
                        (place.name.toLowerCase().contains(searchQuery) ||
                        place.category.toLowerCase().contains(searchQuery)) &&
                        (selectedCategory == "All" || 
                        place.category == selectedCategory))
                    .toList();

                if (places.isEmpty) {
                  return const Center(child: Text("No places found"));
                }

                return ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];

                    return PlaceCard(
                      place: place,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(place: place),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditPlaceScreen(place: place)),
                        );
                      },
                      onDelete: () async {
                        await placeProvider.deletePlace(place.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Place deleted")),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePlaceScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}