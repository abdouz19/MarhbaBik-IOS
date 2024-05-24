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
      print("Error fetching trips: $e");
      return [];
    }
  }

  Future<List<House>> fetchHouses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('houses').get();
      return querySnapshot.docs.map((doc) => House.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching trips: $e");
      return [];
    }
  }


  Future<List<Wilaya>> fetchWilayas() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('wilayas').get();
      return querySnapshot.docs.map((doc) => Wilaya.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching trips: $e");
      return [];
    }
  }

  Future<List<Destination>> fetchDestinations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('destinations').get();
      return querySnapshot.docs.map((doc) => Destination.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching trips: $e");
      return [];
    }
  }
  
}
