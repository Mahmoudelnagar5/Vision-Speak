import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import '../../../../core/utils/assets.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.darkActiveButtonColor,
      unselectedItemColor: AppColors.darkInactiveButtonColor,
      backgroundColor: AppColors.darkNavBarBgColor,

      selectedIconTheme: IconThemeData(color: AppColors.darkActiveButtonColor),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            Assets.assetsImagesCamera,
            color: AppColors.darkActiveButtonColor,
            width: 35.w,
            height: 35.h,
          ),
          icon: Image.asset(
            Assets.assetsImagesCamera,
            width: 35.w,
            height: 35.h,
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            Assets.assetsImagesCamera,
            color: AppColors.darkActiveButtonColor,
            width: 35.w,
            height: 35.h,
          ),
          icon: Image.asset(
            Assets.assetsImagesTextToAudio,
            width: 35.w,
            height: 35.h,
          ),
          label: 'Text to Audio',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            Assets.assetsImagesCamera,
            color: AppColors.darkActiveButtonColor,
            width: 35.w,
            height: 35.h,
          ),
          icon: Image.asset(
            Assets.assetsImagesSettings,
            width: 35.w,
            height: 35.h,
          ),
          label: 'Settings',
        ),
        // Add more navigation items as needed
      ],
    );
  }
}
