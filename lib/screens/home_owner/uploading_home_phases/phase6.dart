import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/widgets/custom_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marhba_bik/components/profile_bar.dart';

class UploadingHomeFinalPhase extends StatefulWidget {
  final String placeType;
  final String wilaya;
  final String address;
  final int capacity;
  final String title;
  final String description;
  final List<XFile?> images;
  final String price;

  const UploadingHomeFinalPhase({
    super.key,
    required this.placeType,
    required this.wilaya,
    required this.address,
    required this.capacity,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
  });

  @override
  State<UploadingHomeFinalPhase> createState() =>
      _UploadingHomeFinalPhaseState();
}

class _UploadingHomeFinalPhaseState extends State<UploadingHomeFinalPhase> {
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
            fontSize: 28,
            color:const Color(0xff001939),
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
            fontSize: 20,
            color:const Color(0xff001939),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.placeType} in ${widget.address}, ${widget.wilaya}.',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${widget.capacity} guests',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color:const Color(0xff001939),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        ProfileBar(firstName: _firstName,lastName: _lastName,profilePicture: _profilePicture,),
        const SizedBox(height: 10),
        Text(
          widget.description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color:const Color(0xff001939),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
