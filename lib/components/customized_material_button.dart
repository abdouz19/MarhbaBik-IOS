import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; 


class CustomizedMaterialButton extends StatelessWidget {
  const CustomizedMaterialButton({super.key, required this.label, required this.onPressed, this.iconPath,});

  final void Function() onPressed;
  final String label;
  final String? iconPath; // SVG icon path

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjusted height to 50
      width: double.infinity, // Width set to double.infinity
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.zero, // Remove default padding
        color: Colors.transparent, // Make button background transparent
        elevation: 0, // Remove button shadow
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Color(0xff3F75BB),
                Color(0xff79ACEE),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null) // Check if iconPath is provided
                Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0), // Add spacing between icon and text
                  child: SvgPicture.asset(
                    iconPath!, // Use SVG icon
                    height: 24, // Set height of the icon
                    width: 24, // Set width of the icon
                  ),
                ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, // Set text to bold
                  fontSize: 20, // Adjusted font size to 20
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
