import 'package:flutter/material.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import '../widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkScaffoldBgColor,

      body: SplashViewBody(),
    );
  }
}
