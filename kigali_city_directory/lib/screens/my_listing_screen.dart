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

          if (myPlaces.isEmpty) {
            return const Center(child: Text("You have no listings yet"));
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