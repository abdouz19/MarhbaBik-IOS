import 'package:flutter/material.dart';
import 'package:marhba_bik/widgets/trip_item.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/api/firestore_service.dart';

class TripsListScreen extends StatefulWidget {
  const TripsListScreen({Key? key}) : super(key: key);

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching trips"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No trips available"));
        } else {
          List<Trip> trips = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trips.length,
            itemBuilder: (context, index) {
              Trip trip = trips[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TripItem(trip: trip),
              );
            },
          );
        }
      },
    );
  }
}