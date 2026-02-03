import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';

class ProductSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const ProductSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
      ],
    );
  }
}