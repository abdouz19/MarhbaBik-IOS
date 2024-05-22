import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCheckbox extends StatefulWidget {
    const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  final bool isChecked;
  final void Function(bool?) onChanged;
  
  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();

}

class _CustomCheckboxState extends State<CustomCheckbox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isChecked,
          onChanged: widget.onChanged,
        ),
        RichText(
          text: TextSpan(
            text: 'I understood the ',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Color(0xff001939),
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'terms & policy.',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xff3F75BB),
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}
