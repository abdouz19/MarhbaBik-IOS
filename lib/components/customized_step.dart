import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomizedStep extends StatelessWidget {
  const CustomizedStep({super.key, required this.number, required this.title, required this.description});
  final String number;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                description,
                style: GoogleFonts.lato(
                  color: const Color(0xff959494),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
