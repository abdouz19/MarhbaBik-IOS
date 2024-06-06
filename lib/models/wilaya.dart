import 'package:cloud_firestore/cloud_firestore.dart';

class Wilaya {
  final String description;
  final String id;
  final String name;
  final List<String> regions;
  final String imageUrl;

  Wilaya({
    required this.description,
    required this.id,
    required this.name,
    required this.regions,
    required this.imageUrl,
  });

  factory Wilaya.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Wilaya(
      description: data['description'],
      id: data['wilayaID'],
      name: data['name'],
      regions: List<String>.from(data['regions']),
      imageUrl: data['imageUrl'],
    );
  }
}
