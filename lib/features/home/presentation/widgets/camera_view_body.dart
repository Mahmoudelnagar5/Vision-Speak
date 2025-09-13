import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../../core/helper/functions/camera_functions.dart';
import 'camera_controls_widget.dart';
import 'camera_preview_widget.dart';
import 'flash_controls_widget.dart';
import 'image_preview_widget.dart';

/// Getting available cameras for testing.
@visibleForTesting
List<CameraDescription> get cameras => _cameras;
List<CameraDescription> _cameras = <CameraDescription>[];

class CameraViewBody extends StatefulWidget {
  const CameraViewBody({super.key});

  @override
  State<CameraViewBody> createState() => _CameraViewBodyState();
}

class _CameraViewBodyState extends State<CameraViewBody>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture = Future.value();
  String? imagePath;
  String extractedText = '';
  late final TextRecognizer textRecognizer = TextRecognizer();
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  final double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  // Camera settings
  FlashMode _flashMode = FlashMode.auto;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final result = await initializeCamera();
      if (result['controller'] != null) {
        _controller = result['controller'];
        _minAvailableZoom = result['minZoom'];
        _maxAvailableZoom = result['maxZoom'];
        _currentScale = _minAvailableZoom;
        _initializeControllerFuture = Future.value();
      } else {
        _initializeControllerFuture = Future.error('No cameras available');
      }
    } catch (e) {
      _initializeControllerFuture = Future.error(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    textRecognizer.close();
    super.dispose();
  }

  // Wrapper methods using extracted functions
  Future<void> _onPickFromGallery() async {
    final pickedPath = await pickImageFromGallery();
    if (pickedPath != null) {
      imagePath = pickedPath;
      extractedText = await extractTextFromImage(imagePath!, textRecognizer);
      setState(() {});
    }
  }

  Future<void> _onTakePicture() async {
    if (_controller == null) return;

    try {
      final XFile file = await takePicture(_controller!);
      imagePath = file.path;
      extractedText = await extractTextFromImage(imagePath!, textRecognizer);
      setState(() {});
    } on CameraException catch (e) {
      showSnackBar(context, 'Error taking picture: ${e.code}');
    }
  }

  Future<void> _onSwitchCamera() async {
    if (_controller != null && _cameras.isNotEmpty) {
      try {
        await switchCamera(_controller!, _cameras);
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        showSnackBar(context, 'Error switching camera');
      }
    }
  }

  Future<void> _onCycleFlashMode() async {
    if (_controller != null) {
      await cycleFlashMode(_controller!, _flashMode, _setFlashMode);
    }
  }

  // Helper method for setFlashMode
  Future<void> _setFlashMode(FlashMode mode) async {
    await setFlashMode(_controller!, mode);
    if (mounted) {
      setState(() {
        _flashMode = mode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return ImagePreviewWidget(
        imagePath: imagePath,
        extractedText: extractedText,
        onTakeAnotherPhoto: () {
          imagePath = null;
          extractedText = '';
          setState(() {});
        },
      );
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError &&
            _controller != null &&
            _controller!.value.isInitialized) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreviewWidget(
                controller: _controller!,
                currentScale: _currentScale,
                baseScale: _baseScale,
                minZoom: _minAvailableZoom,
                maxZoom: _maxAvailableZoom,
                pointers: _pointers,
                onPointersDown: () => _pointers++,
                onPointersUp: () => _pointers--,
              ),
              CameraControlsWidget(
                onPickFromGallery: _onPickFromGallery,
                onTakePicture: _onTakePicture,
                onSwitchCamera: _onSwitchCamera,
              ),
              FlashControlsWidget(
                flashMode: _flashMode,
                onCycleFlashMode: _onCycleFlashMode,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Camera not available: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
