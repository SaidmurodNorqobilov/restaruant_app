import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import '../../../core/utils/colors.dart';

class TemporarilyReservation extends StatelessWidget {
  const TemporarilyReservation({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: DrawerWidgets(),
      appBar: AppBarHome(title: Text(context.translate('reservation'))),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event_busy_rounded,
                  size: 60.sp,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 32.h),
              Text(
                context.translate('Vaqtinchalik mavjud emas'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),

              SizedBox(height: 16.h),
              SizedBox(height: 48.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFeatureCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Bron vaqti',
                    isDark: isDark,
                  ),
                  SizedBox(width: 16.w),
                  _buildFeatureCard(
                    icon: Icons.access_time_rounded,
                    title: 'Vaqtni tanlash',
                    isDark: isDark,
                  ),
                  SizedBox(width: 16.w),
                  _buildFeatureCard(
                    icon: Icons.people_rounded,
                    title: 'Joy soni',
                    isDark: isDark,
                  ),
                ],
              ),

              SizedBox(height: 48.h),

              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              //   decoration: BoxDecoration(
              //     color: isDark
              //         ? AppColors.primary.withOpacity(0.1)
              //         : AppColors.primary.withOpacity(0.05),
              //     borderRadius: BorderRadius.circular(12.r),
              //     border: Border.all(
              //       color: AppColors.primary.withOpacity(0.2),
              //       width: 1,
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.info_outline_rounded,
              //         color: AppColors.primary,
              //         size: 24.sp,
              //       ),
              //       SizedBox(width: 12.w),
              //       Expanded(
              //         child: Text(
              //           "Tez orada",
              //           style: TextStyle(
              //             fontSize: 14.sp,
              //             color: isDark ? Colors.white : AppColors.textColor,
              //             height: 1.4,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: AppColors.primary.withOpacity(0.5),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.textColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
