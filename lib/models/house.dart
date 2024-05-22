import 'package:cloud_firestore/cloud_firestore.dart';

class House {
  final String address;
  final int capacity;
  final String description;
  final String id;
  final List<String> images;
  final String ownerFirstName;
  final String ownerId;
  final String ownerLastName;
  final String ownerProfilePicture;
  final String placeType;
  final String price;
  final String title;
  final Timestamp uploadedAt;
  final String wilaya;

  House({
    required this.address,
    required this.capacity,
    required this.description,
    required this.id,
    required this.images,
    required this.ownerFirstName,
    required this.ownerId,
    required this.ownerLastName,
    required this.ownerProfilePicture,
    required this.placeType,
    required this.price,
    required this.title,
    required this.uploadedAt,
    required this.wilaya,
  });

  factory House.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return House(
      address: data['address'],
      capacity: data['capacity'],
      description: data['description'],
      id: data['id'],
      images: List<String>.from(data['images']),
      ownerFirstName: data['ownerFirstName'],
      ownerId: data['ownerId'],
      ownerLastName: data['ownerLastName'],
      ownerProfilePicture: data['ownerProfilePicture'],
      placeType: data['placeType'],
      price: data['price'],
      title: data['title'],
      uploadedAt: data['uploadedAt'],
      wilaya: data['wilaya'],
    );
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

}
