import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get places =>
      _db.collection("places");

  Future createPlace(Place place) async {
    await places.add(place.toMap());
  }

  Future updatePlace(Place place) async {
    await places.doc(place.id).update(place.toMap());
  }

  Future deletePlace(String id) async {
    await places.doc(id).delete();
  }

  Stream<List<Place>> getPlaces() {
    return places
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Place.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Seeds initial Kigali places if Firestore is empty
  Future<void> seedInitialData(String userId) async {
    final existing = await places.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final initialPlaces = [
      Place(
        id: '',
        name: 'King Faisal Hospital',
        category: 'Hospital',
        address: 'KG 544 St, Kigali',
        contact: '+250 788 123 456',
        description: 'One of the leading hospitals in Kigali providing quality healthcare services.',
        latitude: -1.9536,
        longitude: 30.0906,
        userId: userId,
        timestamp: DateTime.now(),
      ),
      Place(
        id: '',
        name: 'Kigali Public Library',
        category: 'Library',
        address: 'KN 4 Ave, Kigali',
        contact: '+250 788 234 567',
        description: 'Public library with a vast collection of books and digital resources.',
        latitude: -1.9441,
        longitude: 30.0619,
        userId: userId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      Place(
        id: '',
        name: 'Heaven Restaurant',
        category: 'Restaurant',
        address: 'KG 7 Ave, Kigali',
        contact: '+250 788 345 678',
        description: 'Popular restaurant with amazing views of Kigali city.',
        latitude: -1.9500,
        longitude: 30.0600,
        userId: userId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Place(
        id: '',
        name: 'Kigali Genocide Memorial',
        category: 'Tourist Attraction',
        address: 'KG 14 Ave, Gisozi',
        contact: '+250 788 456 789',
        description: 'Memorial site commemorating the 1994 genocide against the Tutsi.',
        latitude: -1.9558,
        longitude: 30.0871,
        userId: userId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      Place(
        id: '',
        name: 'Bourbon Coffee Café',
        category: 'Café',
        address: 'Union Trade Center, Kigali',
        contact: '+250 788 567 890',
        description: 'Premium coffee shop serving authentic Rwandan coffee.',
        latitude: -1.9489,
        longitude: 30.0611,
        userId: userId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ];

    final batch = _db.batch();
    for (final place in initialPlaces) {
      final doc = places.doc();
      batch.set(doc, place.toMap());
    }
    await batch.commit();
  }
}
