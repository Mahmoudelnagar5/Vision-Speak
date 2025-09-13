import 'package:flutter/material.dart';
import 'package:vision_speak/features/home/presentation/widgets/audio_playback_widget.dart';
import 'package:vision_speak/features/home/presentation/widgets/header_widget.dart';
import 'package:vision_speak/features/home/presentation/widgets/image_display_widget.dart';
import 'package:vision_speak/features/home/presentation/widgets/separator_widget.dart';
import 'package:vision_speak/features/home/presentation/widgets/text_display_widget.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String? imagePath;
  final String extractedText;
  final VoidCallback onTakeAnotherPhoto;

  const ImagePreviewWidget({
    super.key,
    required this.imagePath,
    required this.extractedText,
    required this.onTakeAnotherPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark gray background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderWidget(),
                ImageDisplayWidget(imagePath: imagePath),

                const SizedBox(height: 16),

                TextDisplayWidget(extractedText: extractedText),

                const SizedBox(height: 15),

                const SeparatorWidget(),

                const SizedBox(height: 15),

                AudioPlaybackWidget(
                  extractedText: extractedText,
                  textToSpeak: extractedText,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTakeAnotherPhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Take another Photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
