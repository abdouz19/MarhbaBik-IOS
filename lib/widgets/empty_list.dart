import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    // Defining the image and text for each type
    final Map<String, Map<String, String>> typeData = {
      'wishlist': {
        'image': 'assets/images/wishlist_illustration.png',
        'text': 'No items in your wishlist',
      },
      'car': {
        'image': 'assets/images/car_illustration.png',
        'text': 'No cars in this destination',
      },
      'house': {
        'image': 'assets/images/house_illustration.png',
        'text': 'No houses in this destination',
      },
      'trip': {
        'image': 'assets/images/trip_illustration.png',
        'text': 'No trips in this destination',
      },
    };

    // Get the data for the given type, or fall back to a default
    final image =
        typeData[type]?['image'] ?? 'assets/images/wishlist_illustration.png';
    final text = typeData[type]?['text'] ?? 'No items available';

    // Adjust size based on type
    final double imageSize = type == 'wishlist' ? 300 : 200;
    final double textSize = type == 'wishlist' ? 22 : 18;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: Image.asset(image),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xff001939),
                fontWeight: FontWeight.w700,
                fontFamily: 'KastelovAxiforma',
                fontSize: textSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
