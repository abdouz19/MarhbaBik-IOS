import 'package:flutter/material.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'package:marhba_bik/widgets/second_wilaya_item.dart';
import 'package:marhba_bik/widgets/wilaya_item.dart';
import 'package:shimmer/shimmer.dart';

class WilayaList extends StatelessWidget {
  const WilayaList({super.key, required this.future, this.type = 'vertical'})
      ;

  final Future<List<Wilaya>>? future;
  final String type;

  @override
  Widget build(BuildContext context) {
    return type == 'vertical' ? _buildVerticalList() : _buildHorizontalList();
  }

  Widget _buildVerticalList() {
    return FutureBuilder<List<Wilaya>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerList();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading wilayas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No wilayas available'));
        }

        final wilayas = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wilayas.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return WilayaItem(wilaya: wilayas[index]);
          },
        );
      },
    );
  }

  Widget _buildHorizontalList() {
    return FutureBuilder<List<Wilaya>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerHorizontalList();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading wilayas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No wilayas available'));
        }

        final wilayas = snapshot.data!;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: wilayas.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return SecondWilayaItem(
              wilaya: wilayas[index],
              imageHeight: type == 'vertical' ? 280 : 140,
              imageWidth: type == 'vertical' ? double.infinity : 140,
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 160,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 20.0,
                        width: 100.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 15.0,
                        width: 150.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerHorizontalList() {
    return SizedBox(
      height: 200, // Set a fixed height to ensure it displays properly
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 10.0,
                    width: 100.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 10.0,
                    width: 60.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
