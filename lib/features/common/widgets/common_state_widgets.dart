import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';

class LoadingState extends StatelessWidget {
  final bool isDark;
  final bool isTablet;
  final IconData icon;
  final String message;

  const LoadingState({
    super.key,
    required this.isDark,
    this.isTablet = false,
    this.icon = Icons.hourglass_empty,
    this.message = 'Ma\'lumotlar yuklanmoqda...',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isTablet ? 50.w : 80.w,
            height: isTablet ? 50.w : 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: isTablet ? 75.w : 60.w,
                  height: isTablet ? 75.w : 60.w,
                  child: CircularProgressIndicator(
                    strokeWidth: isTablet ? 4 : 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  size: isTablet ? 25.sp : 28.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 30.h : 24.h),
          Text(
            message,
            style: TextStyle(
              fontSize: isTablet ? 18.sp : 16.sp,
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

class EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isTablet;
  final IconData icon;
  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const EmptyState({
    super.key,
    required this.isDark,
    required this.onPressed,
    this.isTablet = false,
    this.icon = Icons.inbox_outlined,
    this.title = 'Ma\'lumot topilmadi',
    this.subtitle,
    this.buttonText = 'Orqaga qaytish',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40.w : 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 140.w : 120.w,
              height: isTablet ? 140.w : 120.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withAlpha(26),
                    AppColors.primary.withAlpha(13),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isTablet ? 70.sp : 60.sp,
                color: AppColors.primary.withAlpha(153),
              ),
            ),
            SizedBox(height: isTablet ? 40.h : 32.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 28.sp : 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: isTablet ? 16.h : 12.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 16.sp : 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.white.withAlpha(179)
                      : AppColors.black.withAlpha(153),
                  height: 1.5,
                ),
              ),
            ],
            SizedBox(height: isTablet ? 48.h : 40.h),
            OutlinedButton.icon(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40.w : 32.w,
                  vertical: isTablet ? 18.h : 16.h,
                ),
                side: BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: Icon(
                Icons.arrow_back_rounded,
                size: isTablet ? 24.sp : 20.sp,
                color: AppColors.primary,
              ),
              label: Text(
                buttonText,
                style: TextStyle(
                  fontSize: isTablet ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final bool isDark;
  final bool isTablet;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.isDark,
    required this.onRetry,
    this.isTablet = false,
    this.title = 'Xatolik yuz berdi',
    this.message = 'Ma\'lumotlarni yuklashda muammo yuz berdi.\nKeyinroq qaytadan urinib ko\'ring.',
    this.buttonText = 'Qayta urinish',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40.w : 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 120.w : 100.w,
              height: isTablet ? 120.w : 100.w,
              decoration: BoxDecoration(
                color: AppColors.red.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: isTablet ? 60.sp : 50.sp,
                color: AppColors.red,
              ),
            ),
            SizedBox(height: isTablet ? 30.h : 24.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 24.sp : 20.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            SizedBox(height: isTablet ? 16.h : 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16.sp : 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.white.withAlpha(179)
                    : AppColors.black.withAlpha(153),
                height: 1.5,
              ),
            ),
            SizedBox(height: isTablet ? 40.h : 32.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40.w : 32.w,
                  vertical: isTablet ? 18.h : 16.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              icon: Icon(
                Icons.refresh_rounded,
                size: isTablet ? 24.sp : 20.sp,
                color: AppColors.white,
              ),
              label: Text(
                buttonText,
                style: TextStyle(
                  fontSize: isTablet ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}