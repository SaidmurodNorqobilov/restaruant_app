
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageTitleWidget extends StatelessWidget {
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;

  const PageTitleWidget({
    super.key,
    required this.title,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize ?? 30.sp,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}