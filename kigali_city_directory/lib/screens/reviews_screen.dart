import 'package:flutter/material.dart';
import '../models/place_model.dart';

class ReviewsScreen extends StatelessWidget {
  final Place place;

  const ReviewsScreen({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with Firestore reviews later
    final reviews = [
      {"name": "Eric", "comment": "Fav spot to get work done. Great coffee and friendly staff."},
      {"name": "Sarah", "comment": "Relaxing atmosphere, tasty drinks, and good wifi."},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("${place.name} Reviews"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Average Rating ⭐⭐⭐⭐ (${reviews.length} reviews)",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // List of reviews
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(review["name"]!),
                      subtitle: Text(review["comment"]!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}