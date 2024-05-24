import 'package:flutter/material.dart';
import 'package:marhba_bik/models/house.dart';
import 'package:marhba_bik/widgets/house_item.dart';
import 'package:marhba_bik/services/firestore_service.dart';

class HousesListScreen extends StatefulWidget {
  const HousesListScreen({Key? key}) : super(key: key);

  @override
  State<HousesListScreen> createState() => _HousesListScreenState();
}

class _HousesListScreenState extends State<HousesListScreen> {
  late Future<List<House>> _housesFuture;

  @override
  void initState() {
    super.initState();
    _housesFuture = FirestoreService().fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<House>>(
      future: _housesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching houses"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No houses available"));
        } else {
          List<House> houses = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: houses.length,
            itemBuilder: (context, index) {
              House house = houses[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: HouseItem(house: house),
              );
            },
          );
        }
      },
    );
  }
}