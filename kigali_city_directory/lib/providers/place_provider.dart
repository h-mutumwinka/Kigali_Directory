import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/firestore_service.dart';

class PlaceProvider extends ChangeNotifier {

  final FirestoreService _firestore = FirestoreService();

  List<Place> places = [];

  Stream<List<Place>> getPlaces() {
    return _firestore.getPlaces();
  }

  Future addPlace(Place place) async {
    await _firestore.createPlace(place);
  }

  Future updatePlace(Place place) async {
    await _firestore.updatePlace(place);
  }

  Future deletePlace(String id) async {
    await _firestore.deletePlace(id);
  }

  Future seedData(String userId) async {
    await _firestore.seedInitialData(userId);
  }

}