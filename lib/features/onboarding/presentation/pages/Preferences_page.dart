import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../widgets/text_button_app.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> with TickerProviderStateMixin {
  int selectInd = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> preferences = [
    {
      'title': 'Casual Diner',
      'body': 'Har kungi oddiy va hamyonbop taomlar. Tez va mazali ovqatlar uchun ideal.',
      'icon': Icons.fastfood_rounded,
      'color': Colors.orange,
      'emoji': '🍔',
    },
    {
      'title': 'Food Lover',
      'body': 'Yangi taʼmlar va shahardagi mashhur restoranlarni kashf etishni yoqtiradi.',
      'icon': Icons.restaurant_rounded,
      'color': Colors.red,
      'emoji': '❤️',
    },
    {
      'title': 'Gourmet',
      'body': 'Yuqori sifatli mahsulotlar, noyob menyu va oshpazlar tayyorlagan taomlar.',
      'icon': Icons.local_dining_rounded,
      'color': Colors.purple,
      'emoji': '👨‍🍳',
    },
    {
      'title': 'Fine Dining',
      'body': 'Premium xizmat, hashamatli muhit va jahon darajasidagi taomlar.',
      'icon': Icons.dinner_dining_rounded,
      'color': Colors.amber,
      'emoji': '⭐',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
              AppColors.darkAppBar,
              AppColors.darkAppBar.withOpacity(0.9),
            ]
                : [
              AppColors.white,
              AppColors.primary.withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 32.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Didingizga mos restoranlarni tanlang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                          color: isDark ? AppColors.white : AppColors.textColor,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Yaxshiroq restoran tavsiyalarini olish uchun\no\'zingizga mos variantni tanlang',
                      textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.white.withOpacity(0.7)
                              : AppColors.textColor.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: List.generate(
                    preferences.length,
                        (index) => Expanded(
                      child: Container(
                        height: 4.h,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: index <= selectInd
                              ? AppColors.primary
                              : isDark
                              ? AppColors.white.withOpacity(0.2)
                              : AppColors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: List.generate(preferences.length, (index) {
                        final isSelected = selectInd == index;
                        final pref = preferences[index];

                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectInd = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: double.infinity,
                                padding: EdgeInsets.all(18.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark
                                      ? AppColors.primary.withOpacity(0.15)
                                      : AppColors.primary.withOpacity(0.08))
                                      : (isDark
                                      ? AppColors.white.withOpacity(0.05)
                                      : AppColors.white),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    width: isSelected ? 2.5 : 1.5,
                                    color: isSelected
                                        ? AppColors.primary
                                        : isDark
                                        ? AppColors.white.withOpacity(0.15)
                                        : AppColors.black.withOpacity(0.08),
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? pref['color'].withOpacity(0.2)
                                            : isDark
                                            ? AppColors.white.withOpacity(0.05)
                                            : AppColors.black.withOpacity(0.03),
                                        borderRadius: BorderRadius.circular(14.r),
                                      ),
                                      child: Icon(
                                        pref['icon'],
                                        size: 28.sp,
                                        color: isSelected
                                            ? pref['color']
                                            : isDark
                                            ? AppColors.white.withOpacity(0.6)
                                            : AppColors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                pref['emoji'],
                                                style: TextStyle(fontSize: 18.sp),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  pref['title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.sp,
                                                    color: isDark
                                                        ? AppColors.white
                                                        : AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            pref['body'],
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 1.4,
                                              color: isDark
                                                  ? AppColors.white.withOpacity(0.7)
                                                  : AppColors.textColor.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: 28.w,
                                      height: 28.w,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : isDark
                                              ? AppColors.white.withOpacity(0.3)
                                              : AppColors.black.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Icon(
                                        Icons.check,
                                        size: 16.sp,
                                        color: AppColors.white,
                                      )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.go(Routes.login);
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            height: 56.h,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Davom etish',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.white,
                                  size: 22.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}