import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../data/models/product_item_model.dart';

class ModifierItemWidget extends StatelessWidget {
  final ProductModifierGroupModel group;
  final ModifiersModel modifier;
  final bool isSelected;
  final bool isDark;
  final bool isProductActive;
  final VoidCallback onTap;

  const ModifierItemWidget({
    super.key,
    required this.group,
    required this.modifier,
    required this.isSelected,
    required this.isDark,
    required this.isProductActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isProductActive ? 1.0 : 0.5,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(5)
              : (isDark ? Colors.grey[900] : Colors.grey[50]),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isProductActive ? onTap : null,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                        width: 2,
                      ),
                      shape: group.maxSelectedAmount == 1
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      borderRadius: group.maxSelectedAmount == 1
                          ? null
                          : BorderRadius.circular(6.r),
                    ),
                    child: isSelected
                        ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Colors.white,
                    )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      modifier.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(isSelected ? 26 : 51),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "+${modifier.price.toStringAsFixed(0)} SO'M",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
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