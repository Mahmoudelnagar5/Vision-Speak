import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/functions/camera_functions.dart';

class FlashControlsWidget extends StatelessWidget {
  final FlashMode flashMode;
  final VoidCallback onCycleFlashMode;

  const FlashControlsWidget({
    super.key,
    required this.flashMode,
    required this.onCycleFlashMode,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      top: 100,
      child: Column(
        children: [
          // Flash mode button
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(
                getFlashIcon(flashMode),
                color: flashMode == FlashMode.off ? Colors.grey : Colors.white,
              ),
              onPressed: onCycleFlashMode,
              iconSize: 24,
            ),
          ),

          const SizedBox(height: 10),

          // Flash mode indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              flashMode.toString().split('.').last.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
