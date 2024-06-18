import 'package:flutter/material.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/widgets/empty_list.dart';
import 'package:marhba_bik/widgets/trip_item.dart';
import 'package:shimmer/shimmer.dart';

class TripsListScreen extends StatefulWidget {
  final String type;
  final Future<List<Trip>> tripsFuture;

  const TripsListScreen({
    super.key,
    this.type = 'horizontal',
    required this.tripsFuture,
  });

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  late Future<List<Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = widget.tripsFuture;
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
          return const EmptyList(
            type: 'trip',
          );
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
                  imageWidth: widget.type == 'vertical' ? double.infinity : 280,
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
              width: widget.type == 'vertical' ? double.infinity : 280,
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
