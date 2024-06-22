import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/widgets/lists/destination_listview.dart';
import 'package:marhba_bik/widgets/lists/wilaya_listview.dart';

class RegionScreen extends StatefulWidget {
  final String regionName;

  const RegionScreen({super.key, required this.regionName});

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  late Future<List<Wilaya>> _wilayas;
  late Future<List<Destination>> _destinations;

  @override
  void initState() {
    super.initState();
    _wilayas = FirestoreService().getWilayasByRegion(widget.regionName);
    _destinations =
        FirestoreService().getDestinationsByRegion(widget.regionName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.regionName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Vivez l\'authenticité des Wilayas'),
              WilayaList(
                type: 'vertical',
                future: _wilayas,
              ),
              const SizedBox(height: 40),
              _buildSectionTitle('Découvrez des joyaux cachés'),
              DestinationsList(future: _destinations, type: 'vertical'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xff001939),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}
