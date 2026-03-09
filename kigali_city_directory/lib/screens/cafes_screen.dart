import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../widgets/listing_cards.dart';
import 'edit_place_screen.dart';

class CafesScreen extends StatefulWidget {
  const CafesScreen({Key? key}) : super(key: key);

  @override
  State<CafesScreen> createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cafés"),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search cafes...",
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

          
          Expanded(
            child: StreamBuilder(
              stream: placeProvider.getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                
                final cafes = snapshot.data!
                    .where((place) =>
                        place.category.toLowerCase() == "cafe" &&
                        (place.name.toLowerCase().contains(searchQuery) ||
                            place.category.toLowerCase().contains(searchQuery)))
                    .toList();

                if (cafes.isEmpty) {
                  return const Center(child: Text("No cafés found"));
                }

                return ListView.builder(
                  itemCount: cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = cafes[index];

                    return PlaceCard(
                      place: cafe,
                      onEdit: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditPlaceScreen(place: cafe),
                          ),
                        );
                      },
                      onDelete: () {
                      
                        placeProvider.deletePlace(cafe.id);
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
