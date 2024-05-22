import 'package:flutter/material.dart';

class CapacitySelector extends StatefulWidget {
  const CapacitySelector({super.key, required this.initialCapacity, required this.onCapacityChanged});

  final int initialCapacity;
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
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.remove, color: Color(0xff494949)),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          '$_capacity',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: _incrementCapacity,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffC6C6C6), width: 1),
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.add, color: Color(0xff494949)),
          ),
        ),
      ],
    );
  }
}
