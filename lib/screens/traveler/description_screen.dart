import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:shimmer/shimmer.dart';

class DestinationScreen extends StatelessWidget {
  final Destination destination;

  const DestinationScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: destination.thumbnailUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.white,
                    ),
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 16),
              Text(
                destination.name,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Wilaya: ${destination.wilaya}',
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Region: ${destination.region}',
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: calculateAverageRating(destination.ratings),
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
              const SizedBox(height: 16),
              Text(
                destination.description,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Other Pictures',
                style: TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: destination.otherPicturesUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CachedNetworkImage(
                        imageUrl: destination.otherPicturesUrls[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
