import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';

class ReservationInfoRow extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String value;

  const ReservationInfoRow({
    super.key,
    required this.isDark,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: AppColors.primary.withAlpha(179),
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.white.withAlpha(153)
                : AppColors.textColor.withAlpha(153),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
