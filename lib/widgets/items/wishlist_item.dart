import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/screens/traveler/detailed_wishlist.dart';
import 'package:shimmer/shimmer.dart';

class CollectionCard extends StatelessWidget {
  final String collectionName;
  final List<String> itemIds;

  static const Map<String, String> collectionNameMapping = {
    'carIds': 'Voitures',
    'tripIds': 'Voyages',
    'houseIds': 'Maisons',
    'destinationIds': 'Déstinations',
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
          late final String imageUrl;

          switch (collectionName) {
            case 'carIds':
            case 'tripIds':
            case 'houseIds':
              imageUrl = itemData['images']?[0] ?? '';
              break;
            case 'destinationIds':
              imageUrl = itemData['thumbnailUrl'] ?? '';
              break;
            case 'wilayaIds':
              imageUrl = itemData['imageUrl'] ?? '';
              break;
            default:
              imageUrl = '';
          }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: itemIds.isNotEmpty && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: 150.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 7, top: 3),
                  child: Text(
                    formattedCollectionName,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '${itemIds.length} enregistrés',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xff8E8B8B),
                      fontWeight: FontWeight.w300,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching item'));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 10,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 8,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
