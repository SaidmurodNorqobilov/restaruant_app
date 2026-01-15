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

  final List<String> titleText = [
    'Casual Diner',
    'Food Lover',
    'Gourmet',
    'Fine Dining',
  ];

  final List<String> bodyText = [
    'Har kungi oddiy va hamyonbop taomlar. Tez va mazali ovqatlar uchun ideal.',
    'Yangi taʼmlar va shahardagi mashhur restoranlarni kashf etishni yoqtiradi.',
    'Yuqori sifatli mahsulotlar, noyob menyu va oshpazlar tayyorlagan taomlar.',
    'Premium xizmat, hashamatli muhit va jahon darajasidagi taomlar.',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'Didingizga mos restoranlarni tanlang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: isDark
                              ? AppColors.white
                              : AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Yaxshiroq restoran tavsiyalarini olish uchun o‘zingizga mos variantni tanlang.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.white.withOpacity(0.8)
                              : AppColors.textColor.withAlpha(179)
,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      ...List.generate(titleText.length, (index) {
                        final isSelected = selectInd == index;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectInd = index;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17.r),
                                border: Border.all(
                                  width: 2,
                                  color: isSelected
                                      ? AppColors.primary
                                      : isDark
                                      ? AppColors.white.withAlpha(77)

                                      : AppColors.black.withAlpha(51)
,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titleText[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    bodyText[index],
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: isDark
                                          ? AppColors.white.withOpacity(0.8)
                                          : AppColors.textColor.withAlpha(179)
,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextButtonApp(
                width: 403,
                height: 50,
                onPressed: () {
                  context.go(Routes.login);
                },
                text: 'Davom etish',
                textColor: AppColors.white,
                buttonColor: AppColors.primary,
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
