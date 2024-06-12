import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String category;
  final String name;
  final String title;
  final List<String> otherPicturesUrls;
  final String region;
  final String thumbnailUrl;
  final String wilaya;
  final String description;
  List<int> ratings;

  Destination({
    this.ratings = const [0],
    required this.category,
    required this.title,
    required this.description,
    required this.name,
    required this.otherPicturesUrls,
    required this.region,
    required this.thumbnailUrl,
    required this.wilaya,
  });

  factory Destination.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Destination(
      title: data['title'],
      ratings: [0],
      description: data['description'],
      category: data['category'],
      name: data['name'],
      otherPicturesUrls: List<String>.from(data['otherPicturesUrls']),
      region: data['region'],
      thumbnailUrl: data['thumbnailUrl'],
      wilaya: data['wilaya'],
    );
  }
}
