import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/custom_dropdown.dart';
import 'package:marhba_bik/components/custom_textfield_outlined.dart';
import 'package:marhba_bik/data/constant_data.dart';

class UploadingCarSecondPhase extends StatefulWidget {
  final Function(String) onCarBrandChanged;
  final Function(String?) onWilayaSelected;
  final Function(int) onCapacityChanged;
  final Function(String) onCarModelChanged;

  const UploadingCarSecondPhase({
    super.key,
    required this.onCarBrandChanged,
    required this.onWilayaSelected,
    required this.onCapacityChanged,
    required this.onCarModelChanged,
  });

  @override
  State<UploadingCarSecondPhase> createState() =>
      _UploadingCarSecondPhaseState();
}

class _UploadingCarSecondPhaseState extends State<UploadingCarSecondPhase> {
  String? _selectedWilaya;
  int selectedCapacity = 1;
  String carBrandValue = '';
  String carModelValue = '';
  TextEditingController carBrandController = TextEditingController();
  TextEditingController carModelController = TextEditingController();

  final List<String> _wilayas = wilayaNames;

  bool validateInputs() {
    if (carModelValue.isEmpty ||
        _selectedWilaya == null ||
        carBrandValue.isEmpty ||
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
            'Commençons par les informations essentielles',
            style: GoogleFonts.poppins(
              color: const Color(0xff001939),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"Veuillez spécifier la marque de la voiture',
            style: GoogleFonts.lato(
              color:const Color(0xff001939),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextFieldContainer(
            controller: carBrandController,
            height: 50,
            hintText: 'Exemple: Fiat',
            onChanged: (value) {
              setState(() {
                carBrandValue = value;
              });
              widget.onCarBrandChanged(value); // Corrected here
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Veuillez spécifier le modèle de la voiture',
            style: GoogleFonts.lato(
              color: const Color(0xff001939),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextFieldContainer(
            controller: carModelController,
            height: 50,
            hintText: 'Exemple: Tipo 2023',
            onChanged: (value) {
              setState(() {
                carModelValue = value;
              });
              widget.onCarModelChanged(value);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Choisissez la Wilaya',
            style: GoogleFonts.lato(
              color: const Color(0xff001939),
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
            'Nombre de places',
            style: GoogleFonts.lato(
              color: const Color(0xff001939),
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
