import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';

class TextAndTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String? hintText;
  final Widget? prefixIcon;

  const TextAndTextField({
    super.key,
    required this.controller,
    required this.text,
    this.hintText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      spacing: 6.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        TextField(
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w300,
              color: AppColors.borderColor,
            ),
            constraints: BoxConstraints(
              maxWidth: 348.w,
              maxHeight: 43.h,
              minHeight: 43.h,
              minWidth: 348.w,
            ),
            prefixIcon: prefixIcon ?? null,
            // enabledBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(
            //     color: isDark ? Colors.white54 : Colors.grey,
            //   ),
            // ),

            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
