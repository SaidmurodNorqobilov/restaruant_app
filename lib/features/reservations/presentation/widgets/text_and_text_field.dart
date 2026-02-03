import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';

class TextAndTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const TextAndTextField({
    super.key,
    required this.controller,
    required this.text,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.textColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? Colors.white38
                  : AppColors.borderColor.withOpacity(0.8),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: prefixIcon,
            )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: suffixIcon,
            )
                : null,
            prefixIconConstraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 20.h,
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 20.h,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.black.withAlpha(77)

                : Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.borderColor.withAlpha(51)

                    : AppColors.borderColor.withAlpha(77)
,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.borderColor.withAlpha(51)

                    : AppColors.borderColor.withAlpha(77)
,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 2.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.borderColor.withAlpha(21)

                    : AppColors.borderColor.withAlpha(51)
,
              ),
            ),
            errorStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.red.shade400,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}