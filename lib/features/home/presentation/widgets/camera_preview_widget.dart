import 'package:camera/camera.dart';
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
    setState(() {
      _localCurrentScale = widget.currentScale;
    });
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (widget.pointers != 2) {
      return;
    }

    final newScale = (_localCurrentScale * details.scale).clamp(
      widget.minZoom,
      widget.maxZoom,
    );

    await handleZoomUpdate(
      widget.controller,
      _localCurrentScale,
      widget.minZoom,
      widget.maxZoom,
      _localCurrentScale,
      details,
    );

    setState(() {
      _localCurrentScale = newScale;
    });
  }

  void _onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    handleFocusPoint(widget.controller, details, constraints);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => widget.onPointersDown(),
      onPointerUp: (_) => widget.onPointersUp(),
      child: CameraPreview(
        widget.controller,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  _onViewFinderTap(details, constraints),
            );
          },
        ),
      ),
    );
  }
}
