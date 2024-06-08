import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/custom_pageview.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/widgets/cars_listview.dart';
import 'package:marhba_bik/widgets/destination_listview.dart';
import 'package:marhba_bik/widgets/houses_listview.dart';
import 'package:marhba_bik/widgets/trips_listview.dart';

class WilayaScreen extends StatelessWidget {
  final Wilaya wilaya;

  const WilayaScreen({super.key, required this.wilaya});

  @override
  Widget build(BuildContext context) {
    List<String> images = [wilaya.imageUrl];
    String name = wilaya.name;
    String title = wilaya.title;
    String description = wilaya.description;
    List<String> regions = wilaya.regions;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff001939),
              fontWeight: FontWeight.w700,
              fontFamily: 'KastelovAxiforma',
              fontSize: 22,
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomPageView(
                    imageUrls: images,
                    height: 300.0,
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    labelColor: Color(0xff001939),
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Houses'),
                      Tab(text: 'Cars'),
                      Tab(text: 'Trips'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
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
                            child: Text(
                              regions.isEmpty
                                  ? 'Située en Algérie'
                                  : regions.length == 1
                                      ? 'Située dans la région de ${regions[0]}'
                                      : 'Située entre ${regions.sublist(0, regions.length - 1).join(', ')} et ${regions[regions.length - 1]}',
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'À la découverte de la beauté de ${wilaya.name}',
                              style: const TextStyle(
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
                              future: FirestoreService()
                                  .fetchDestinationsByWilaya(name),
                              type: 'horizontal',
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Explorez notre large sélection de voitures',
                              style: TextStyle(
                                color: Color(0xff001939),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            height: 280,
                            child: const CarsListScreen(),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Trouvez votre bien idéal',
                              style: TextStyle(
                                color: Color(0xff001939),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            height: 280,
                            child: const HousesListScreen(),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Center(
                  child: HousesListScreen(
                type: 'vertical',
              )),
              const Center(
                  child: CarsListScreen(
                type: 'vertical',
              )),
              const Center(
                  child: TripsListScreen(
                type: 'vertical',
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
