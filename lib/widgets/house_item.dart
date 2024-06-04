import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/favorite_icon.dart';
import 'package:marhba_bik/models/house.dart';
import 'package:marhba_bik/screens/traveler/detailed_screens/house_details.dart';

class HouseItem extends StatefulWidget {
  const HouseItem({super.key, required this.house});

  final House house;

  @override
  State<HouseItem> createState() => _HouseItemState();
}

class _HouseItemState extends State<HouseItem> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    // Check if house is already favorited on initial load
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    String houseId = widget.house.id;
    bool isFavorited =
        await FirestoreService().isItemFavorited(houseId, "house");
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.house.images;
    String title = "${widget.house.wilaya}, ${widget.house.placeType}";
    int maxLength = 33; // Adjust this value as needed

    String displayedTitle;
    if (title.length > maxLength) {
      displayedTitle =
          title.substring(0, maxLength - 3) + "..."; // Truncate with ellipsis
    } else {
      displayedTitle = title; // No truncation needed
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HouseDetailedScreen(house: widget.house),
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
                        icon: HeartIcon(isFavorited: _isFavorited),
                        onPressed: () async {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                          if (_isFavorited) {
                            await FirestoreService()
                                .addToWishlist(widget.house.id, "house");
                          } else {
                            await FirestoreService()
                                .removeFromWishlist(widget.house.id, "house");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
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
