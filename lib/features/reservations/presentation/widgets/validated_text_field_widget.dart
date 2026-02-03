import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class ValidatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String hintText;
  final String? Function(String)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLines;

  const ValidatedTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.hintText,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  String? errorText;
  bool hasInteracted = false;

  void _validateField() {
    if (widget.validator != null && hasInteracted) {
      setState(() {
        errorText = widget.validator!(widget.controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: widget.controller,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          onChanged: (value) {
            if (hasInteracted) {
              _validateField();
            }
          },
          onTap: () {
            if (!hasInteracted) {
              setState(() {
                hasInteracted = true;
              });
            }
          },
          onEditingComplete: () {
            setState(() {
              hasInteracted = true;
            });
            _validateField();
          },
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.red,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.darkAppBar.withOpacity(0.5)
                : AppColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null
                    ? Colors.red
                    : isDark
                    ? Colors.white24
                    : Colors.black12,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : AppColors.green,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12.r,
              ),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}
