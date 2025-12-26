import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';

class SuccessPage extends StatefulWidget {
  final String message;
  final String appbarTitle;
  final VoidCallback? onBackPressed;

  const SuccessPage({
    super.key,
    required this.message,
    this.onBackPressed,
    required this.appbarTitle,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int particleCount = 8;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      particleCount,
          (index) => AnimationController(
        duration: Duration(milliseconds: 1500 + (index * 150)),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.appbarTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isTablet ? 22.sp : 20.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxStackSize = isTablet ? 300 : 350.w;
                      return SizedBox(
                        width: maxStackSize,
                        height: maxStackSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ...List.generate(particleCount, (index) {
                              return AnimatedBuilder(
                                animation: _animations[index],
                                builder: (context, child) {
                                  final angle = (2 * math.pi / particleCount) * index;
                                  final distance = (maxStackSize / 3.5) + (_animations[index].value * (isTablet ? 40 : 30.w));
                                  final size = (isTablet ? 12 : 15.w) + (_animations[index].value * 8);

                                  return Transform.translate(
                                    offset: Offset(
                                      math.cos(angle) * distance,
                                      math.sin(angle) * distance,
                                    ),
                                    child: Container(
                                      width: size,
                                      height: size,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                            Container(
                              width: isTablet ? 120 : 140.w,
                              height: isTablet ? 120 : 140.w,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: isTablet ? 60 : 70.w,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 18.sp : 18.sp,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 60.h),
                  SizedBox(
                    width: isTablet ? 300 : 272.w,
                    height: isTablet ? 55 : 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onBackPressed != null) {
                          widget.onBackPressed!();
                        } else {
                          context.go(Routes.home);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Back to menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 16.sp : 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}