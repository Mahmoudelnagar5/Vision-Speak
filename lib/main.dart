import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vision_speak/core/routing/app_router.dart';

void main() {
  runApp(const VisionSpeak());
}

class VisionSpeak extends StatelessWidget {
  const VisionSpeak({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: 'Vision Speak',
          theme: ThemeData(primarySwatch: Colors.blue),
        );
      },
    );
  }
}
