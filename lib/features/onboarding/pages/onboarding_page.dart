import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get inspired',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Get inspired with our daily recipe recommendations.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Stack(
            children: [
              Image.asset(
                'assets/onboardingImg/onboarding1.png',
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                height: 284.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 610.h,
                left: 110.w,
                child: TextButtonApp(
                  onPressed: () {
                    context.push(Routes.welcome);
                  },
                  width: 207,
                  height: 45,
                  text: 'Continue',
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
