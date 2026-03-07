import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  String id;
  String name;
  String category;
  String address;
  String contact;
  String description;
  double latitude;
  double longitude;
  String userId;
  DateTime timestamp;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contact,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'contact': contact,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
      'timestamp': timestamp,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map, String id) {
    final rawTimestamp = map['timestamp'];
    final timestamp = rawTimestamp is Timestamp
        ? rawTimestamp.toDate()
        : rawTimestamp is DateTime
        ? rawTimestamp
        : DateTime.now();

    return Place(
      id: id,
      name: map['name'],
      category: map['category'],
      address: map['address'],
      contact: map['contact'],
      description: map['description'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      userId: map['userId'],
      timestamp: timestamp,
    );
  }
}
