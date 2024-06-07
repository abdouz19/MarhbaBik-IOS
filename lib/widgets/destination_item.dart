import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:marhba_bik/screens/traveler/destination_screen.dart';
import 'package:shimmer/shimmer.dart';

class DestinationItem extends StatelessWidget {
  final Destination destination;

  const DestinationItem({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DestinationScreen(
                destination: destination,
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: destination.thumbnailUrl,
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
                    destination.name,
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
                    'Wilaya of ${destination.wilaya}',
                    style: const TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 14,
                    ),
                  ),
                  if (destination.ratings.isNotEmpty)
                    RatingBar.builder(
                      initialRating:
                          calculateAverageRating(destination.ratings),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 18,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
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
  final totalRatings = ratings.fold(0, (sum, rating) => sum + rating);
  final averageRating = totalRatings / ratings.length;
  return averageRating;
}
