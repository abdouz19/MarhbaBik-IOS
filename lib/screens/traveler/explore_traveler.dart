import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/screens/traveler/wilaya_screen.dart';
import 'package:marhba_bik/widgets/destination_listview.dart';
import 'package:marhba_bik/widgets/wilaya_listview.dart';
import 'package:marhba_bik/widgets/wilayaitem.dart';

class ExploreTraveler extends StatefulWidget {
  const ExploreTraveler({super.key});

  @override
  State<ExploreTraveler> createState() => _ExploreTravelerState();
}

class _ExploreTravelerState extends State<ExploreTraveler> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Wilaya>>? _futureWilayas;
  List<Wilaya> _filteredWilayas = [];
  bool _isSearching = false;
  late Future<List<Wilaya>> futureSpecialWilayas;

  @override
  void initState() {
    super.initState();
    futureSpecialWilayas =
        FirestoreService().fetchSpecialWilayas(['10', '06', '31', '19']);
    _futureWilayas = FirestoreService().fetchWilayas();
    _futureWilayas?.then((wilayas) {
      setState(() {
        _filteredWilayas = wilayas;
      });
    });
    _searchController.addListener(() => _filterWilayas(_searchController.text));
  }

  void _filterWilayas(String query) {
    _futureWilayas?.then((wilayas) {
      setState(() {
        _filteredWilayas = wilayas.where((wilaya) {
          return wilaya.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
        _isSearching = query.isNotEmpty;
      });
    }).catchError((error) => print("Error fetching wilayas: $error"));
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredWilayas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
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
                      const SizedBox(height: 10),
                      _buildSearchBar(),
                      const SizedBox(height: 20.0),
                      _buildPickRegionButton(),
                      const SizedBox(height: 20.0),
                      _buildSectionTitle('Summer gateways'),
                      WilayaList(
                        future: FirestoreService()
                            .fetchSpecialWilayas(['06', '10', '35']),
                      ),
                      _buildSeeAllButton(
                        onPressed: () {},
                      ),
                      _buildSectionTitle('Attraction nearby'),
                      DestinationsList(
                        future: FirestoreService().fetchSpecialDestinations(
                            ['Yema gouraya', 'Lac vert', "Makam al shahid"]),
                        type: 'vertical',
                      ),
                      _buildSeeAllButton(
                        onPressed: () {},
                      ),
                      _buildSectionTitle('Destinations travelers love'),
                      _buildSpecialWilayasGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isSearching) _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Stack(
      children: [
        Container(
          height: 50.0,
          padding: const EdgeInsets.only(left: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: const Color(0xFFC0C0C0), width: 1.0),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
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
    );
  }

  Widget _buildPickRegionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: MaterialButtonAuth(
        onPressed: () {},
        label: 'Pick a region',
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xff001939),
        fontWeight: FontWeight.bold,
        fontFamily: 'KastelovAxiforma',
        fontSize: 22,
      ),
    );
  }

  Widget _buildSpecialWilayasGrid() {
    return FutureBuilder<List<Wilaya>>(
      future: futureSpecialWilayas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading wilayas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No wilayas found'));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return SecondWilayaItem(wilaya: snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return Positioned(
      top: 160.0,
      left: 20.0,
      right: 20.0,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _closeSearch,
                  ),
                ],
              ),
              Expanded(
                child: _filteredWilayas.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredWilayas.length,
                        itemBuilder: (context, index) {
                          return WilayaTile(wilaya: _filteredWilayas[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          'No results found for "${_searchController.text}"',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSeeAllButton({required VoidCallback onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      'See All',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class WilayaTile extends StatelessWidget {
  final Wilaya wilaya;

  const WilayaTile({super.key, required this.wilaya});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WilayaScreen(wilaya: wilaya)),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(wilaya.imageUrl),
        ),
        title: Text(wilaya.name),
        subtitle: Text(
          wilaya.regions.isEmpty
              ? 'Située en Algérie'
              : wilaya.regions.length == 1
                  ? 'Située dans la région de ${wilaya.regions[0]}'
                  : 'Située entre ${wilaya.regions.sublist(0, wilaya.regions.length - 1).join(', ')} et ${wilaya.regions.last}',
        ),
      ),
    );
  }
}
