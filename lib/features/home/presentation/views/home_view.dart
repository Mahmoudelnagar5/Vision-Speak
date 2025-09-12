import 'package:flutter/material.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import '../widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkScaffoldBgColor,
      body: const HomeViewBody(),
    );
  }
}
