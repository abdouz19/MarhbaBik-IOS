import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/favorite_icon.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/screens/traveler/wilaya_screen.dart';
import 'package:shimmer/shimmer.dart';

class SecondWilayaItem extends StatefulWidget {
  const SecondWilayaItem({
    super.key,
    required this.wilaya,
    this.imageHeight,
    this.imageWidth,
  });

  final Wilaya wilaya;
  final double? imageHeight;
  final double? imageWidth;

  @override
  State<SecondWilayaItem> createState() => _WilayaItemState();
}

class _WilayaItemState extends State<SecondWilayaItem> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    String wilayaId = widget.wilaya.id;
    bool isFavorited =
        await FirestoreService().isItemFavorited(wilayaId, "wilaya");
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = widget.imageHeight ?? 200;
    double imageWidth = widget.imageWidth ?? 250;
    String imageUrl = widget.wilaya.imageUrl;
    String title = widget.wilaya.title;
    int maxLength = 33;

    String displayedTitle = title.length > maxLength
        ? "${title.substring(0, maxLength - 3)}..."
        : title;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WilayaScreen(wilaya: widget.wilaya),
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
                        imageUrl: imageUrl,
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
                                .addToWishlist(widget.wilaya.id, "wilaya");
                          } else {
                            await FirestoreService()
                                .removeFromWishlist(widget.wilaya.id, "wilaya");
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
                widget.wilaya.regions[0],
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
