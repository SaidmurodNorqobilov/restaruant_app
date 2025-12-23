import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import '../../../core/utils/colors.dart';

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
        duration: Duration(milliseconds: 2000 + (index * 200)),
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
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double stackSize = constraints.maxWidth > 400.w ? 350.w : constraints.maxWidth;
                    return SizedBox(
                      width: stackSize,
                      height: stackSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ...List.generate(particleCount, (index) {
                            return AnimatedBuilder(
                              animation: _animations[index],
                              builder: (context, child) {
                                final angle = (2 * math.pi / particleCount) * index;
                                // Masofani ekran o'lchamiga nisbatan foizda hisoblaymiz
                                final distance = (stackSize / 3.5) + (_animations[index].value * 30.w);
                                final size = 15.w + (_animations[index].value * 10.w);

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
                            width: 140.w,
                            height: 140.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 70.w,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.h),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: 272.w,
                  height: 50.h,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'Back to menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
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
    );
  }
}