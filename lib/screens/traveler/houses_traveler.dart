import 'package:flutter/material.dart';
import 'package:marhba_bik/widgets/trips_listview.dart';
import 'package:outlined_text/outlined_text.dart';

class HousesTraveler extends StatelessWidget {
  const HousesTraveler({super.key});

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
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
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
                        fontWeight: FontWeight.w400,
                        fontFamily: 'KastelovAxiforma',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TripsListScreen(),
                  Image.asset(
                    'assets/images/explore_region.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
