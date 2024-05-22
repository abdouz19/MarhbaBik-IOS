import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomizedTextFormField extends StatefulWidget {
  const CustomizedTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
    required this.textEditingController,
    this.keyboardType,
    this.isPassword = false,
    required this.validator,
    this.initialText,
  });

  final String label;
  final String hintText;
  final IconData? icon;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final String? initialText;

  @override
  State<CustomizedTextFormField>  createState() => _CustomizedTextFormFieldState();
}

class _CustomizedTextFormFieldState extends State<CustomizedTextFormField> {
  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      widget.textEditingController.text = widget.initialText!;
    }
  }

  @override
  void didUpdateWidget(CustomizedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText) {
      widget.textEditingController.text = widget.initialText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            widget.label,
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
        TextFormField(
          validator: widget.validator,
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword, // obscureText to true if it's a password field
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF888888),
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Icon(widget.icon),
            contentPadding: const EdgeInsets.only(left: 20),
          ),
        ),
      ],
    );
  }
}
