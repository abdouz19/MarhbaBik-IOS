import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/screens/traveler/wilaya_screen.dart';
import 'package:shimmer/shimmer.dart';

class WilayaItem extends StatelessWidget {
  final Wilaya wilaya;

  const WilayaItem({super.key, required this.wilaya});

  @override
  Widget build(BuildContext context) {
    final regionText = _getRegionText(wilaya.regions);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WilayaScreen(wilaya: wilaya)),
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
                imageUrl: wilaya.imageUrl,
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
                    wilaya.name,
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
                    regionText,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 65, 65, 65),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRegionText(List<String> regions) {
    if (regions.isEmpty) {
      return 'Pas de région';
    }
    String firstRegion = _addApostropheIfNecessary(regions.first);
    String lastRegion = _addApostropheIfNecessary(regions.last);

    if (regions.length == 1) {
      return 'Royaume de $firstRegion';
    } else {
      return 'Située entre les régions de $firstRegion et $lastRegion';
    }
  }

  String _addApostropheIfNecessary(String regionName) {
    const vowels = ['a', 'e', 'i', 'o', 'u', 'h'];
    if (vowels.contains(regionName[0].toLowerCase())) {
      return "l'$regionName";
    } else {
      return regionName;
    }
  }
}
