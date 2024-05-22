import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesTraveler extends StatelessWidget {
  const MessagesTraveler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3F75BB),
      body:SafeArea(
        child: Center(
          child: Text('Messages', textAlign: TextAlign.center,style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
