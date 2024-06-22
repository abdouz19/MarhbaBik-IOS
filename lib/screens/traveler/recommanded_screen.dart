import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/models/destination.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/widgets/lists/destination_listview.dart';
import 'package:marhba_bik/widgets/lists/wilaya_listview.dart';

class RecommandedScreen extends StatefulWidget {
  const RecommandedScreen({super.key, required this.type});

  final String type;

  @override
  State<RecommandedScreen> createState() => _RecommandedScreenState();
}

class _RecommandedScreenState extends State<RecommandedScreen> {
  late Future<List<Wilaya>> _wilayas;
  late Future<List<Destination>> _destinations;
  late List<String> _selectedWilayaNames;

  // Map of wilaya ID to its name
  final Map<String, String> wilayaIdNameMap = {
    '06': 'Bejaia',
    '31': 'Oran',
    '18': 'Jijel',
  };

  @override
  void initState() {
    super.initState();

    if (widget.type == 'wilayas') {
      _wilayas = FirestoreService().fetchWilayas();
    } else if (widget.type == 'destinations') {
      _destinations = FirestoreService().fetchDestinations();
    } else if (widget.type == 'recommended') {
      // Initialize _selectedWilayaNames here
      _selectedWilayaNames = wilayaIdNameMap.values.toList();

      // Fetch wilayas
      _wilayas =
          FirestoreService().fetchSpecialWilayas(wilayaIdNameMap.keys.toList());

      // Combine destinations from all selected wilaya names
      List<Future<List<Destination>>> destinationFutures = [];
      for (final wilayaName in _selectedWilayaNames) {
        destinationFutures
            .add(FirestoreService().fetchDestinationsByWilaya(wilayaName));
      }
      _destinations = Future.wait(destinationFutures).then((lists) {
        // Concatenate all destination lists
        return lists.expand((list) => list).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.type == 'wilayas' || widget.type == 'recommended') ...[
                _buildSectionTitle('Explorer les Pépites des Wilayas'),
                WilayaList(
                  type: 'vertical',
                  future: _wilayas,
                ),
                const SizedBox(height: 40),
              ],
              if (widget.type == 'destinations' ||
                  widget.type == 'recommended') ...[
                _buildSectionTitle('Les Trésors Cachés à Découvrir'),
                DestinationsList(
                  future: _destinations,
                  type: 'vertical',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (widget.type) {
      case 'wilayas':
        return 'Explorer les Wilayas';
      case 'destinations':
        return 'Explorer les Destinations';
      case 'recommended':
        return 'Les Incontournables de Juin';
      default:
        return 'Les Incontournables de Juin';
    }
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
