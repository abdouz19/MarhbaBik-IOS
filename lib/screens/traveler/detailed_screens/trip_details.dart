import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/custom_pageview.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/profile_bar.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/screens/traveler/detailed_screens/sending_trip_request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TripDetailedScreen extends StatefulWidget {
  const TripDetailedScreen({super.key, required this.trip});

  final Trip trip;

  @override
  State<TripDetailedScreen> createState() => _TripDetailedScreenState();
}

class _TripDetailedScreenState extends State<TripDetailedScreen> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    String tripId = widget.trip.id;
    bool isFavorited = await FirestoreService().isItemFavorited(tripId, "trip");
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  Future<void> _toggleFavoriteStatus() async {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    String carId = widget.trip.id;
    if (_isFavorited) {
      await FirestoreService().addToWishlist(carId, "trip");
    } else {
      await FirestoreService().removeFromWishlist(carId, "trip");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.trip.images;
    String title = widget.trip.title;
    Timestamp startDate = widget.trip.startDate;
    String description = widget.trip.description;
    Timestamp endDate = widget.trip.endDate;
    String wilaya = widget.trip.wilaya;
    String price = widget.trip.price;
    int capacity = widget.trip.capacity;
    String agencyName = widget.trip.agencyName;
    String agencyProfilePicture = widget.trip.agencyProfilePicture;

    // Convert Timestamp to DateTime
    DateTime startDateTime = startDate.toDate();
    DateTime endDateTime = endDate.toDate();

    // Format DateTime to string
    String formattedStartDate =
        DateFormat('dd - MM - yyyy').format(startDateTime);
    String formattedEndDate = DateFormat('dd - MM - yyyy').format(endDateTime);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: CustomPageView(
                imageUrls: images,
                height: 300.0,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 168, 168, 168),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Color.fromARGB(255, 168, 168, 168),
                        ),
                        onPressed: () {
                          // Share button action
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          MdiIcons.heart,
                          color: _isFavorited
                              ? Colors.red
                              : const Color.fromARGB(255, 168, 168, 168),
                        ),
                        onPressed: _toggleFavoriteStatus,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xff001939),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Du $formattedStartDate au $formattedEndDate à $wilaya.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$capacity personnes',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xff001939),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileBar(
                    firstName: agencyName,
                    profilePicture: agencyProfilePicture,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xff001939),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // New activities section
                  const Text(
                    'Activités:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.trip.activities.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          '• $activity',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xff001939),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 10,
            ),
          ],
        ),
        height: 70,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${price}DZD',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff001939),
                        ),
                      ),
                      TextSpan(
                        text: ' /person',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff001939),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Disponible',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 50),
            Expanded(
              child: MaterialButtonAuth(
                label: 'Réserver',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendingTripRequestScreen(
                                trip: widget.trip,
                              )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
