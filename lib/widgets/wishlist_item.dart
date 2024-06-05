import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/screens/traveler/detailed_wishlist.dart'; // Import your detailed wishlist screen

class CollectionCard extends StatelessWidget {
  final String collectionName;
  final List<String> itemIds;

  static const Map<String, String> collectionNameMapping = {
    'carIds': 'Cars',
    'tripIds': 'Trips',
    'houseIds': 'Houses',
    'destinationIds': 'Destinations',
    'wilayaIds': 'Wilayas',
  };

  const CollectionCard({
    super.key,
    required this.collectionName,
    required this.itemIds,
  });

  @override
  Widget build(BuildContext context) {
    final formattedCollectionName =
        collectionNameMapping[collectionName] ?? collectionName;

    Future<Map<String, dynamic>?> getItemDetails(String itemId) async {
      switch (collectionName) {
        case 'carIds':
          return await FirestoreService().getCarById(itemId);
        case 'tripIds':
          return await FirestoreService().getTripById(itemId);
        case 'houseIds':
          return await FirestoreService().getHouseById(itemId);
        case 'destinationIds':
          return await FirestoreService().getDestinationById(itemId);
        case 'wilayaIds':
          return await FirestoreService().getWilayaById(itemId);
        default:
          return null;
      }
    }

    String getCollectionType() {
      switch (collectionName) {
        case 'carIds':
          return 'cars';
        case 'tripIds':
          return 'trips';
        case 'houseIds':
          return 'houses';
        case 'destinationIds':
          return 'destinations';
        case 'wilayaIds':
          return 'wilayas';
        default:
          return 'unknown';
      }
    }

    final collectionType = getCollectionType();
    return FutureBuilder<Map<String, dynamic>?>(
      future: itemIds.isNotEmpty ? getItemDetails(itemIds[0]) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final itemData = snapshot.data!;
          final imageUrl = itemData['images']?[0];

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedWishlistScreen(
                  collectionData: itemIds,
                  collectionType: collectionType,
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: itemIds.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 150,
                            height: 150.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox(
                            width: 150.0,
                            height: 150.0,
                            child: Center(child: Text('No image available')),
                          ),
                  ),
                ),
                Text(
                  formattedCollectionName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '${itemIds.length} saved',
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching item'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
