import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marhba_bik/models/wilaya.dart';

class WilayaScreen extends StatelessWidget {
  final Wilaya wilaya;

  const WilayaScreen({Key? key, required this.wilaya}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wilaya.name),
        backgroundColor: const Color(0xff3F75BB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: wilaya.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                wilaya.name,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                wilaya.description,
                style: const TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              // Additional details or content about the Wilaya can be added here
            ],
          ),
        ),
      ),
    );
  }
}
