import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/custom_pageview.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/profile_bar.dart';
import 'package:marhba_bik/models/house.dart';
import 'package:marhba_bik/screens/traveler/detailed_screens/sending_house_request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HouseDetailedScreen extends StatefulWidget {
  const HouseDetailedScreen({super.key, required this.house});

  final House house;

  @override
  State<HouseDetailedScreen> createState() => _HouseDetailedScreenState();
}

class _HouseDetailedScreenState extends State<HouseDetailedScreen> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    String houseId = widget.house.id;
    bool isFavorited =
        await FirestoreService().isItemFavorited(houseId, "house");
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  Future<void> _toggleFavoriteStatus() async {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    String houseId = widget.house.id;
    if (_isFavorited) {
      await FirestoreService().addToWishlist(houseId, "house");
    } else {
      await FirestoreService().removeFromWishlist(houseId, "house");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.house.images;
    String title = widget.house.title;
    String address = widget.house.address;
    String description = widget.house.description;
    String placeType = widget.house.placeType;
    String wilaya = widget.house.wilaya;
    String price = widget.house.price;
    int capacity = widget.house.capacity;
    String ownerFirstName = widget.house.ownerFirstName;
    String ownerLastName = widget.house.ownerLastName;
    String ownerProfilePicture = widget.house.ownerProfilePicture;

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
                      fontSize: 20,
                      color: const Color(0xff001939),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$placeType à $address, $wilaya.',
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
                    firstName: ownerFirstName,
                    lastName: ownerLastName,
                    profilePicture: ownerProfilePicture,
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
        height: 70, // Set a fixed height for the bottom navigation bar
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment
                  .center, // Center align the column contents vertically
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
                        text: ' /night',
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
                  'Available',
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
                label: 'Reserve',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendingHouseRequestScreen(
                                house: widget.house,
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
