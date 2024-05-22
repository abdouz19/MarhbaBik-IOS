import 'package:cloud_firestore/cloud_firestore.dart';

enum Region { Est, West, Center, Kabylie, Sahara, Aures }

enum DestinationType { Natural, Cultural, Coastal, Modern, Arcade }

class Wilaya {
  final String description;
  final String id;
  final String name;
  final List<String> regions;
  final List<String> types;
  final String imageUrl;

  Wilaya({
    required this.description,
    required this.id,
    required this.name,
    required this.regions,
    required this.types,
    required this.imageUrl,
  });

  factory Wilaya.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Wilaya(
      description: data['description'],
      id: data['id'],
      name: data['name'],
      regions: List<String>.from(data['regions']),
      types: List<String>.from(data['types']),
      imageUrl: data['imageUrl'],
    );
  }

  Future<List<Wilaya>> fetchWilayas() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('wilayas').get();
    return querySnapshot.docs.map((doc) => Wilaya.fromDocument(doc)).toList();
  } catch (e) {
    print("Error fetching wilayas: $e");
    return [];
  }
}

}
