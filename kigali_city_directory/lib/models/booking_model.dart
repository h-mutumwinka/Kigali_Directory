import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String id;
  String placeId;
  String placeName;
  String userId;
  String userEmail;
  DateTime bookingDate;
  String timeSlot;
  int numberOfPeople;
  String status; // pending, confirmed, cancelled
  String specialRequests;
  DateTime timestamp;

  Booking({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.userId,
    required this.userEmail,
    required this.bookingDate,
    required this.timeSlot,
    required this.numberOfPeople,
    required this.status,
    required this.specialRequests,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'placeName': placeName,
      'userId': userId,
      'userEmail': userEmail,
      'bookingDate': bookingDate,
      'timeSlot': timeSlot,
      'numberOfPeople': numberOfPeople,
      'status': status,
      'specialRequests': specialRequests,
      'timestamp': timestamp,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    final rawBookingDate = map['bookingDate'];
    final bookingDate = rawBookingDate is Timestamp
        ? rawBookingDate.toDate()
        : rawBookingDate is DateTime
            ? rawBookingDate
            : DateTime.now();

    final rawTimestamp = map['timestamp'];
    final timestamp = rawTimestamp is Timestamp
        ? rawTimestamp.toDate()
        : rawTimestamp is DateTime
            ? rawTimestamp
            : DateTime.now();

    return Booking(
      id: id,
      placeId: map['placeId'] ?? '',
      placeName: map['placeName'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      bookingDate: bookingDate,
      timeSlot: map['timeSlot'] ?? '',
      numberOfPeople: (map['numberOfPeople'] as num?)?.toInt() ?? 1,
      status: map['status'] ?? 'pending',
      specialRequests: map['specialRequests'] ?? '',
      timestamp: timestamp,
    );
  }
}
