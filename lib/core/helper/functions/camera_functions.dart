import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

/// Switch between available cameras
Future<void> switchCamera(
  CameraController controller,
  List<CameraDescription> cameras,
) async {
  if (cameras.length < 2) return;

  final int currentIndex = cameras.indexWhere(
    (camera) => camera.name == controller.description.name,
  );

  final int newIndex = (currentIndex + 1) % cameras.length;
  await controller.setDescription(cameras[newIndex]);
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

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
