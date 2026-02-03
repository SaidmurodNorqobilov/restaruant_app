import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final double radius;

  const ProfileAvatarWidget({
    super.key,
    this.imageFile,
    required this.onTap,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        CircleAvatar(
          radius: radius.r,
          backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          child: imageFile == null
              ? Icon(
            Icons.person,
            size: radius.sp,
            color: isDark ? Colors.grey.shade600 : Colors.grey,
          )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.red,
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}