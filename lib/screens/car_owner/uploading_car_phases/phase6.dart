import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/widgets/custom_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marhba_bik/components/profile_bar.dart';

class UploadingCarFinalPhase extends StatefulWidget {
  final String brand;
  final String wilaya;
  final String model;
  final int capacity;
  final String title;
  final String description;
  final List<XFile?> images;
  final String price;

  const UploadingCarFinalPhase({
    super.key,
    required this.brand,
    required this.wilaya,
    required this.model,
    required this.capacity,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
  });

  @override
  State<UploadingCarFinalPhase> createState() =>
      _UploadingHomeCarPhaseState();
}

class _UploadingHomeCarPhaseState extends State<UploadingCarFinalPhase> {
  String _firstName = '';
  String _lastName = '';
  String _profilePicture = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          _firstName = userSnapshot['firstName'];
          _lastName = userSnapshot['lastName'];
          _profilePicture = userSnapshot['profilePicture'];
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review your listing',
          style: GoogleFonts.poppins(
            color:const Color(0xff001939),
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        CustomCarouselSlider(
          images: widget.images,
          height: 200.0,
          
        ),
        const SizedBox(height: 10),
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: const Color(0xff001939),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.brand} ${widget.model} in ${widget.wilaya}.',
          style: GoogleFonts.poppins(
            color: const Color(0xff001939),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${widget.capacity} seating place',
          style: GoogleFonts.poppins(
            color:const Color(0xff001939),
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        ProfileBar(firstName: _firstName,lastName: _lastName,profilePicture: _profilePicture,),
        const SizedBox(height: 10),
        Text(
          widget.description,
          style: GoogleFonts.poppins(
            color:const Color(0xff001939),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
