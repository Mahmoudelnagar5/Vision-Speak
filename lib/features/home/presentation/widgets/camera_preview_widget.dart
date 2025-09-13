import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/functions/camera_functions.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraController controller;
  final double currentScale;
  final double baseScale;
  final double minZoom;
  final double maxZoom;
  final int pointers;
  final VoidCallback onPointersDown;
  final VoidCallback onPointersUp;
  final Function(double)? onScaleUpdate;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    required this.currentScale,
    required this.baseScale,
    required this.minZoom,
    required this.maxZoom,
    required this.pointers,
    required this.onPointersDown,
    required this.onPointersUp,
    this.onScaleUpdate,
  });

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  double _localCurrentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _localCurrentScale = widget.currentScale;
  }

  @override
  void didUpdateWidget(covariant CameraPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _localCurrentScale = widget.currentScale;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    debugPrint('Scale start: ${details.pointerCount} pointers');
    setState(() {
      _localCurrentScale = widget.currentScale;
    });
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // Debug: Print pointer and scale information
    debugPrint(
      'Pointers: ${details.pointerCount}, Scale: ${details.scale}, Current: $_localCurrentScale',
    );

    // Only allow zoom when there are exactly 2 pointers (fingers)
    if (details.pointerCount != 2) {
      debugPrint('Zoom blocked: Not exactly 2 pointers');
      return;
    }

    final newScale = (_localCurrentScale * details.scale).clamp(
      widget.minZoom,
      widget.maxZoom,
    );

    // Apply zoom to camera controller
    try {
      await widget.controller.setZoomLevel(newScale);

      // Notify parent widget of the scale update
      widget.onScaleUpdate?.call(newScale);

      setState(() {
        _localCurrentScale = newScale;
      });

      debugPrint('Zoom applied successfully: $newScale');
    } catch (e) {
      // Handle zoom errors gracefully
      debugPrint('Zoom error: $e');
    }
  }

  void _onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    handleFocusPoint(widget.controller, details, constraints);
  }

  @override
  Widget build(BuildContext context) {
    return CameraPreview(
      widget.controller,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: (details) {
              widget.onPointersDown();
              _handleScaleStart(details);
            },
            onScaleUpdate: (details) {
              _handleScaleUpdate(details);
            },
            onScaleEnd: (details) {
              widget.onPointersUp();
            },
            onTapDown: (TapDownDetails details) =>
                _onViewFinderTap(details, constraints),
          );
        },
      ),
    );
  }
}
