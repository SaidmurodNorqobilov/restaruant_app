import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';

class CustomMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;
  final Color color;
  final bool isTablet;
  final bool isDestructive;

  const CustomMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    required this.color,
    required this.isTablet,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 10.w : 16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? AppColors.borderColor.withAlpha(21)
                : AppColors.borderColor.withAlpha(51),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: isTablet ? 26.w : 48.w,
              height: isTablet ? 26.w : 48.w,
              decoration: BoxDecoration(
                color: color.withAlpha(21),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: isTablet ? 18.sp : 24.sp,
              ),
            ),
            SizedBox(width: isTablet ? 20.w : 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 14.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? AppColors.red
                          : (isDark ? AppColors.white : AppColors.textColor),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isTablet ? 12.sp : 13.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: isTablet ? 15.sp : 18.sp,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}