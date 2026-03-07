import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/place_model.dart';

class FirestoreService {
  final List<Place> _localPlaces = [];
  final StreamController<List<Place>> _localPlacesController =
      StreamController<List<Place>>.broadcast();

  FirestoreService() {
    // Add sample data for offline/web demo
    _localPlaces.addAll([
      Place(
        id: '1',
        name: 'King Faisal Hospital',
        category: 'Hospital',
        address: 'KG 544 St, Kigali',
        contact: '+250 788 123 456',
        description: 'One of the leading hospitals in Kigali providing quality healthcare services.',
        latitude: -1.9536,
        longitude: 30.0906,
        userId: 'demo-user',
        timestamp: DateTime.now(),
      ),
      Place(
        id: '2',
        name: 'Kigali Public Library',
        category: 'Library',
        address: 'KN 4 Ave, Kigali',
        contact: '+250 788 234 567',
        description: 'Public library with a vast collection of books and digital resources.',
        latitude: -1.9441,
        longitude: 30.0619,
        userId: 'demo-user',
        timestamp: DateTime.now(),
      ),
      Place(
        id: '3',
        name: 'Heaven Restaurant',
        category: 'Restaurant',
        address: 'KG 7 Ave, Kigali',
        contact: '+250 788 345 678',
        description: 'Popular restaurant with amazing views of Kigali city.',
        latitude: -1.9500,
        longitude: 30.0600,
        userId: 'demo-user',
        timestamp: DateTime.now(),
      ),
      Place(
        id: '4',
        name: 'Kigali Genocide Memorial',
        category: 'Tourist Attraction',
        address: 'KG 14 Ave, Gisozi',
        contact: '+250 788 456 789',
        description: 'Memorial site commemorating the 1994 genocide against the Tutsi.',
        latitude: -1.9558,
        longitude: 30.0871,
        userId: 'demo-user',
        timestamp: DateTime.now(),
      ),
      Place(
        id: '5',
        name: 'Bourbon Coffee Café',
        category: 'Café',
        address: 'Union Trade Center, Kigali',
        contact: '+250 788 567 890',
        description: 'Premium coffee shop serving authentic Rwandan coffee.',
        latitude: -1.9489,
        longitude: 30.0611,
        userId: 'demo-user',
        timestamp: DateTime.now(),
      ),
    ]);
    _localPlacesController.add(List<Place>.from(_localPlaces));
  }

  FirebaseFirestore? get _db =>
      Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>>? get places =>
      _db?.collection("places");

  Future createPlace(Place place) async {
    if (places != null) {
      await places!.add(place.toMap());
      return;
    }

    final localPlace = Place(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: place.name,
      category: place.category,
      address: place.address,
      contact: place.contact,
      description: place.description,
      latitude: place.latitude,
      longitude: place.longitude,
      userId: place.userId,
      timestamp: place.timestamp,
    );

    _localPlaces.add(localPlace);
    _localPlacesController.add(List<Place>.from(_localPlaces));
  }

  Future updatePlace(Place place) async {
    if (places != null) {
      await places!.doc(place.id).update(place.toMap());
      return;
    }

    final index = _localPlaces.indexWhere(
      (existing) => existing.id == place.id,
    );
    if (index != -1) {
      _localPlaces[index] = place;
      _localPlacesController.add(List<Place>.from(_localPlaces));
    }
  }

  Future deletePlace(String id) async {
    if (places != null) {
      await places!.doc(id).delete();
      return;
    }

    _localPlaces.removeWhere((place) => place.id == id);
    _localPlacesController.add(List<Place>.from(_localPlaces));
  }

  Stream<List<Place>> getPlaces() {
    if (places == null) {
      return _localPlacesController.stream;
    }

    return places!.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Place.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
