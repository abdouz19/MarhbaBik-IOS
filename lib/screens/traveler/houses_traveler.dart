import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/screens/traveler/wilaya_screen.dart';
import 'package:marhba_bik/widgets/cars_listview.dart';
import 'package:marhba_bik/widgets/houses_listview.dart';
import 'package:marhba_bik/widgets/trips_listview.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:transparent_image/transparent_image.dart';

class HousesTraveler extends StatefulWidget {
  const HousesTraveler({super.key});

  @override
  State<StatefulWidget> createState() => _HousesTravelerScreenState();
}

class _HousesTravelerScreenState extends State<HousesTraveler> {
  late Future<Wilaya?> _wilayaJijel;
  late Future<Wilaya?> _wilayaOran;

  @override
  void initState() {
    super.initState();
    _wilayaJijel = FirestoreService().fetchWilayaByName('Jijel');
    _wilayaOran = FirestoreService().fetchWilayaByName('Oran');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 255,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.asset(
                    width: double.infinity,
                    'assets/images/explore_top.jpg',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 60,
                    left: 10,
                    child: Column(
                      children: [
                        const Text('Explore',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 31,
                            )),
                        OutlinedText(
                          text: const Text('Algeria',
                              style: TextStyle(
                                color: Colors.transparent,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 33,
                              )),
                          strokes: [
                            OutlinedTextStroke(color: Colors.white, width: 1),
                          ],
                        ),
                        const Text('With us',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 31,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Grab your beloved ones and hit the beach',
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Grab your loved ones and hit the beach',
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 280,
                child: const TripsListScreen(),
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: const AssetImage('assets/images/explore_region.jpg'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 80,
                    bottom: 0,
                    left: 125,
                    right: 10,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Explore',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const Text(
                            'Our different',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const Text(
                            'Regions',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Explore our diffrent regions ak chayef',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text('Pick region'))
                        ]),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'You might like these',
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'More things to visit Algeria',
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 280,
                child: const CarsListScreen(),
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: const AssetImage('assets/images/explore_oran.jpg'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 100,
                    bottom: 0,
                    left: 50,
                    right: 80,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Why you',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const Text(
                            'Should visit',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const Text(
                            'Oran',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Explore Oran ak chayef, bla mankatro lhadra',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                Wilaya? wilaya = await _wilayaOran;
                                if (wilaya != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WilayaScreen(wilaya: wilaya),
                                    ),
                                  );
                                }
                              },
                              child: const Text('See more'))
                        ]),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    gradient: LinearGradient(
                        colors: [Color(0xff7FADE9), Color(0xff3F75BB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Column(
                  children: [
                    const Text(
                      'Discover more in Jijel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'KastelovAxiforma',
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        Wilaya? wilaya = await _wilayaJijel;
                        if (wilaya != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WilayaScreen(wilaya: wilaya),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        'Keep exploring',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: 'KastelovAxiforma',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Lace up those boots',
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'More things to visit in Algiers',
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 280,
                child: const HousesListScreen(),
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: const AssetImage('assets/images/explore_june.jpg'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 100,
                    bottom: 0,
                    left: 50,
                    right: 80,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Where to go',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const Text(
                            'in June',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Checkout Our recommendations for this month',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('See more'))
                        ]),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              )
            ],
          )),
        ],
      ),
    );
  }
}
