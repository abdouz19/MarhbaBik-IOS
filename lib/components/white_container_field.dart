import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final Widget content;

  const CustomContainer({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const[
          BoxShadow(
            color:  Color(0xfff2f2f2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 1), // Even shadow in all directions
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: content,
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}



class DescriptionField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const DescriptionField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: null, // Allow the text field to expand dynamically
      style: const TextStyle(
        fontSize: 16,
        color:  Color(0xff8B8B8B),
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none, // Remove the border
        contentPadding: EdgeInsets.only(bottom: 10), // Adjust content padding
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
