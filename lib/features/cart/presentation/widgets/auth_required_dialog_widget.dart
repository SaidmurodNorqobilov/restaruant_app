import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';

class AuthRequiredDialog {
  static void show(BuildContext context, bool isDark) {
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
              horizontal: 24.w,
              vertical: 20.h,
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
                SizedBox(height: 30.h),
                Container(
                  width: 80.w,
                  height: 80.h,
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
                    size: 50.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 30.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    context.translate('register'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.translate('auth_required_before_order'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white.withOpacity(0.8)
                        : AppColors.black.withAlpha(179),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 45.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
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
                        context.push(Routes.login);
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: AppColors.white,
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              context.translate('enter'),
                              style: TextStyle(
                                fontSize: 16.sp,
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
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
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
                            fontSize: 16.sp,
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