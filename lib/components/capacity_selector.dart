import 'package:flutter/material.dart';

class CapacitySelector extends StatefulWidget {
  const CapacitySelector(
      {super.key,
      required this.initialCapacity,
      required this.onCapacityChanged,
      this.space = 20,
      this.paddingNumber = 4});

  final int initialCapacity;
  final double? paddingNumber;
  final double? space;
  final void Function(int) onCapacityChanged;

  @override
  State<CapacitySelector> createState() => _CapacitySelectorState();
}

class _CapacitySelectorState extends State<CapacitySelector> {
  late int _capacity;

  @override
  void initState() {
    super.initState();
    _capacity = widget.initialCapacity;
  }

  void _incrementCapacity() {
    setState(() {
      _capacity++;
      widget.onCapacityChanged(_capacity);
    });
  }

  void _decrementCapacity() {
    if (_capacity > 1) {
      setState(() {
        _capacity--;
        widget.onCapacityChanged(_capacity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _decrementCapacity,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffC6C6C6), width: 1),
            ),
            padding: EdgeInsets.all(widget.paddingNumber ?? 4),
            child: const Icon(Icons.remove, color: Color(0xff001939)),
          ),
        ),
        SizedBox(width: widget.space ?? 20),
        Text(
          '$_capacity',
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xff001939),
          ),
        ),
        SizedBox(width: widget.space ?? 20),
        GestureDetector(
          onTap: _incrementCapacity,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffC6C6C6), width: 1),
            ),
            padding: EdgeInsets.all(widget.paddingNumber ?? 4),
            child: const Icon(Icons.add, color: Color(0xff001939)),
          ),
        ),
      ],
    );
  }
}
