import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marhba_bik/screens/car_owner/edit_offer_car.dart';
import 'package:marhba_bik/screens/home_owner/edit_offer_house.dart';
import 'package:marhba_bik/screens/traveling_agency/offer_edit_trip.dart';

class CustomCarouselSlider extends StatefulWidget {
  final List<XFile?>? images;
  final List<String>? imageUrls;
  final double height;
  final Map<String, dynamic>? offer;
  final Function? onDelete;
  final String? offerType;
  const CustomCarouselSlider({
    super.key,
    this.images,
    this.imageUrls,
    required this.height,
    this.offer,
    this.onDelete,
    this.offerType,
  }) : assert(images != null || imageUrls != null,
            'Either images or imageUrls must be provided');

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round();
      });
    });
  }

  void _showEditDialog() {
    if (widget.images != null) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier l'offre"),
          content: const Text("Êtes-vous sûr(e) de vouloir modifier cette offre ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      if (widget.offerType == 'trip') {
                        return EditOfferTrip(offer: widget.offer!);
                      } else if (widget.offerType == 'car') {
                        return EditOfferCar(offer: widget.offer!);
                      } else if (widget.offerType == 'house') {
                        return EditOfferHouse(offer: widget.offer!);
                      } else {
                        throw Exception('Invalid offer type');
                      }
                    },
                  ),
                );

              },
              child: const Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Non"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog() {
    if (widget.images != null) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer l'offre"),
          content: const Text("Êtes-vous sûr(e) de vouloir supprimer cette offre ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete!();
              },
              child: const Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Non"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];

    if (widget.images != null) {
      images = widget.images!.map((XFile? image) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(10, 10),
              bottomRight: Radius.elliptical(10, 10),
              topLeft: Radius.elliptical(10, 10),
              topRight: Radius.elliptical(10, 10),
            ),
            child: image != null
                ? Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                    height: widget.height,
                  )
                : Image(
                    image: const AssetImage('assets/images/picture.jpg'),
                    fit: BoxFit.cover,
                    height: widget.height,
                  ),
          ),
        );
      }).toList();
    } else if (widget.imageUrls != null) {
      images = widget.imageUrls!.map((String imageUrl) {
        return Stack(
          children: [
            const Center(child: CircularProgressIndicator()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: widget.height,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(10, 10),
                  bottomRight: Radius.elliptical(10, 10),
                  topLeft: Radius.elliptical(10, 10),
                  topRight: Radius.elliptical(10, 10),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: widget.height,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        );
      }).toList();
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            allowImplicitScrolling: true,
            controller: _controller,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return images[index];
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => buildDot(index),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 61, //
          child: GestureDetector(
            onTap: _showEditDialog,
            child: widget.images != null
                ? Container()
                : ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: _showDeleteDialog,
            child: widget.images != null
                ? Container()
                : ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.white : Colors.grey,
      ),
    );
  }
}
