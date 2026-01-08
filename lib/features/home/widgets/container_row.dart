import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';

class CounterRow extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterRow({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: isTablet ? 18.w : 38.w,
            height: isTablet ? 28.h : 38.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: const Icon(Icons.remove, size: 16),
          ),
        ),
        SizedBox(width: isTablet ? 3.w : 5.w),
        Expanded(
          child: Center(
            child: Text(
              "$count",
              style: TextStyle(
                fontSize: isTablet ? 10.sp : 16.sp,
                fontWeight: isTablet ? FontWeight.w400 : FontWeight.w500,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),
        ),
        SizedBox(width: isTablet ? 3.w : 5.w),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: isTablet ? 18.w : 38.w,
            height: isTablet ? 28.h : 38.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: const Icon(Icons.add, size: 16),
          ),
        ),
      ],
    );
  }
}
