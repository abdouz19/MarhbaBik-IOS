import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialButtonAuth extends StatelessWidget {
  const MaterialButtonAuth({super.key, required this.onPressed, required this.label});
  final void Function() onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
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
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
