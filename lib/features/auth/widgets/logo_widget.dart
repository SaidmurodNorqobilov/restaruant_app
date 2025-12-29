import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/icons.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LogoWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      AppIcons.menu,
      colorFilter: const ColorFilter.mode(
        AppColors.white,
        BlendMode.srcIn,
      ),
      width: 80.w,
      height: 80.h,
    );
  }
}