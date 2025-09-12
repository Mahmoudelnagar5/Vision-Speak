import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Getting available cameras for testing.
@visibleForTesting
List<CameraDescription> get cameras => _cameras;
List<CameraDescription> _cameras = <CameraDescription>[];

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture = Future.value();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras.first,
          kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
          enableAudio: false,
        );
        _initializeControllerFuture = _controller!.initialize();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError &&
            _controller != null &&
            _controller!.value.isInitialized) {
          return Stack(
            fit: StackFit.expand,
            children: [CameraPreview(_controller!), _buildControlOverlay()],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Camera not available: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildControlOverlay() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_library, color: Colors.white),
              onPressed: _pickImageFromGallery,
              iconSize: 30,
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: _takePicture,
              child: const Icon(Icons.camera),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
              onPressed: _switchCamera,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Handle the picked image (e.g., process for AI, save, etc.)
      _showSnackBar('Image selected: ${pickedFile.path}');
      // Here you can add logic to use the selected image for vision processing
    }
  }

  Future<void> _takePicture() async {
    final CameraController controller = _controller!;
    try {
      final XFile file = await controller.takePicture();
      _showSnackBar('Picture saved to ${file.path}');
      // Here you can add logic to use the taken picture for vision processing
    } on CameraException catch (e) {
      _showSnackBar('Error taking picture: ${e.code}');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    final int currentIndex = _cameras.indexWhere(
      (camera) => camera.name == _controller!.description.name,
    );

    final int newIndex = (currentIndex + 1) % _cameras.length;
    await _controller!.setDescription(_cameras[newIndex]);
    setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
