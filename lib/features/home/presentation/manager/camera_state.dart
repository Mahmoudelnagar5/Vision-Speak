part of 'camera_cubit.dart';

abstract class CameraState {
  const CameraState();
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraInitializing extends CameraState {
  const CameraInitializing();
}

class CameraInitialized extends CameraState {
  final CameraController controller;
  final double minZoom;
  final double maxZoom;
  final int cameraIndex;

  const CameraInitialized(
    this.controller,
    this.minZoom,
    this.maxZoom,
    this.cameraIndex,
  );

  CameraInitialized copyWith({
    CameraController? controller,
    double? minZoom,
    double? maxZoom,
    int? cameraIndex,
  }) {
    return CameraInitialized(
      controller ?? this.controller,
      minZoom ?? this.minZoom,
      maxZoom ?? this.maxZoom,
      cameraIndex ?? this.cameraIndex,
    );
  }
}

class CameraError extends CameraState {
  final String message;
  const CameraError(this.message);
}

class CameraTakingPicture extends CameraState {
  const CameraTakingPicture();
}

class CameraPictureTaken extends CameraState {
  final XFile image;
  final String extractedText;

  const CameraPictureTaken(this.image, {this.extractedText = ''});

  CameraPictureTaken copyWith({XFile? image, String? extractedText}) {
    return CameraPictureTaken(
      image ?? this.image,
      extractedText: extractedText ?? this.extractedText,
    );
  }
}
