import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileItemWidget extends StatelessWidget {
  final String text;
  final String icon;
  final String? iconBack;
  final Color? textColor;
  final ColorFilter? iconColorFilter;
  final VoidCallback onTap;

  const ProfileItemWidget({
    super.key,
    required this.text,
    required this.icon,
    this.iconBack,
    this.iconColorFilter,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.scaleDown,
                  colorFilter: iconColorFilter ??
                      ColorFilter.mode(Theme.of(context).appBarTheme.foregroundColor ?? Colors.black, BlendMode.srcIn),
                ),
                SizedBox(width: 16.w),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: textColor ?? Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
              ],
            ),
            if (iconBack != null)
              SvgPicture.asset(
                iconBack!,
                width: 20.w,
                height: 20.h,
              ),
          ],
        ),
      ),
    );
  }
}
