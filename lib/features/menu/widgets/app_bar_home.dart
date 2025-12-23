import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/icons.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {

  final Widget title;
  final List<Widget>? actions;
  const AppBarHome({
    super.key, required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.white),

      backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24.sp,
        color: AppColors.white,
      ),
      title: title,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
