import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marhba_bik/models/car.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:marhba_bik/models/house.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/models/wilaya.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  Future<List<Trip>> fetchTrips() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('trips').get();
      return querySnapshot.docs.map((doc) => Trip.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching trips: $e");
      return [];
    }
  }

  Future<List<Car>> fetchCars() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('cars').get();
      return querySnapshot.docs.map((doc) => Car.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching cars: $e");
      return [];
    }
  }

  Future<List<House>> fetchHouses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('houses').get();
      return querySnapshot.docs.map((doc) => House.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching houses: $e");
      return [];
    }
  }


  Future<List<Wilaya>> fetchWilayas() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('wilayas').get();
      return querySnapshot.docs.map((doc) => Wilaya.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching wilayas: $e");
      return [];
    }
  }

  Future<List<Destination>> fetchDestinations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('destinations').get();
      return querySnapshot.docs.map((doc) => Destination.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching destinations: $e");
      return [];
    }
  }

  Future<String> uploadBookingCars({
  required String travelerID,
  required String targetID,
  required String targetType,
  required String bookingStatus,
  required int price,
  required int commission,
  required int totalPrice,
  required int days,
  required String pickupDate,
  required String returnDate,
  required String paymentMethod,
}) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('bookings').add({
      'travelerID': travelerID,
      'targetID': targetID,
      'targetType': targetType,
      'bookingStatus': bookingStatus,
      'price': price,
      'commission': commission,
      'totalPrice': totalPrice,
      'days': days,
      'pickupDate': pickupDate,
      'returnDate': returnDate,
      'paymentMethod': paymentMethod,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("Booking uploaded successfully with ID: ${docRef.id}");
    return docRef.id;
  } catch (e) {
    print("Error uploading booking: $e");
    return '';
  }
}

  Future<String> uploadBookingHouses({
  required String travelerID,
  required String targetID,
  required String targetType,
  required String bookingStatus,
  required int price,
  required int commission,
  required int totalPrice,
  required int days,
  required String pickupDate,
  required String returnDate,
  required String paymentMethod,
  required int guests,
}) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('bookings').add({
      'travelerID': travelerID,
      'targetID': targetID,
      'targetType': targetType,
      'bookingStatus': bookingStatus,
      'price': price,
      'commission': commission,
      'totalPrice': totalPrice,
      'days': days,
      'guests': guests,
      'pickupDate': pickupDate,
      'returnDate': returnDate,
      'paymentMethod': paymentMethod,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("Booking uploaded successfully with ID: ${docRef.id}");
    return docRef.id;
  } catch (e) {
    print("Error uploading booking: $e");
    return '';
  }
}


Future<String> uploadBookingTrips({
  required String travelerID,
  required String targetID,
  required String targetType,
  required String bookingStatus,
  required int price,
  required int commission,
  required int totalPrice,
  required int people,
  required String paymentMethod,
}) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('bookings').add({
      'travelerID': travelerID,
      'targetID': targetID,
      'targetType': targetType,
      'bookingStatus': bookingStatus,
      'price': price,
      'commission': commission,
      'totalPrice': totalPrice,
      'people': people,
      'paymentMethod': paymentMethod,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("Booking uploaded successfully with ID: ${docRef.id}");
    return docRef.id;
  } catch (e) {
    print("Error uploading booking: $e");
    return '';
  }
}


}
