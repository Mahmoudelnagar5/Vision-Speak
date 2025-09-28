import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/text_extraction_service.dart';
import '../manager/settings_cubit.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  // Store available cameras
  List<CameraDescription> _cameras = [];
  late CameraController _controller;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  int _currentCameraIndex = 0;

  final SettingsCubit settingsCubit;

  // Text extraction service
  final TextExtractionService _textExtractionService = TextExtractionService();

  CameraCubit(this.settingsCubit) : super(const CameraInitial()) {
    initializeCameras();
  }

  // Initialize cameras list
  Future<void> initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await initializeCamera();
      } else {
        emit(const CameraError('No cameras available'));
      }
    } catch (e) {
      log('Error initializing cameras: $e');
      emit(CameraError('Failed to initialize cameras: $e'));
    }
  }

  // Initialize camera controller
  Future<void> initializeCamera() async {
    if (_cameras.isEmpty) return;

    emit(const CameraInitializing());

    try {
      // Dispose previous controller if exists
      await _controller.dispose();
    } catch (_) {}

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      _minZoom = await _controller.getMinZoomLevel();
      _maxZoom = await _controller.getMaxZoomLevel();

      emit(
        CameraInitialized(_controller, _minZoom, _maxZoom, _currentCameraIndex),
      );
    } catch (e) {
      log('Error initializing camera: $e');
      emit(CameraError('Failed to initialize camera: $e'));
    }
  }

  // Switch camera
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await initializeCamera();
  }

  // Take picture

  Future<XFile?> takePicture() async {
    if (state is! CameraInitialized) return null;

    emit(const CameraTakingPicture());

    try {
      final XFile image = await _controller.takePicture();

      // Extract text from the captured image
      final String extractedText = await _textExtractionService
          .extractTextFromXFile(image, lang: settingsCubit.state.ocrLanguage);
      debugPrint('Extracted Text: $extractedText');

      emit(CameraPictureTaken(image, extractedText: extractedText));
      return image;
    } catch (e) {
      log('Error taking picture: $e');
      emit(const CameraError('Failed to take picture'));
      return null;
    }
  }

  // Set zoom level
  Future<void> setZoomLevel(double zoom) async {
    if (state is! CameraInitialized) return;

    try {
      final clampedZoom = zoom.clamp(_minZoom, _maxZoom);
      await _controller.setZoomLevel(clampedZoom);
    } catch (e) {
      log('Error setting zoom: $e');
    }
  }

  // Set focus point
  Future<void> setFocusPoint(Offset offset) async {
    if (state is! CameraInitialized) return;

    try {
      await _controller.setFocusPoint(offset);
    } catch (e) {
      log('Focus point not supported: $e');
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    // Show loading state while picker is opening
    emit(const CameraTakingPicture());
    debugPrint('Started gallery picker');

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        debugPrint('Image picked from gallery: ${pickedFile.path}');

        // Keep showing loading state during OCR processing
        final String extractedText = await _textExtractionService
            .extractTextFromXFile(
              pickedFile,
              lang: settingsCubit.state.ocrLanguage,
            );
        debugPrint('Extracted Text: $extractedText');

        // Emit the final state with image and text
        emit(CameraPictureTaken(pickedFile, extractedText: extractedText));
      } else {
        debugPrint('User cancelled gallery picker');
        // Return to camera view
        emit(
          CameraInitialized(
            _controller,
            _minZoom,
            _maxZoom,
            _currentCameraIndex,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in pickImageFromGallery: $e');
      log('Error picking image: $e');
      emit(const CameraError('Failed to pick image'));
    }
  }

  // Handle app lifecycle changes
  Future<void> handleAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      await _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize camera when app is resumed
      await initializeCamera();
    }
  }

  // Reset to camera view after showing image preview
  Future<void> resetToCameraView() async {
    if (_cameras.isNotEmpty) {
      await initializeCamera();
    }
  }

  @override
  Future<void> close() {
    _controller.dispose();
    _textExtractionService.dispose();
    return super.close();
  }
}
