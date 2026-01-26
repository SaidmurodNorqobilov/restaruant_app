import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';

class DeliveryTypeSection extends StatelessWidget {
  final bool isDark;
  final String selectedDeliveryType;
  final Function(String) onDeliveryTypeChanged;

  const DeliveryTypeSection({
    super.key,
    required this.isDark,
    required this.selectedDeliveryType,
    required this.onDeliveryTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Buyurtma turi',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _DeliveryChip(
                title: 'Restoranda',
                value: 'eat_in',
                icon: Icons.restaurant,
                isDark: isDark,
                isSelected: selectedDeliveryType == 'eat_in',
                onTap: () => onDeliveryTypeChanged('eat_in'),
              ),
              _DeliveryChip(
                title: 'Yetkazib berish',
                value: 'delivery',
                icon: Icons.delivery_dining,
                isDark: isDark,
                isSelected: selectedDeliveryType == 'delivery',
                onTap: () => onDeliveryTypeChanged('delivery'),
              ),
              _DeliveryChip(
                title: 'Olib ketish',
                value: 'take_away',
                icon: Icons.shopping_bag_outlined,
                isDark: isDark,
                isSelected: selectedDeliveryType == 'take_away',
                onTap: () => onDeliveryTypeChanged('take_away'),
              ),
              _DeliveryChip(
                title: 'Drive Through',
                value: 'drive_through',
                icon: Icons.directions_car,
                isDark: isDark,
                isSelected: selectedDeliveryType == 'drive_through',
                onTap: () => onDeliveryTypeChanged('drive_through'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryChip extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryChip({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(21)
              : (isDark ? AppColors.black.withAlpha(77) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : Colors.grey[600]),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.white : AppColors.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}