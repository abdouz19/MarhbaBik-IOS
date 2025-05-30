import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String brand;
  final int capacity;
  final String description;
  final String id;
  final List<String> images;
  final String model;
  final String ownerFirstName;
  final String ownerId;
  final String ownerLastName;
  final String ownerProfilePicture;
  final String price;
  final String title;
  final Timestamp uploadedAt;
  final String wilaya;

  Car({
    required this.brand,
    required this.capacity,
    required this.description,
    required this.id,
    required this.images,
    required this.model,
    required this.ownerFirstName,
    required this.ownerId,
    required this.ownerLastName,
    required this.ownerProfilePicture,
    required this.price,
    required this.title,
    required this.uploadedAt,
    required this.wilaya,
  });

  factory Car.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Car(
      brand: data['brand'] ?? '',
      capacity: data['capacity'] ?? 0,
      description: data['description'] ?? '',
      id: data['id'] ?? '',
      images: data['images'] != null ? List<String>.from(data['images']) : [],
      model: data['model'] ?? '',
      ownerFirstName: data['ownerFirstName'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerLastName: data['ownerLastName'] ?? '',
      ownerProfilePicture: data['ownerProfilePicture'] ?? '',
      price: data['price'] ?? '',
      title: data['title'] ?? '',
      uploadedAt: data['uploadedAt'] ?? Timestamp.now(),
      wilaya: data['wilaya'] ?? '',
    );
  }
}
