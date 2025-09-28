import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageDisplayWidget extends StatelessWidget {
<<<<<<< HEAD
  final String imagePath;
=======
  final String? imagePath;
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33

  const ImageDisplayWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
<<<<<<< HEAD
      height: 220.h,
=======
      height: 225.h,
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
        child: Image.file(File(imagePath), fit: BoxFit.cover),
=======
        child: Image.file(File(imagePath!), fit: BoxFit.cover),
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33
      ),
    );
  }
}
