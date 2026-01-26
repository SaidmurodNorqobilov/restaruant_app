import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/onboarding_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> categoryImg = [
    'assets/onboardingImg/welcome_1.png',
    'assets/onboardingImg/welcome_2.png',
    'assets/onboardingImg/welcome_3.png',
    'assets/onboardingImg/welcome_4.png',
    'assets/onboardingImg/welcome_5.png',
    'assets/onboardingImg/welcome_6.png',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: categoryImg.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                        12.r,
                      ),
                      child: Image.asset(
                        categoryImg[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Xush kelibsiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Eng mazali taomlar bir joyda — buyurtma bering va lazzatdan bahramand bo\'ling.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.white.withOpacity(0.8)
                      : AppColors.black.withAlpha(179)
,
                ),
              ),
              SizedBox(height: 30.h),
              TextButtonApp(
                height: 50,
                onPressed: () {
                  context.go(Routes.preferences);
                },
                text: 'Ro\'yxatdan o\'tish',
                textColor: AppColors.white,
                buttonColor: AppColors.primary,
              ),
              SizedBox(height: 12.h),
              TextButtonApp(
                height: 50,
                onPressed: () async {
                  await OnboardingService.setOnboardingSeen();
                  if (mounted) {
                    context.go(Routes.home);
                  }
                },
                text: 'Keyinroq',
                textColor: AppColors.white,
                buttonColor: AppColors.primary,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
