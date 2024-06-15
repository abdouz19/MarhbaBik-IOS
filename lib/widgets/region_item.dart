import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/screens/traveler/region_screen.dart';
import 'package:shimmer/shimmer.dart';

class RegionItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const RegionItem({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegionScreen(
                    regionName: name,
                  )),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 160,
                    height: 160,
                    color: Colors.white,
                  ),
                );
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Text(
              _capitalizeFirstLetter(name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'KastelovAxiforma',
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
