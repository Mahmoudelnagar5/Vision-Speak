import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/views/camera_view.dart';
import '../../features/home/presentation/views/main_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const String splashView = '/';

  static const String mainView = '/mainView';
  static const String cameraView = '/cameraView';

  static final router = GoRouter(
    initialLocation: splashView,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splashView,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SplashView(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: cameraView,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CameraView(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: mainView,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const MainView(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
    ],
  );
}

Widget _transitionsBuilder(context, animation, secondaryAnimation, child) {
  final tween = Tween(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));
  final offsetAnimation = animation.drive(tween);
  return SlideTransition(position: offsetAnimation, child: child);
}
