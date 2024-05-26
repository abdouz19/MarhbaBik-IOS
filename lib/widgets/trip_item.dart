import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/screens/traveler/detailed_screens/trip_details.dart';

class TripItem extends StatefulWidget {
  const TripItem({Key? key, required this.trip}) : super(key: key);

  final Trip trip;

  @override
  State<TripItem> createState() => _TripItemState();
}

class _TripItemState extends State<TripItem> {
  @override
  Widget build(BuildContext context) {
    List<String> images = widget.trip.images;
    //String title = widget.trip.title;
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
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: images[0],
                        width: 250,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Handle heart button click
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Memory de martyr, Algiers',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Cultural',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
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
