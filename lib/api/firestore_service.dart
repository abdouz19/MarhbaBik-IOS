import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('trips').get();
      return querySnapshot.docs.map((doc) => Trip.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching trips: $e");
      return [];
    }
  }

  Future<List<Car>> fetchCars() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cars').get();
      return querySnapshot.docs.map((doc) => Car.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching cars: $e");
      return [];
    }
  }

  Future<List<House>> fetchHouses() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('houses').get();
      return querySnapshot.docs.map((doc) => House.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching houses: $e");
      return [];
    }
  }

  Future<List<Wilaya>> fetchWilayas() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('wilayas').get();
      return querySnapshot.docs.map((doc) => Wilaya.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching wilayas: $e");
      return [];
    }
  }

  Future<List<Destination>> fetchDestinations() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('destinations').get();
      return querySnapshot.docs
          .map((doc) => Destination.fromDocument(doc))
          .toList();
    } catch (e) {
      print("Error fetching destinations: $e");
      return [];
    }
  }

  Future<String> uploadBookingCars({
    required String carID,
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
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('bookings').add({
        'id': carID,
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
    required String houseId,
    required String travelerID,
    required String targetID,
    required String targetType,
    required String bookingStatus,
    required int price,
    required int commission,
    required int totalPrice,
    required int nights,
    required String pickupDate,
    required String returnDate,
    required String paymentMethod,
    required int guests,
  }) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('bookings').add({
        'id': houseId,
        'travelerID': travelerID,
        'targetID': targetID,
        'targetType': targetType,
        'bookingStatus': bookingStatus,
        'price': price,
        'commission': commission,
        'totalPrice': totalPrice,
        'nights': nights,
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
    required String tripId,
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
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('bookings').add({
        'id': tripId,
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

  Future<List<Map<String, dynamic>>> fetchBookingCars(String userID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('targetType', isEqualTo: 'cars')
          .where('targetID', isEqualTo: userID)
          .where('bookingStatus', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> bookings = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String carID = bookingData['id'];

        DocumentSnapshot carSnapshot = await FirebaseFirestore.instance
            .collection('cars')
            .doc(carID)
            .get();

        if (carSnapshot.exists) {
          bookings.add(bookingData);
        }
      }

      return bookings;
    } catch (e) {
      print("Error fetching car bookings: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookingHouses(String userID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('targetType', isEqualTo: 'houses')
          .where('targetID', isEqualTo: userID)
          .where('bookingStatus', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> bookings = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String houseID = bookingData['id'];

        DocumentSnapshot houseSnapshot = await FirebaseFirestore.instance
            .collection('houses')
            .doc(houseID)
            .get();

        if (houseSnapshot.exists) {
          bookings.add(bookingData);
        }
      }

      return bookings;
    } catch (e) {
      print("Error fetching house bookings: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookingTrips(String userID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('targetType', isEqualTo: 'trips')
          .where('targetID', isEqualTo: userID)
          .where('bookingStatus', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> bookings = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String tripID = bookingData['id'];

        DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
            .collection('trips')
            .doc(tripID)
            .get();

        if (tripSnapshot.exists) {
          bookings.add(bookingData);
        }
      }

      return bookings;
    } catch (e) {
      print("Error fetching trip bookings: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserDataById(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .get();

      if (userDataSnapshot.exists) {
        return userDataSnapshot.data();
      } else {
        print("User with ID $userID not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCarById(String carId) async {
    try {
      DocumentSnapshot carSnapshot =
          await FirebaseFirestore.instance.collection('cars').doc(carId).get();

      if (carSnapshot.exists) {
        Map<String, dynamic> carData =
            carSnapshot.data() as Map<String, dynamic>;
        return carData;
      } else {
        print("Car with ID $carId not found");
        return null;
      }
    } catch (e) {
      print("Error fetching car data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTripById(String tripId) async {
    try {
      DocumentSnapshot carSnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .get();

      if (carSnapshot.exists) {
        Map<String, dynamic> tripData =
            carSnapshot.data() as Map<String, dynamic>;
        return tripData;
      } else {
        print("Trip with ID $tripId not found");
        return null;
      }
    } catch (e) {
      print("Error fetching car data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getHouseById(String houseId) async {
    try {
      DocumentSnapshot carSnapshot = await FirebaseFirestore.instance
          .collection('houses')
          .doc(houseId)
          .get();

      if (carSnapshot.exists) {
        Map<String, dynamic> houseData =
            carSnapshot.data() as Map<String, dynamic>;
        return houseData;
      } else {
        print("House with ID $houseId not found");
        return null;
      }
    } catch (e) {
      print("Error fetching car data: $e");
      return null;
    }
  }

  Future<void> updateBookingStatus(String bookingID, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingID)
          .update({
        'bookingStatus': status,
      });
      print('Booking status updated to $status');
    } catch (e) {
      print('Error updating booking status: $e');
    }
  }

  // New methods for fetching bookings by travelerID
  Future<List<Map<String, dynamic>>> fetchCarBookingsByTravelerID(
      String travelerID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('travelerID', isEqualTo: travelerID)
          .where('targetType', isEqualTo: 'cars')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> bookings = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String carID = bookingData['id'];

        DocumentSnapshot carSnapshot = await FirebaseFirestore.instance
            .collection('cars')
            .doc(carID)
            .get();

        if (carSnapshot.exists) {
          bookings.add(bookingData);
        }
      }

      return bookings;
    } catch (e) {
      print("Error fetching car bookings: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchHouseBookingsByTravelerID(
      String travelerID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('travelerID', isEqualTo: travelerID)
          .where('targetType', isEqualTo: 'houses')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> bookings = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String houseID = bookingData['id'];

        DocumentSnapshot houseSnapshot = await FirebaseFirestore.instance
            .collection('houses')
            .doc(houseID)
            .get();

        if (houseSnapshot.exists) {
          bookings.add(bookingData);
        }
      }

      return bookings;
    } catch (e) {
      print("Error fetching house bookings: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTripBookingsByTravelerID(
      String travelerID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('travelerID', isEqualTo: travelerID)
          .where('targetType', isEqualTo: 'trips')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> bookings = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String tripID = bookingData['id'];

        DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
            .collection('trips')
            .doc(tripID)
            .get();

        if (tripSnapshot.exists) {
          bookings.add(bookingData);
        }
      }

      return bookings;
    } catch (e) {
      print("Error fetching trip bookings: $e");
      return [];
    }
  }

  Future<void> deleteBooking(String bookingID) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingID)
        .delete();
  }

  Future<void> cancelBooking(String bookingID) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingID)
          .update({'bookingStatus': 'canceled'});
    } catch (e) {
      // Handle error
      print('Error canceling booking: $e');
    }
  }

  Future<void> addToWishlist(String itemId, String collection) async {
    // Get the current user ID
    String currentUserId = await getCurrentUserId();

    // Check if wishlist document exists for the user
    DocumentReference wishlistRef =
        FirebaseFirestore.instance.collection('wishlists').doc(currentUserId);
    DocumentSnapshot wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.exists) {
      // Construct the field name dynamically within the update data
      String fieldToUpdate = '${collection}Ids';
      Map<String, dynamic> updateData = {
        fieldToUpdate: FieldValue.arrayUnion([itemId])
      };

      await wishlistRef.update(updateData);
    } else {
      // Create a new wishlist document with an empty array for the collection
      String fieldToUpdate =
          '${collection}Ids'; // Define fieldToUpdate within the else block
      await wishlistRef.set({
        fieldToUpdate: [], // Initialize with an empty array
        'userId': currentUserId, // Add the user ID field
      });

      // Then, add the item to the newly created array using another call to addToWishlist
      await addToWishlist(
          itemId, collection); // Recursive call to add the first item
    }
  }

  Future<void> removeFromWishlist(String itemId, String collection) async {
    // Get the current user ID
    String currentUserId = await getCurrentUserId();

    // Check if wishlist document exists for the user
    DocumentReference wishlistRef =
        FirebaseFirestore.instance.collection('wishlists').doc(currentUserId);
    DocumentSnapshot wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.exists) {
      // Wishlist document exists, update the appropriate array field
      String fieldToUpdate =
          '${collection}Ids'; // Construct field name dynamically
      List<String> itemIds =
          wishlistSnapshot.get(fieldToUpdate)?.cast<String>() ?? [];
      if (itemIds.contains(itemId)) {
        itemIds.remove(itemId);
        await wishlistRef.update({fieldToUpdate: itemIds});
      }
      // Not present, handle it if needed (e.g., show a toast)
    } else {
      // No wishlist document, nothing to remove
    }
  }

  Future<bool> isItemFavorited(String itemId, String collection) async {
    String currentUserId = await getCurrentUserId();
    DocumentReference wishlistRef =
        FirebaseFirestore.instance.collection('wishlists').doc(currentUserId);
    DocumentSnapshot wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.exists) {
      String fieldToCheck =
          '${collection}Ids'; // Construct field name dynamically
      List<String> itemIds =
          wishlistSnapshot.get(fieldToCheck)?.cast<String>() ?? [];
      return itemIds.contains(itemId);
    } else {
      return false; // No wishlist or item not present
    }
  }

  // Implement this function to retrieve the current user ID (e.g., from Firebase Authentication)
  Future<String> getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> saveSubscription(String userId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('subscriptions').doc(userId).set(data);
    } catch (e) {
      throw Exception('Failed to save subscription: $e');
    }
  }
}
