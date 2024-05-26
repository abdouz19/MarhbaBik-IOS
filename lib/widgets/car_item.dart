import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/models/car.dart';
import 'package:marhba_bik/screens/traveler/detailed_screens/car_details.dart';

class CarItem extends StatefulWidget {
  const CarItem({Key? key, required this.car}) : super(key: key);

  final Car car;

  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  @override
  Widget build(BuildContext context) {
    List<String> images = widget.car.images;
    //String title = widget.trip.title;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailedScreen(car: widget.car),
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
                          return const Center(
                              child: CircularProgressIndicator());
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
                'Toyota Corolla, Algiers',
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
