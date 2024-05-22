import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marhba_bik/models/trip.dart';

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
}
