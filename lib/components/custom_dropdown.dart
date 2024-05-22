import 'package:flutter/material.dart';

class CustomizedDropDown extends StatefulWidget {
  const CustomizedDropDown({
    super.key,
    required this.placeTypes,
    required this.selectedPlaceType,
    required this.onChanged,
    required this.hintText
  });

  final List<String> placeTypes;
  final String? selectedPlaceType;
  final String hintText;
  final void Function(String?) onChanged;
  @override
  State<CustomizedDropDown> createState() => _CustomizedDropDownState();
}

class _CustomizedDropDownState extends State<CustomizedDropDown> {
  late String? _selectedPlaceType;

  @override
  void initState() {
    super.initState();
    _selectedPlaceType = widget.selectedPlaceType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _selectedPlaceType != null ? Colors.blue : const Color(0xffCCCCCC),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPlaceType,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Color(0xff001939), fontSize: 18),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPlaceType = newValue;
            });
            // Call the onChanged callback here
            widget.onChanged(newValue);
          },

          items: [
            ...widget.placeTypes.map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(value),
                ),
              ),
            ),
          ],
          hint: Text(
            widget.hintText,
            style: TextStyle(
              color: _selectedPlaceType != null
                  ? Colors.blue
                  : const Color(0xffB5B3B3),
            ),
          ),
        ),
      ),
    );
  }
}
