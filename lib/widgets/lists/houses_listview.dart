import 'package:flutter/material.dart';
import 'package:marhba_bik/models/house.dart';
import 'package:marhba_bik/widgets/empty_list.dart';
import 'package:marhba_bik/widgets/items/house_item.dart';
import 'package:shimmer/shimmer.dart';

class HousesListScreen extends StatefulWidget {
  final String type;
  final Future<List<House>> housesFuture;

  const HousesListScreen({
    super.key,
    this.type = 'horizontal',
    required this.housesFuture,
  });

  @override
  State<HousesListScreen> createState() => _HousesListScreenState();
}

class _HousesListScreenState extends State<HousesListScreen> {
  late Future<List<House>> _housesFuture;

  @override
  void initState() {
    super.initState();
    _housesFuture = widget.housesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<House>>(
      future: _housesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: _buildShimmerList());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching houses"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyList(
            type: 'house',
          );
        } else {
          List<House> houses = snapshot.data!;
          return ListView.builder(
            scrollDirection:
                widget.type == 'vertical' ? Axis.vertical : Axis.horizontal,
            itemCount: houses.length,
            itemBuilder: (context, index) {
              House house = houses[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: HouseItem(
                  house: house,
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
