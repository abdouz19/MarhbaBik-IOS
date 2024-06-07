import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String category;
  final String name;
  final List<String> otherPicturesUrls;
  final String region;
  final String thumbnailUrl;
  final String wilaya;
  final String description;
  List<int> ratings;

  Destination({
    this.ratings = const [0],
    required this.category,
    required this.description,
    required this.name,
    required this.otherPicturesUrls,
    required this.region,
    required this.thumbnailUrl,
    required this.wilaya,
  });

  factory Destination.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ratingsData = data['ratings'];

    List<int> ratings;
    if (ratingsData is List<dynamic>) {
      ratings = List<int>.from(ratingsData.cast<int>());
    } else {
      // If 'ratings' field is missing or not an array, assign default value
      ratings = [0];
    }

    return Destination(
      ratings: ratings,
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
