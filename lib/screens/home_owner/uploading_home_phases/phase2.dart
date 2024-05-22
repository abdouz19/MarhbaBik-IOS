import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/custom_dropdown.dart';
import 'package:marhba_bik/components/custom_textfield_outlined.dart';
import 'package:marhba_bik/data/constant_data.dart';

class UploadingHomeSecondPhase extends StatefulWidget {
  final Function(String?) onPlaceTypeSelected;
  final Function(String?) onWilayaSelected;
  final Function(int) onCapacityChanged;
  final Function(String) onAddressChanged;

  const UploadingHomeSecondPhase({
    super.key,
    required this.onPlaceTypeSelected,
    required this.onWilayaSelected,
    required this.onCapacityChanged,
    required this.onAddressChanged,
  });

  @override
  State<UploadingHomeSecondPhase> createState() =>
      _UploadingHomeSecondPhaseState();
}

class _UploadingHomeSecondPhaseState extends State<UploadingHomeSecondPhase> {
  String? _selectedPlaceType;
  String? _selectedWilaya;
  int selectedCapacity = 1;
  String addressValue = '';
  TextEditingController addressValueController = TextEditingController();


  bool validateInputs() {
    if (_selectedPlaceType == null ||
        _selectedWilaya == null ||
        addressValue.isEmpty ||
        selectedCapacity == 0) {
      return false;
    }
    return true;
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
              color:const Color(0xff001939),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Please specify the place type',
            style: GoogleFonts.lato(
              color:const Color(0xff001939),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CustomizedDropDown(
            placeTypes: placeTypes,
            selectedPlaceType: _selectedPlaceType,
            onChanged: (value) {
              setState(() {
                _selectedPlaceType = value;
              });
              widget.onPlaceTypeSelected(value);
            },
            hintText: 'Place type',
          ),
          const SizedBox(height: 20),
          Text(
            'Choose the Wilaya',
            style: GoogleFonts.lato(
              color:const Color(0xff001939),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CustomizedDropDown(
            placeTypes: wilayaNames,
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
            'The exact address',
            style: GoogleFonts.lato(
              color:const Color(0xff001939),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextFieldContainer(
            controller: addressValueController,
            height: 50,
            hintText: 'Example: Street 18, Ain Bessam, Bouira',
            onChanged: (value) {
              setState(() {
                addressValue = value;
              });
              widget.onAddressChanged(value);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Capacity',
            style: GoogleFonts.lato(
              color:const Color(0xff001939),
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
