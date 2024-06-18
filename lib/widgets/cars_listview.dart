import 'package:flutter/material.dart';
import 'package:marhba_bik/models/car.dart';
import 'package:marhba_bik/widgets/car_item.dart';
import 'package:marhba_bik/widgets/empty_list.dart';
import 'package:shimmer/shimmer.dart';

class CarsListScreen extends StatefulWidget {
  final String type;
  final Future<List<Car>> carsFuture;

  const CarsListScreen({
    super.key,
    this.type = 'horizontal',
    required this.carsFuture,
  });

  @override
  State<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  late Future<List<Car>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _carsFuture = widget.carsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Car>>(
      future: _carsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: _buildShimmerList());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching cars"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyList(
            type: 'car',
          );
        } else {
          List<Car> cars = snapshot.data!;
          return ListView.builder(
            scrollDirection:
                widget.type == 'vertical' ? Axis.vertical : Axis.horizontal,
            itemCount: cars.length,
            itemBuilder: (context, index) {
              Car car = cars[index];
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CarItem(
                  car: car,
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
