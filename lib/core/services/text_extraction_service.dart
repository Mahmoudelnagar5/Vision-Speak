import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class TextExtractionService {
  /// Extract text from an image file using Tesseract OCR
  Future<String> extractTextFromImage(
    String imagePath, {
    String lang = 'eng',
  }) async {
    try {
      final tesseractConfig = OCRConfig(
        language: lang, // Must match a .traineddata file in assets/tessdata
        engine: OCREngine.tesseract,
        // Optional Tesseract options:
        // options: {
        //   TesseractConfig.preserveInterwordSpaces: '1',
        //   TesseractConfig.pageSegMode: PageSegmentationMode.autoOsd,
        //   TesseractConfig.debugFile: '/path/to/debug.log', // Example option
        // },
      );
      String extractedTextTesseract = await TesseractOcr.extractText(
        imagePath,
        config: tesseractConfig,
      );
      // print('Extracted Text (Tesseract): $extractedTextTesseract');

      // String recognizedText = await FlutterTesseractOcr.extractText(
      //   imagePath,
      //   language: lang,
      // );
      debugPrint('Recognized Text: $extractedTextTesseract');

      return extractedTextTesseract.isEmpty ? '' : extractedTextTesseract;
    } catch (e) {
      // Return empty string on error to prevent crashes
      return '';
    }
  }

  /// Extract text from XFile (camera captured image)
  Future<String> extractTextFromXFile(
    XFile imageFile, {
    String lang = 'eng',
  }) async {
    return extractTextFromImage(imageFile.path, lang: lang);
  }

  /// Dispose of the text recognizer when done
  void dispose() {
    // No need for dispose with Tesseract
  }
}
