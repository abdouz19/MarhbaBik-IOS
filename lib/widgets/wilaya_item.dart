import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/models/wilaya.dart';

class WilayaItem extends StatelessWidget {
  final Wilaya wilaya;

  const WilayaItem({super.key, required this.wilaya});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Text(
                wilaya.name,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                wilaya.description,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
