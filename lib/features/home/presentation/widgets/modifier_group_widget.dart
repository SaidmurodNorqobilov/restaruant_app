import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../data/models/product_item_model.dart';
import 'modifier_item_widget.dart';
import 'product_section_header.dart';

class ModifierGroupWidget extends StatelessWidget {
  final ProductModifierGroupModel group;
  final bool isDark;
  final bool isProductActive;
  final Map<String, List<ModifiersModel>> selectedModifiers;
  final Function(ProductModifierGroupModel, ModifiersModel) onToggleModifier;

  const ModifierGroupWidget({
    super.key,
    required this.group,
    required this.isDark,
    required this.isProductActive,
    required this.selectedModifiers,
    required this.onToggleModifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductSectionHeader(
          title: group.name,
          icon: Icons.tune,
          isDark: isDark,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            group.maxSelectedAmount == 1
                ? "Bittasini tanlang"
                : "${group.maxSelectedAmount} tagacha tanlashingiz mumkin",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ...group.modifiers.map((modifier) {
          final isSelected =
              selectedModifiers[group.id]?.contains(modifier) ?? false;
          return ModifierItemWidget(
            group: group,
            modifier: modifier,
            isSelected: isSelected,
            isDark: isDark,
            isProductActive: isProductActive,
            onTap: () => onToggleModifier(group, modifier),
          );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }
}