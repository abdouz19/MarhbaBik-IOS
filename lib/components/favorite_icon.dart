import 'package:flutter/material.dart';

class HeartIcon extends StatelessWidget {
  final bool isFavorited;

  const HeartIcon({super.key, required this.isFavorited});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // White stroke for both favorite and non-favorite states
        const Icon(
          Icons.favorite_border,
          color: Colors.white, // Outlined heart: white stroke
        ),
        if (!isFavorited) // Show black icon only for non-favorite state
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.favorite,
                color: Colors.black54, // Outlined heart: inner black icon
                size: 18.0, // Adjust size to fit within stroke (optional)
              ),
            ),
          ),
        // Filled red icon for favorite state
        if (isFavorited)
          const Icon(
            Icons.favorite,
            color: Colors.red, // Filled heart: red color
          ),
      ],
    );
  }
}
