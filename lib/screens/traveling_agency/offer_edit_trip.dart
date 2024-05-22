import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/chip.dart';
import 'package:marhba_bik/components/custom_image.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/white_container_field.dart';
import 'package:marhba_bik/data/constant_data.dart';

class EditOfferTrip extends StatefulWidget {
  const EditOfferTrip({super.key, required this.offer});
  final Map<String, dynamic> offer;

  @override
  State<StatefulWidget> createState() => _EditOfferTripState();
}

class _EditOfferTripState extends State<EditOfferTrip> {
  late List<String> imageUrls;
  late String title;
  late DateTime startDate;
  late DateTime endDate;
  late String selectedWilaya;
  late List<String> activities;
  late int tripCapacity;
  late String price;
  late String description;
  late String tripId;

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imageUrls = (widget.offer['images'] as List<dynamic>).cast<String>();
    title = widget.offer['title'];
    startDate = (widget.offer['startDate'] as Timestamp).toDate();
    endDate = (widget.offer['endDate'] as Timestamp).toDate();
    selectedWilaya = widget.offer['wilaya'];
    activities = (widget.offer['activities'] as List<dynamic>).cast<String>();
    tripCapacity = widget.offer['capacity'];
    price = widget.offer['price'].toString();
    description = widget.offer['description'];
    tripId = widget.offer['id'];

    if (!wilayaNames.contains(selectedWilaya)) {
      selectedWilaya = wilayaNames.first;
    }

    // Set initial values to controllers
    titleController.text = title;
    priceController.text = price;
    descriptionController.text = description;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
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
        descriptionController.text.isEmpty ||
        activities.isEmpty ||
        tripCapacity == 0) {
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
            .collection('trips')
            .doc(tripId)
            .update({
          'title': titleController.text,
          'startDate': Timestamp.fromDate(startDate),
          'endDate': Timestamp.fromDate(endDate),
          'wilaya': selectedWilaya,
          'activities': activities,
          'capacity': tripCapacity,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit your listing'),
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
                title: 'Date Range',
                content: GestureDetector(
                  onTap: () => _selectDateRange(context),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 10),
                        Text(
                          '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: const Color(0xff8B8B8B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
                title: 'Activities',
                content: SimpleChipsInput(
                  activities: activities,
                  onChanged: (activitiesList) {
                    setState(() {
                      activities = activitiesList;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomContainer(
                title: 'Trip Capacity',
                content: Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 10),
                  child: CapacitySelector(
                    initialCapacity: tripCapacity,
                    onCapacityChanged: (newCapacity) {
                      setState(() {
                        tripCapacity = newCapacity;
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
