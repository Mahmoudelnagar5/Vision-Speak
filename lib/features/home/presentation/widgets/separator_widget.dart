import 'package:flutter/material.dart';
import 'package:vision_speak/core/utils/assets.dart';

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(Assets.assetsImagesArrowDown),
    );
  }
}
