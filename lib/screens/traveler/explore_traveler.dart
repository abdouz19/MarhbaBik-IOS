import 'package:flutter/material.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/widgets/wilaya_item.dart';

class ExploreTraveler extends StatelessWidget {
  const ExploreTraveler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/homepage_for_now.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 50.0,
                        padding: const EdgeInsets.only(left: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: const Color(0xFFC0C0C0),
                            width: 1.0,
                          ),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Where to?',
                            border: InputBorder.none,
                            isDense: false,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff3F75BB),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: MaterialButtonAuth(
                      onPressed: () {},
                      label: 'Pick a region',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Summer gateways',
                    style: TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const WilayaItem(),
                  const SizedBox(
                    height: 5,
                  ),
                  const WilayaItem(),
                  const SizedBox(
                    height: 5,
                  ),
                  const WilayaItem(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Attraction nearby',
                    style: TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const WilayaItem(),
                  const SizedBox(
                    height: 5,
                  ),
                  const WilayaItem(),
                  const SizedBox(
                    height: 5,
                  ),
                  const WilayaItem(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Destinations travelers love',
                    style: TextStyle(
                      color: Color(0xff001939),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KastelovAxiforma',
                      fontSize: 22,
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: const [
                      GridItem(color: Colors.red),
                      GridItem(color: Colors.blue),
                      GridItem(color: Colors.green),
                      GridItem(color: Colors.yellow),
                    ],
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

class GridItem extends StatelessWidget {
  final Color color;

  const GridItem({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
