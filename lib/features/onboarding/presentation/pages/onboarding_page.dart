import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/features/onboarding/data/datasources/onboarding_service.dart';

import '../widgets/text_button_app.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ilhom oling',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Har kuni siz uchun tanlangan eng mazali taomlar bilan ilhom oling.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: AppColors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/onboardingImg/onboarding1.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 220.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withAlpha(191),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 27.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButtonApp(
                      onPressed: () async {
                        await OnboardingService.setOnboardingSeen();
                        if (context.mounted) {
                          context.push(Routes.welcome);
                        }
                      },
                      width: 207,
                      height: 45,
                      text: 'Davom etish',
                      textColor: AppColors.white,
                      buttonColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}