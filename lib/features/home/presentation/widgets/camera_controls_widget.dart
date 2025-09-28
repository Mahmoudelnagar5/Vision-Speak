import 'package:flutter/material.dart';

class CameraControlsWidget extends StatelessWidget {
  final VoidCallback onPickFromGallery;
  final VoidCallback onTakePicture;
  final VoidCallback onSwitchCamera;

  const CameraControlsWidget({
    super.key,
    required this.onPickFromGallery,
    required this.onTakePicture,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gallery upload button
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.image, color: Colors.white),
                onPressed: onPickFromGallery,
                iconSize: 24,
              ),
            ),
            const SizedBox(width: 40),
            // Main camera button
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.black),
                onPressed: onTakePicture,
                iconSize: 32,
              ),
            ),
            const SizedBox(width: 40),
            // Camera switch button
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                onPressed: onSwitchCamera,
                iconSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
