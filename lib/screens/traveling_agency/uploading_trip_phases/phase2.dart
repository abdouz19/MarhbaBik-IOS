import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/custom_dropdown.dart';
import 'package:marhba_bik/components/custom_textfield_outlined.dart';
import 'package:marhba_bik/data/constant_data.dart';

class UploadingTripSecondPhase extends StatefulWidget {
  final Function(DateTimeRange) onTripDaysChanged;
  final Function(String?) onWilayaSelected;
  final Function(int) onCapacityChanged;
  final Function(List<String>) onTripActivitiesChanged;

  const UploadingTripSecondPhase({
    super.key,
    required this.onTripDaysChanged,
    required this.onWilayaSelected,
    required this.onCapacityChanged,
    required this.onTripActivitiesChanged,
  });

  @override
  State<UploadingTripSecondPhase> createState() =>
      _UploadingTripSecondPhaseState();
}

class _UploadingTripSecondPhaseState extends State<UploadingTripSecondPhase> {
  String? _selectedWilaya;
  int selectedCapacity = 1;
  DateTimeRange? tripDays;
  List<TextEditingController> tripActivitiesControllers = [
    TextEditingController()
  ];

  final List<String> _wilayas = wilayaNames;

  bool validateInputs() {
    if (tripDays == null ||
        _selectedWilaya == null ||
        selectedCapacity == 0 ||
        tripActivitiesControllers
            .any((controller) => controller.text.isEmpty)) {
      return false;
    }
    return true;
  }

  void _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tripDays = picked;
      });
      widget.onTripDaysChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let’s start with the basic information',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose the trip days',
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _pickDateRange,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
                hintText: 'Select trip days',
              ),
              child: tripDays == null
                  ? const Text('Select trip days')
                  : Text(
                      '${DateFormat('yyyy-MM-dd').format(tripDays!.start)} - ${DateFormat('yyyy-MM-dd').format(tripDays!.end)}'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Trip Activities',
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ...tripActivitiesControllers.map((controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomTextFieldContainer(
                controller: controller,
                height: 50,
                hintText: 'Enter an activity',
                onChanged: (value) {
                  setState(() {});
                  widget.onTripActivitiesChanged(tripActivitiesControllers
                      .map((controller) => controller.text)
                      .toList());
                },
              ),
            );
          }).toList(),
          TextButton(
            onPressed: () {
              setState(() {
                tripActivitiesControllers.add(TextEditingController());
              });
            },
            child: Text(
              'Add Activity',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose the Wilaya',
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CustomizedDropDown(
            placeTypes: _wilayas,
            selectedPlaceType: _selectedWilaya,
            onChanged: (value) {
              setState(() {
                _selectedWilaya = value;
              });
              widget.onWilayaSelected(value);
            },
            hintText: 'Wilaya',
          ),
          const SizedBox(height: 20),
          Text(
            'Seating Capacity',
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CapacitySelector(
            initialCapacity: selectedCapacity,
            onCapacityChanged: (capacity) {
              setState(() {
                selectedCapacity = capacity;
              });
              widget.onCapacityChanged(capacity);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
