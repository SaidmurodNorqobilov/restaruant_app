import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/constants/app_icons.dart';

class AppBarWidgets extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidgets({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return AppBar(
      iconTheme: IconThemeData(color: AppColors.white),
      backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
      leading: GestureDetector(
        onTap: (){
          context.pop();
        },
        child: SvgPicture.asset(
          AppIcons.backArrow,
          width: 38.w,
          height: 38.h,
          fit: BoxFit.scaleDown,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: AppColors.white,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
