import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WilayaItem extends StatelessWidget {
  const WilayaItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: 'assets/images/explore_top.jpg',
            width: 160,
            height: 120,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 3),
            Text(
              'Skikda',
              style: TextStyle(
                color: Color(0xff001939),
                fontWeight: FontWeight.bold,
                fontFamily: 'KastelovAxiforma',
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'East Algeria',
              style: TextStyle(
                color: Color(0xff001939),
                fontWeight: FontWeight.w400,
                fontFamily: 'KastelovAxiforma',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

