import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/favorite_icon.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/screens/traveler/detailed_screens/trip_details.dart';
import 'package:shimmer/shimmer.dart';

class TripItem extends StatefulWidget {
  const TripItem({
    super.key,
    required this.trip,
    this.imageHeight,
    this.imageWidth,
  });

  final Trip trip;
  final double? imageHeight;
  final double? imageWidth;

  @override
  State<TripItem> createState() => _TripItemState();
}

class _TripItemState extends State<TripItem> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    String tripId = widget.trip.id;

    bool isFavorited = await FirestoreService().isItemFavorited(tripId, "trip");
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.trip.images;
    String title = "Trip to ${widget.trip.wilaya}";
    int maxLength = 33;

    String displayedTitle = title.length > maxLength
        ? "${title.substring(0, maxLength - 3)}..."
        : title;

    double imageHeight = widget.imageHeight ?? 200;
    double imageWidth = widget.imageWidth ?? 250;
    Timestamp startDate = widget.trip.startDate;
    Timestamp endDate = widget.trip.endDate;

    // Convert Timestamp to DateTime
    DateTime startDateTime = startDate.toDate();
    DateTime endDateTime = endDate.toDate();

    // Format the dates
    String formattedStartDate = DateFormat('d MMM').format(startDateTime);
    String formattedEndDate = DateFormat('d MMM').format(endDateTime);

    // Combined date range string
    String dateRange = '$formattedStartDate - $formattedEndDate';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailedScreen(trip: widget.trip),
          ),
        );
      },
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: images[0],
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: imageWidth,
                              height: imageHeight,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: HeartIcon(isFavorited: _isFavorited),
                        onPressed: () async {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                          if (_isFavorited) {
                            await FirestoreService()
                                .addToWishlist(widget.trip.id, "trip");
                          } else {
                            await FirestoreService()
                                .removeFromWishlist(widget.trip.id, "trip");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                displayedTitle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                dateRange,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
