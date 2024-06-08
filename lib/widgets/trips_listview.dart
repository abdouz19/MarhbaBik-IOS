import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/widgets/trip_item.dart';
import 'package:shimmer/shimmer.dart';

class TripsListScreen extends StatefulWidget {
  final String type;

  const TripsListScreen({Key? key, this.type = 'horizontal'}) : super(key: key);

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  late Future<List<Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = FirestoreService().fetchTrips();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trip>>(
      future: _tripsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerList();
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching trips"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No trips available"));
        } else {
          List<Trip> trips = snapshot.data!;
          return ListView.builder(
            scrollDirection:
                widget.type == 'vertical' ? Axis.vertical : Axis.horizontal,
            itemCount: trips.length,
            itemBuilder: (context, index) {
              Trip trip = trips[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TripItem(
                  trip: trip,
                  imageHeight: widget.type == 'vertical' ? 280 : 280,
                  imageWidth: widget.type == 'vertical' ? double.infinity : 250,
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      scrollDirection:
          widget.type == 'vertical' ? Axis.vertical : Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: widget.type == 'vertical' ? double.infinity : 250,
              height: widget.type == 'vertical' ? 280 : 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
