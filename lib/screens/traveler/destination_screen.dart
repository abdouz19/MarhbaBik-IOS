import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/custom_pageview.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:marhba_bik/widgets/destination_listview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key, required this.destination});

  final Destination destination;

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> images = widget.destination.otherPicturesUrls;
    String name = widget.destination.name;
    String title = widget.destination.title;
    String description = widget.destination.description;
    String category = widget.destination.category;
    String region = widget.destination.region;
    String wilaya = widget.destination.wilaya;

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
                          color: const Color.fromARGB(255, 168, 168, 168),
                        ),
                        onPressed: () {
                          // Heart button action
                        },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: const Color(0xff001939),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RatingBar.builder(
                      initialRating:
                          calculateAverageRating(widget.destination.ratings),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '$category au coeur de la $region, $wilaya.',
                      style: GoogleFonts.poppins(
                        color: const Color(0xff8E8E8E),
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xff001939),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Des paysages à couper le souffle ',
                      style: TextStyle(
                        color: Color(0xff001939),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KastelovAxiforma',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: 280,
                    child: DestinationsList(
                      future: FirestoreService().fetchDestinations(),
                      type: 'horizontal',
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  /*MaterialButtonAuth(
                    label: 'See more',
                    onPressed: () {
                      
                    },
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double calculateAverageRating(List<int> ratings) {
  final totalRatings = ratings.fold(0, (sum, rating) => sum + rating);
  final averageRating = totalRatings / ratings.length;
  return averageRating;
}
