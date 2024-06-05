import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/widgets/car_item.dart';
import 'package:marhba_bik/widgets/house_item.dart';
import 'package:marhba_bik/widgets/trip_item.dart';

class DetailedWishlistScreen extends StatelessWidget {
  final List<String> collectionData;
  final String collectionType;

  const DetailedWishlistScreen({
    Key? key,
    required this.collectionData,
    required this.collectionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My ${collectionType.toUpperCase()[0]}${collectionType.substring(1)} Wishlist',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: collectionData.length,
                itemBuilder: (context, index) {
                  final itemId = collectionData[index];
                  Future<dynamic>? futureItem;

                  switch (collectionType) {
                    case 'cars':
                      futureItem = firestoreService.getCarModelById(itemId);
                      break;
                    case 'trips':
                      futureItem = firestoreService.getTripModelById(itemId);
                      break;
                    case 'houses':
                      futureItem = firestoreService.getHouseModelById(itemId);
                      break;
                    default:
                      futureItem = null;
                  }

                  return futureItem == null
                      ? const Center(child: Text('Collection type not found'))
                      : Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: FutureBuilder<dynamic>(
                              future: futureItem,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final item = snapshot.data!;
                                  if (item != null) {
                                    switch (collectionType) {
                                      case 'cars':
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: CarItem(
                                            car: item,
                                            imageHeight: 280,
                                            imageWidth: 320,
                                          ),
                                        );
                                      case 'trips':
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: TripItem(
                                            trip: item,
                                            imageHeight: 280,
                                            imageWidth: 320,
                                          ),
                                        );
                                      case 'houses':
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: HouseItem(
                                            house: item,
                                            imageHeight: 280,
                                            imageWidth: 320,
                                          ),
                                        );
                                      default:
                                        return const Center(
                                          child: Text('Coming Soon'),
                                        );
                                    }
                                  } else {
                                    return const Center(
                                      child: Text('Item not found'),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Error fetching item'));
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
