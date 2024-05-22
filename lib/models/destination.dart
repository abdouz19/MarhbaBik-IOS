import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String category;
  final String name;
  final List<String> otherPicturesUrls;
  final String region;
  final String thumbnailUrl;
  final String wilaya;

  Destination({
    required this.category,
    required this.name,
    required this.otherPicturesUrls,
    required this.region,
    required this.thumbnailUrl,
    required this.wilaya,
  });

  factory Destination.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Destination(
      category: data['category'],
      name: data['name'],
      otherPicturesUrls: List<String>.from(data['otherPicturesUrls']),
      region: data['region'],
      thumbnailUrl: data['thumbnailUrl'],
      wilaya: data['wilaya'],
    );
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

}
