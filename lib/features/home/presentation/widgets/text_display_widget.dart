import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  final String extractedText;

  const TextDisplayWidget({super.key, required this.extractedText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // Light gray background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3A3A3A), // Dark gray border
          width: 1,
        ),
      ),
      child: Text(
        extractedText.isEmpty ? 'No text found' : extractedText,
        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
      ),
    );
  }
}
