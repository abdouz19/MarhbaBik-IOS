import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/widgets/wishlist_item.dart';

class WishlistTraveler extends StatefulWidget {
  const WishlistTraveler({super.key});

  @override
  State<WishlistTraveler> createState() => _WishlistTravelerState();
}

class _WishlistTravelerState extends State<WishlistTraveler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My wishlist'),
      ),
      body: FutureBuilder<Map<String, List<String>>>(
        future: FirestoreService()
            .getWishlistData(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final wishlistData = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: SingleChildScrollView(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final collectionName = wishlistData.keys.elementAt(index);
                    final itemIds = wishlistData[collectionName] ?? [];
                    return CollectionCard(
                      collectionName: collectionName,
                      itemIds: itemIds,
                    );
                  },
                  itemCount: wishlistData.length,
                  shrinkWrap: true,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
