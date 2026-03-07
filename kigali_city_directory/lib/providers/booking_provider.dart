import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  Stream<List<Booking>> getBookings() {
    return _bookingService.getBookings();
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    return _bookingService.getUserBookings(userId);
  }

  Future addBooking(Booking booking) async {
    await _bookingService.createBooking(booking);
    notifyListeners();
  }

  Future updateBooking(Booking booking) async {
    await _bookingService.updateBooking(booking);
    notifyListeners();
  }

  Future deleteBooking(String id) async {
    await _bookingService.deleteBooking(id);
    notifyListeners();
  }
}
