import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import '../manager/camera_cubit.dart';
import '../manager/settings_cubit.dart';
import '../widgets/camera_view_body.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit()),
        BlocProvider(
          create: (context) =>
              CameraCubit(BlocProvider.of<SettingsCubit>(context)),
        ),
      ],
      child: const Scaffold(
        backgroundColor: AppColors.darkScaffoldBgColor,
        body: CameraViewBody(),
      ),
    );
  }
}
