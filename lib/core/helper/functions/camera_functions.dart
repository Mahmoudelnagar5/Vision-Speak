import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Getting available cameras for testing.
@visibleForTesting
List<CameraDescription> get cameras => _cameras;
List<CameraDescription> _cameras = <CameraDescription>[];

/// Initialize camera and get zoom levels
Future<Map<String, dynamic>> initializeCamera() async {
  try {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    if (_cameras.isNotEmpty) {
      final controller = CameraController(
        _cameras.first,
        kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      final minZoom = await controller.getMinZoomLevel();
      final maxZoom = await controller.getMaxZoomLevel();
      return {'controller': controller, 'minZoom': minZoom, 'maxZoom': maxZoom};
    } else {
      throw 'No cameras available';
    }
  } catch (e) {
    rethrow;
  }
}

/// Extract text from image
Future<String> extractTextFromImage(
  String imagePath,
  TextRecognizer textRecognizer,
) async {
  final inputImage = InputImage.fromFilePath(imagePath);
  try {
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    return recognizedText.text;
  } catch (e) {
    return 'Error extracting text: $e';
  }
}

/// Pick image from gallery
Future<String?> pickImageFromGallery() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  return pickedFile?.path;
}

/// Take picture using camera
Future<XFile> takePicture(CameraController controller) async {
  final XFile file = await controller.takePicture();
  return file;
}

/// Get next camera index
int getNextCameraIndex(
  CameraController controller,
  List<CameraDescription> cameras,
) {
  if (cameras.length < 2) return 0;

  final int currentIndex = cameras.indexWhere(
    (camera) => camera.name == controller.description.name,
  );

  return (currentIndex + 1) % cameras.length;
}

/// Set flash mode with error handling
Future<void> setFlashMode(CameraController controller, FlashMode mode) async {
  if (!controller.value.isInitialized) return;

  try {
    await controller.setFlashMode(mode);
  } catch (e) {
    // Silently handle flash mode errors as some devices don't support all modes
    debugPrint('Flash mode not supported: $e');
  }
}

/// Handle camera zoom
Future<void> handleZoomUpdate(
  CameraController controller,
  double currentScale,
  double minZoom,
  double maxZoom,
  double baseScale,
  ScaleUpdateDetails details,
) async {
  final newScale = (baseScale * details.scale).clamp(minZoom, maxZoom);
  await controller.setZoomLevel(newScale);
}

/// Handle focus point setting
void handleFocusPoint(
  CameraController controller,
  TapDownDetails details,
  BoxConstraints constraints,
) {
  if (!controller.value.focusPointSupported) return;

  final Offset offset = Offset(
    details.localPosition.dx / constraints.maxWidth,
    details.localPosition.dy / constraints.maxHeight,
  );

  controller.setFocusPoint(offset).catchError((e) {
    // Some devices may support focus point but not metering areas
    // Silently ignore to prevent app crashes
    debugPrint(
      'Focus point not supported: ${e is CameraException ? e.code : e}',
    );
  });
}

/// Get flash icon based on mode
IconData getFlashIcon(FlashMode flashMode) {
  switch (flashMode) {
    case FlashMode.auto:
      return Icons.flash_auto;
    case FlashMode.always:
      return Icons.flash_on;
    case FlashMode.off:
      return Icons.flash_off;
    case FlashMode.torch:
      return Icons.flashlight_on;
  }
}

/// Cycle through flash modes
Future<void> cycleFlashMode(
  CameraController controller,
  FlashMode currentMode,
  Function setFlashMode,
) async {
  FlashMode nextMode;
  switch (currentMode) {
    case FlashMode.auto:
      nextMode = FlashMode.always;
      break;
    case FlashMode.always:
      nextMode = FlashMode.off;
      break;
    case FlashMode.off:
      nextMode = FlashMode.auto;
      break;
    case FlashMode.torch:
      nextMode = FlashMode.auto;
      break;
  }
  await setFlashMode(nextMode);
}

/// Show snackbar message
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Center(child: Text(message))));
}
