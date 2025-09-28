import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/functions/camera_functions.dart';
import '../manager/camera_cubit.dart';
import 'camera_controls_widgets.dart';
import 'image_preview_widget.dart';

class CameraViewBody extends StatefulWidget {
  const CameraViewBody({super.key});

  @override
  State<CameraViewBody> createState() => _CameraViewBodyState();
}

class _CameraViewBodyState extends State<CameraViewBody>
    with WidgetsBindingObserver {
  double _zoomLevel = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final cubit = context.read<CameraCubit>();
    cubit.handleAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCubit>();

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        if (state is CameraInitialized) {
          _minZoom = state.minZoom;
          _maxZoom = state.maxZoom;
          _zoomLevel = (_zoomLevel < _minZoom)
              ? _minZoom
              : (_zoomLevel > _maxZoom)
              ? _maxZoom
              : _zoomLevel;

          return Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onScaleStart: (details) {
                      _baseScale = _zoomLevel;
                    },
                    onScaleUpdate: (details) async {
                      await handleZoomUpdate(
                        state.controller,
                        _zoomLevel,
                        _minZoom,
                        _maxZoom,
                        _baseScale,
                        details,
                      );

                      setState(() {
                        _zoomLevel = (_baseScale * details.scale).clamp(
                          _minZoom,
                          _maxZoom,
                        );
                      });
                    },

                    onTapDown: (TapDownDetails details) => handleFocusPoint(
                      state.controller,
                      details,
                      constraints,
                    ),
                    child: CameraPreview(state.controller),
                  );
                },
              ),
              CameraControlsWidget(
                onTakePicture: () async {
                  await cubit.takePicture();
                },

                onSwitchCamera: () async {
                  await cubit.switchCamera();
                },
                onPickFromGallery: () async {
                  await cubit.pickImageFromGallery();
                },
              ),
            ],
          );
        } else if (state is CameraError) {
          return Center(child: Text('Camera not available: ${state.message}'));
        } else if (state is CameraTakingPicture) {
          return Stack(
            fit: StackFit.expand,
            children: [
              if (cubit.state is CameraInitialized)
                CameraPreview((cubit.state as CameraInitialized).controller),
              const Center(child: CircularProgressIndicator()),
              CameraControlsWidget(
                onPickFromGallery: () async {
                  await cubit.pickImageFromGallery();
                },
                onTakePicture: () async {
                  await cubit.takePicture();
                },
                onSwitchCamera: () async {
                  await cubit.switchCamera();
                },
              ),
            ],
          );
        } else if (state is CameraPictureTaken) {
          return ImagePreviewWidget(
            imagePath: state.image.path,
            extractedText: state.extractedText,
            onTakeAnotherPhoto: () {
              cubit.resetToCameraView();
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
