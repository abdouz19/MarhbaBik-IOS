import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomizedOutlinedMaterialButton extends StatelessWidget {
  const CustomizedOutlinedMaterialButton(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.icon,
      required this.color});

  final void Function() onPressed;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color, width: 1),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(width: 15),
            Text(
              label, // Button text
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
