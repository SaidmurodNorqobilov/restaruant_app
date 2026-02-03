import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_colors.dart';

class QRCashbackDialog {
  static void show({
    required BuildContext context,
    required bool isDark,
    required bool isTablet,
    required dynamic user,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.75,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: isTablet ? 25.h : 20.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Mening QR Kodim',
                    style: TextStyle(
                      fontSize: isTablet ? 28.sp : 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 14.h : 10.h),
                Text(
                  'Kassirga ushbu QR kodni ko\'rsating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 16.sp : 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: isTablet ? 38.h : 30.h),
                Container(
                  padding: EdgeInsets.all(isTablet ? 28.w : 24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(51),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 22.w : 18.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: QrImageView(
                          data: 'USER_${user.id ?? 'unknown'}',
                          version: QrVersions.auto,
                          size: isTablet ? 240 : 250,
                          backgroundColor: AppColors.white,
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.primary,
                          ),
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 28.h : 22.h),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 28.h : 22.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 28.w : 24.w,
                    vertical: isTablet ? 18.h : 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(21),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.primary,
                            size: isTablet ? 26.sp : 22.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Mening balansim',
                            style: TextStyle(
                              fontSize: isTablet ? 16.sp : 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '0 coins',
                        style: TextStyle(
                          fontSize: isTablet ? 32.sp : 28.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 28.h : 22.h),
                Text(
                  'Kassada to\'lov qilgandan keyin\nbu QR kodni ko\'rsating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 17.sp : 15.sp,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isTablet ? 32.h : 26.h),
                Container(
                  padding: EdgeInsets.all(isTablet ? 18.w : 14.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.green.withOpacity(0.15)
                        : Colors.green.withAlpha(21),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.green.withAlpha(77),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green,
                        size: isTablet ? 26.sp : 22.sp,
                      ),
                      SizedBox(width: isTablet ? 14.w : 12.w),
                      Expanded(
                        child: Text(
                          'Har bir xarid uchun 2% cashback coinlar sifatida hisobingizga tushadi',
                          style: TextStyle(
                            fontSize: isTablet ? 15.sp : 13.sp,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 32.h : 26.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Yopish',
                    style: TextStyle(
                      fontSize: isTablet ? 17.sp : 15.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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