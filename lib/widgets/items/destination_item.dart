import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:marhba_bik/screens/traveler/destination_screen.dart';
import 'package:shimmer/shimmer.dart';

class DestinationItem extends StatefulWidget {
  final Destination destination;

  const DestinationItem({super.key, required this.destination});

  @override
  State<DestinationItem> createState() => _DestinationItemState();
}

class _DestinationItemState extends State<DestinationItem> {
  late Destination _destination;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _destination = widget.destination;
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    final firestoreService = FirestoreService();
    final ratings =
        await firestoreService.loadRatingsForDestination(_destination.name);
    setState(() {
      _destination.ratings = ratings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wilayaText = _getWilayaText(_destination.wilaya);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationScreen(
              destination: _destination,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: _destination.thumbnailUrl,
                width: 160,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 160,
                      height: 120,
                      color: Colors.white,
                    ),
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 3),
                  Text(
                    _destination.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    wilayaText,
                    style: const TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 14,
                    ),
                  ),
                  if (!_isLoading)
                    RatingBarIndicator(
                      rating: calculateAverageRating(_destination.ratings),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 18,
                      direction: Axis.horizontal,
                    ),
                  if (_isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double calculateAverageRating(List<int> ratings) {
  if (ratings.isEmpty) return 0;
  final totalRatings = ratings.fold(0, (sum, rating) => sum + rating);
  final averageRating = totalRatings / ratings.length;
  return averageRating;
}

String _getWilayaText(String wilayaName) {
  return "Wilaya de ${_addApostropheIfNecessary(wilayaName)}";
}

String _addApostropheIfNecessary(String regionName) {
  const vowels = ['a', 'e', 'i', 'o', 'u', 'h'];
  if (vowels.contains(regionName[0].toLowerCase())) {
    return "d'$regionName";
  } else {
    return regionName;
  }
}
