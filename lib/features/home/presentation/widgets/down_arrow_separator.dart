import 'package:flutter/material.dart';

class DownArrowSeparator extends StatelessWidget {
  const DownArrowSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
