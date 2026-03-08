import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../providers/auth_provider.dart' as auth;
import '../widgets/listing_cards.dart';
import 'create_place_screen.dart';
import 'edit_place_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({Key? key}) : super(key: key);

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);

    final currentUserId = authProvider.user?.uid ?? "";
    
    print('🔍 My Listings - Current User ID: $currentUserId');

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Listings"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
      ),
      body: StreamBuilder(
        stream: placeProvider.getPlaces(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter places by current user
          final myPlaces = snapshot.data!
              .where((place) => place.userId == currentUserId)
              .toList();
          
          print('🔍 Total places: ${snapshot.data!.length}');
          print('🔍 My places: ${myPlaces.length}');
          for (var place in snapshot.data!) {
            print('   Place: ${place.name}, userId: ${place.userId}');
          }

          if (myPlaces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "You have no listings yet",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your ID: $currentUserId",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatePlaceScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create Your First Listing"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: myPlaces.length,
            itemBuilder: (context, index) {
              final place = myPlaces[index];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CreatePlaceScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePlaceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}