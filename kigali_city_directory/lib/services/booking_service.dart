import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/booking_model.dart';

class BookingService {
  final List<Booking> _localBookings = [];
  final StreamController<List<Booking>> _localBookingsController =
      StreamController<List<Booking>>.broadcast();

  BookingService() {
    _localBookingsController.add([]);
  }

  FirebaseFirestore? get _db =>
      Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>>? get bookings =>
      _db?.collection("bookings");

  Future createBooking(Booking booking) async {
    if (bookings != null) {
      await bookings!.add(booking.toMap());
      return;
    }

    final localBooking = Booking(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      placeId: booking.placeId,
      placeName: booking.placeName,
      userId: booking.userId,
      userEmail: booking.userEmail,
      bookingDate: booking.bookingDate,
      timeSlot: booking.timeSlot,
      numberOfPeople: booking.numberOfPeople,
      status: booking.status,
      specialRequests: booking.specialRequests,
      timestamp: booking.timestamp,
    );

    _localBookings.add(localBooking);
    _localBookingsController.add(List<Booking>.from(_localBookings));
  }

  Future updateBooking(Booking booking) async {
    if (bookings != null) {
      await bookings!.doc(booking.id).update(booking.toMap());
      return;
    }

    final index = _localBookings.indexWhere(
      (existing) => existing.id == booking.id,
    );
    if (index != -1) {
      _localBookings[index] = booking;
      _localBookingsController.add(List<Booking>.from(_localBookings));
    }
  }

  Future deleteBooking(String id) async {
    if (bookings != null) {
      await bookings!.doc(id).delete();
      return;
    }

    _localBookings.removeWhere((booking) => booking.id == id);
    _localBookingsController.add(List<Booking>.from(_localBookings));
  }

  Stream<List<Booking>> getBookings() {
    if (bookings == null) {
      return _localBookingsController.stream;
    }

    return bookings!.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    return getBookings().map((bookings) {
      return bookings.where((booking) => booking.userId == userId).toList();
    });
  }
}
