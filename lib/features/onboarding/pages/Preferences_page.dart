import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  int selectInd = 0;

  List text = [
    'Casual Diner',
    'Food Lover',
    'Gourmet',
    'Fine Dining',
  ];

  List textBody = [
    'Simple and affordable meals for everyday dining. Perfect for quick and tasty food.',
    'Enjoys discovering new flavors and popular restaurants around the city.',
    'Prefers high-quality ingredients, unique menus, and chef-crafted dishes.',
    'Luxury dining experience with premium service and world-class cuisine.',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.backgroundLightColor,
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 36.w, vertical: 50.h),
        child: Column(
          spacing: 20.h,
          children: [
            SizedBox(),
            Text(
              'What type of restaurants do you prefer?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
            Text(
              'Select your preference to get better restaurant recommendations.',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
            Column(
              spacing: 20.h,
              children: [
                ...List.generate(text.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectInd = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      width: 356.w,
                      height: 116.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectInd == index
                              ? AppColors.primary
                              : AppColors.black,
                        ),
                        borderRadius: BorderRadius.circular(17.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            text[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                          Text(
                            textBody[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            TextButtonApp(
              onPressed: () {
                context.go(Routes.login);
              },
              text: 'Continue',
              textColor: AppColors.white,
              buttonColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
