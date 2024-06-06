import 'package:flutter/material.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/models/wilaya.dart';
import 'wilaya_item.dart';

class WilayaList extends StatelessWidget {
  const WilayaList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Wilaya>>(
      future: FirestoreService().fetchWilayas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
          itemBuilder: (context, index) {
            return WilayaItem(wilaya: wilayas[index]);
          },
        );
      },
    );
  }
}
