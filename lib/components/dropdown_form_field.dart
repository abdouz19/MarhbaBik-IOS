import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/data/constant_data.dart';

class WilayaDropdown extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onWilayaSelected;
  final String? initialText;

  const WilayaDropdown({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.onChanged,
    required this.onWilayaSelected,
    this.initialText,
  });

  @override
  State<WilayaDropdown> createState() => _WilayaDropdownState();
}

class _WilayaDropdownState extends State<WilayaDropdown> {
  String? _selectedWilaya;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _selectedWilaya = widget.initialText;
      widget.controller?.text = widget.initialText!;
    }
  }

    @override
  void didUpdateWidget(WilayaDropdown oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.initialText?.toLowerCase() != oldWidget.initialText?.toLowerCase()) {
    setState(() {
      _selectedWilaya = widget.initialText;
      widget.controller?.text = widget.initialText!;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            widget.labelText ?? 'Select Wilaya',
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Color(0xff6F6F6F),
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          validator: widget.validator != null ? (v) => widget.validator!(v) : null,
          value: _selectedWilaya,
          onChanged: (newValue) {
            setState(() {
              _selectedWilaya = newValue;
            });
            widget.onWilayaSelected?.call(newValue); // Call the callback function
            widget.onChanged?.call(newValue);
          },
          items: wilayaNames.map<DropdownMenuItem<String>>((String wilayaName) {
            return DropdownMenuItem<String>(
              value: wilayaName,
              child: Text(wilayaName),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            hintText: widget.hintText ?? 'Select Wilaya',
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF888888),
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.only(left: 20),
          ),
        ),

      ],
    );
  }
}
