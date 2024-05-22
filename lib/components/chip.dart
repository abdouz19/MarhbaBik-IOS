import 'package:flutter/material.dart';

class SimpleChipsInput extends StatefulWidget {
  final List<String> activities;
  final Function(List<String>) onChanged;

  const SimpleChipsInput({required this.activities, required this.onChanged});

  @override
  State<SimpleChipsInput>  createState() => _SimpleChipsInputState();
}

class _SimpleChipsInputState extends State<SimpleChipsInput> {
  final TextEditingController _controller = TextEditingController();
  List<String> _chips = [];

  @override
  void initState() {
    super.initState();
    _chips = widget.activities;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: _chips.map((activity) {
            return Chip(
              label: Text(activity),
              onDeleted: () {
                setState(() {
                  _chips.remove(activity);
                  widget.onChanged(_chips);
                });
              },
            );
          }).toList(),
        ),
        TextField(
          controller: _controller,
          onSubmitted: (value) {
            setState(() {
              _chips.add(value);
              widget.onChanged(_chips);
              _controller.clear();
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none, // Remove the border
          ),
        ),
      ],
    );
  }
}
