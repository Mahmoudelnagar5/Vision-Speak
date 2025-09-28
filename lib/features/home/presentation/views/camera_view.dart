import 'package:flutter/material.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import '../widgets/camera_view_body.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkScaffoldBgColor,
      body: const CameraViewBody(),
    );
  }
}
