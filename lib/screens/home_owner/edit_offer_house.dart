import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/custom_image.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/white_container_field.dart';
import 'package:marhba_bik/data/constant_data.dart';

class EditOfferHouse extends StatefulWidget {
  const EditOfferHouse({super.key, required this.offer});
  final Map<String, dynamic> offer;

  @override
  State<EditOfferHouse> createState() => _EditOfferHouseState();
}

class _EditOfferHouseState extends State<EditOfferHouse> {
  late List<String> imageUrls;
  late String title;
  late String placeType;
  late String address;
  late String selectedWilaya;
  late int capacity;
  late String price;
  late String description;
  late String tripId;

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imageUrls = (widget.offer['images'] as List<dynamic>).cast<String>();
    title = widget.offer['title'];
    placeType = widget.offer['placeType'];
    address = widget.offer['address'];
    selectedWilaya = widget.offer['wilaya'];
    capacity = widget.offer['capacity'];
    price = widget.offer['price'].toString();
    description = widget.offer['description'];
    tripId = widget.offer['id'];

    // Ensure selectedWilaya is valid
    if (!wilayaNames.contains(selectedWilaya)) {
      selectedWilaya = wilayaNames.first;
    }

    // Ensure placeType is valid
    if (!placeTypes.contains(placeType)) {
      placeType = placeTypes.first;
    }

    // Set initial values to controllers
    titleController.text = title;
    priceController.text = price;
    descriptionController.text = description;
    addressController.text = address;
  }

  void _showDialog(String title, String content, void Function()? onPressed) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDetails() async {
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        addressController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        capacity == 0) {
      _showDialog('Error', 'Please fill all the fields', () {
        Navigator.of(context).pop();
      });
    } else {
      // Show a progress indicator while updating
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        // Update the document in Firestore
        await FirebaseFirestore.instance
            .collection('houses')
            .doc(tripId)
            .update({
          'title': titleController.text,
          'address': addressController.text,
          'placeType': placeType,
          'wilaya': selectedWilaya,
          'capacity': capacity,
          'price': int.parse(priceController.text),
          'description': descriptionController.text,
        });

        // Close the progress indicator
        Navigator.of(context).pop();

        _showDialog('Success', 'Details updated successfully', () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } catch (error) {
        // Close the progress indicator
        Navigator.of(context).pop();

        _showDialog('Error', 'Failed to update details. Please try again.',(){
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your listing', style: GoogleFonts.lato(
          color:const Color(0xff001939),
        ),),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomImage(
                imageUrl: imageUrls.isNotEmpty ? imageUrls[0] : '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (imageUrls.length > 1)
                    CustomImage(
                      imageUrl: imageUrls[1],
                      height: 130,
                      width: (MediaQuery.of(context).size.width - 60) / 1.95,
                      borderRadius: BorderRadius.circular(10),
                      fit: BoxFit.cover,
                    ),
                  if (imageUrls.length > 2)
                    CustomImage(
                      imageUrl: imageUrls[2],
                      height: 130,
                      width: (MediaQuery.of(context).size.width - 60) / 1.95,
                      borderRadius: BorderRadius.circular(10),
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              const SizedBox(height: 30),
              CustomContainer(
                title: 'Title',
                content: TextField(
                  controller: titleController,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: const Color(0xff8B8B8B),
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Place Type',
                content: DropdownButtonFormField<String>(
                  value: placeType,
                  items: placeTypes.toSet().toList().map((String placeType) { // Ensure unique items
                    return DropdownMenuItem<String>(
                      value: placeType,
                      child: Text(
                        placeType,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: const Color(0xff8B8B8B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      placeType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Wilaya',
                content: DropdownButtonFormField<String>(
                  value: selectedWilaya,
                  items: wilayaNames.map((String wilaya) {
                    return DropdownMenuItem<String>(
                      value: wilaya,
                      child: Text(
                        wilaya,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: const Color(0xff8B8B8B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedWilaya = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Exact address',
                content: TextField(
                  controller: addressController,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: const Color(0xff8B8B8B),
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Capacity',
                content: Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 10),
                  child: CapacitySelector(
                    initialCapacity: capacity,
                    onCapacityChanged: (newCapacity) {
                      setState(() {
                        capacity = newCapacity;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Price',
                content: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: const Color(0xff8B8B8B),
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10),
                    suffixText: 'DZD/person',
                    suffixStyle: GoogleFonts.lato(
                      fontSize: 18,
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Description',
                content: DescriptionField(
                  initialValue: description,
                  onChanged: (value) {
                    descriptionController.text = value;
                  },
                ),
              ),
              const SizedBox(height: 40),
              MaterialButtonAuth(
                label: 'Update details',
                onPressed: _updateDetails,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
