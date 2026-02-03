import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';

import '../../../../core/constants/app_colors.dart';

class LogoutDialog {
  static void show({
    required BuildContext context,
    required bool isDark,
    required bool isTablet,
    required VoidCallback onLogout,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32.w : 24.w,
              vertical: isTablet ? 28.h : 20.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: isTablet ? 35.h : 30.h),
                Container(
                  width: isTablet ? 95.w : 80.w,
                  height: isTablet ? 95.h : 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(51),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: isTablet ? 60.sp : 50.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: isTablet ? 35.h : 30.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    context.translate('exits'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 28.sp : 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 50.h : 45.h),
                Container(
                  width: double.infinity,
                  height: isTablet ? 62.h : 55.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(77),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                        onLogout();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: AppColors.white,
                              size: isTablet ? 26.sp : 22.sp,
                            ),
                            SizedBox(width: isTablet ? 12.w : 10.w),
                            Text(
                              context.translate('exit'),
                              style: TextStyle(
                                fontSize: isTablet ? 18.sp : 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 16.h : 14.h),
                Container(
                  width: double.infinity,
                  height: isTablet ? 62.h : 55.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          context.translate('cancel'),
                          style: TextStyle(
                            fontSize: isTablet ? 18.sp : 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}