import 'package:flutter/material.dart';

class CustomTextFieldContainer extends StatefulWidget {
  final double? height;
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFieldContainer({
    super.key,
    this.height,
    required this.hintText,
    this.onChanged,
    required this.controller,
    this.validator
  });

  @override
  State<CustomTextFieldContainer> createState() =>
      _CustomTextFieldContainerState();
}

class _CustomTextFieldContainerState extends State<CustomTextFieldContainer> {
  final FocusNode _focusNode = FocusNode();
  
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    widget.controller.addListener(() {
      setState(() {}); // Update state to change border color based on text
      if (widget.onChanged != null) {
        widget.onChanged!(widget.controller.text);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isFocused || widget.controller.text.isNotEmpty
              ? Colors.blue
              : const Color(0xffCCCCCC),
          width: 1,
        ),
      ),
      child: TextFormField(
        validator: widget.validator,
        focusNode: _focusNode,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xffB5B3B3),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
