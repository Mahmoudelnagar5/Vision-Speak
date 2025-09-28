import 'package:flutter/material.dart';
import 'package:vision_speak/features/home/presentation/widgets/select_language_widget.dart';

import 'preview_header_widget.dart';
import 'image_display_widget.dart';
import 'extracted_text_widget.dart';
import 'down_arrow_separator.dart';
import 'audio_controls_widget.dart';
import 'action_buttons_widget.dart';

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
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Header
                const PreviewHeaderWidget(),

                // Display the selected photo
                ImageDisplayWidget(imagePath: imagePath!),

                const SizedBox(height: 20),

                // Main content section
                Column(
                  children: [
                    // Language selection dropdown
                    SelectLanguage(),

                    const SizedBox(height: 15),

                    // Extracted text
                    ExtractedTextWidget(extractedText: extractedText),

                    const SizedBox(height: 15),

                    // Down arrow separator
                    const DownArrowSeparator(),

                    const SizedBox(height: 15),

                    // Audio controls with dropdown
                    AudioControlsWidget(extractedText: extractedText),

                    // Audio player controls and main action button
                    ButtonActionWidget(onTakeAnotherPhoto: onTakeAnotherPhoto),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
