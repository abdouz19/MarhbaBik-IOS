import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/widgets/custom_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marhba_bik/components/profile_bar.dart';
import 'package:intl/intl.dart';

class UploadingTripFinalPhase extends StatefulWidget {
  final DateTimeRange dates;
  final String wilaya;
  final List<String> activities;
  final int capacity;
  final String title;
  final String description;
  final List<XFile?> images;
  final String price;


  const UploadingTripFinalPhase({
    super.key,
    required this.dates,
    required this.wilaya,
    required this.activities,
    required this.capacity,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
  });

  @override
  State<UploadingTripFinalPhase> createState() =>
      _UploadingTripFinalPhaseState();
}

class _UploadingTripFinalPhaseState extends State<UploadingTripFinalPhase> {
  String _agencyName = '';
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
          _agencyName = userSnapshot['agencyName'];
          _profilePicture = userSnapshot['profilePicture'];
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final String formattedStartDate = dateFormat.format(widget.dates.start);
    final String formattedEndDate = dateFormat.format(widget.dates.end);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review your listing',
          style: GoogleFonts.poppins(
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
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '$formattedStartDate to $formattedEndDate in ${widget.wilaya}.',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${widget.capacity} seating place',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        ProfileBar(firstName: _agencyName,profilePicture: _profilePicture,),
        const SizedBox(height: 10),
        Text(
          widget.description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
