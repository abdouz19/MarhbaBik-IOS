import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final List<String> activities;
  final String agencyId;
  final String agencyName;
  final String agencyProfilePicture;
  final int capacity;
  final String description;
  final Timestamp endDate;
  final String id;
  final List<String> images;
  final String price;
  final Timestamp startDate;
  final String title;
  final Timestamp uploadedAt;
  final String wilaya;

  Trip({
    required this.activities,
    required this.agencyId,
    required this.agencyName,
    required this.agencyProfilePicture,
    required this.capacity,
    required this.description,
    required this.endDate,
    required this.id,
    required this.images,
    required this.price,
    required this.startDate,
    required this.title,
    required this.uploadedAt,
    required this.wilaya,
  });

  factory Trip.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Trip(
      activities: List<String>.from(data['activities']),
      agencyId: data['agencyId'],
      agencyName: data['agencyName'],
      agencyProfilePicture: data['agencyProfilePicture'],
      capacity: data['capacity'],
      description: data['description'],
      endDate: data['endDate'],
      id: data['id'],
      images: List<String>.from(data['images']),
      price: data['price'],
      startDate: data['startDate'],
      title: data['title'],
      uploadedAt: data['uploadedAt'],
      wilaya: data['wilaya'],
    );
  }

}


