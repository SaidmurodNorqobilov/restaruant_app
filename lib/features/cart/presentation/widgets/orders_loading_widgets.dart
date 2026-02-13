import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class OrdersLoadingWidget extends StatelessWidget {
  final bool isDark;

  const OrdersLoadingWidget({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(21),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60.w,
                  height: 60.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Icon(
                  Icons.restaurant_menu,
                  size: 28.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Buyurtmalar yuklanmoqda...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.white.withAlpha(179)
                  : AppColors.black.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersEmptyWidget extends StatelessWidget {
  final bool isDark;

  const OrdersEmptyWidget({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(21),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 60.sp,
              color: AppColors.primary.withAlpha(128),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Buyurtmalar yo'q",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Hozircha buyurtmalaringiz mavjud emas",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}