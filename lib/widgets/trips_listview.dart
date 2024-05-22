import 'package:flutter/material.dart';
import 'package:marhba_bik/widgets/trip_item.dart';
import 'package:marhba_bik/models/trip.dart';
import 'package:marhba_bik/services/firestore_service.dart';

class TripsListScreen extends StatefulWidget {
  const TripsListScreen({super.key});

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
            shrinkWrap: true, // To allow embedding in another scrollable widget
            physics:
                const NeverScrollableScrollPhysics(), // Prevent scrolling conflicts
            itemCount: trips.length,
            itemBuilder: (context, index) {
              Trip trip = trips[index];
              return TripItem(trip: trip);
            },
          );
        }
      },
    );
  }
}
