import 'package:flutter/material.dart';
import 'package:marhba_bik/models/car.dart';
import 'package:marhba_bik/widgets/car_item.dart';
import 'package:marhba_bik/services/firestore_service.dart';

class CarsListScreen extends StatefulWidget {
  const CarsListScreen({Key? key}) : super(key: key);

  @override
  State<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  late Future<List<Car>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _carsFuture = FirestoreService().fetchCars();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Car>>(
      future: _carsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching cars"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No cars available"));
        } else {
          List<Car> cars = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cars.length,
            itemBuilder: (context, index) {
              Car car = cars[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarItem(car: car),
              );
            },
          );
        }
      },
    );
  }
}