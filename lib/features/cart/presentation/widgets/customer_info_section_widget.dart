import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../reservations/presentation/widgets/text_and_text_field.dart';

class CustomerInfoSection extends StatefulWidget {
  final bool isDark;
  final bool showDeliveryFields;
  final bool showTableField;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController tableNumberController;

  const CustomerInfoSection({
    super.key,
    required this.isDark,
    required this.showDeliveryFields,
    required this.showTableField,
    required this.nameController,
    required this.phoneController,
    required this.locationController,
    required this.tableNumberController,
  });

  @override
  State<CustomerInfoSection> createState() => _CustomerInfoSectionState();
}

class _CustomerInfoSectionState extends State<CustomerInfoSection> {
  String? savedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString('saved_address');
    if (mounted) {
      setState(() {
        savedAddress = address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkAppBar : Colors.white,
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
                Icons.person_outline,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Ma\'lumotlar',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TextAndTextField(
            controller: widget.nameController,
            text: 'Ism',
            hintText: 'Ismingizni kiriting',
          ),
          SizedBox(height: 16.h),
          TextAndTextField(
            controller: widget.phoneController,
            text: 'Telefon raqam',
            hintText: '+998 __ ___ __ __',
          ),
          if (widget.showDeliveryFields) ...[
            SizedBox(height: 16.h),
            _buildAddressSection(),
          ],
          if (widget.showTableField) ...[
            SizedBox(height: 16.h),
            TextAndTextField(
              controller: widget.tableNumberController,
              text: 'Stol raqami',
              hintText: 'Stol raqamini kiriting',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manzil',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: widget.isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        if (savedAddress != null && savedAddress!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? AppColors.textColor.withOpacity(0.1)
                  : AppColors.borderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    savedAddress!,
                    style: TextStyle(
                      color: widget.isDark ? AppColors.white : AppColors.textColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    final result = await context.push(Routes.location);
                    if (result != null && mounted) {
                      _loadSavedAddress();
                    }
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'O\'zgartirish',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          InkWell(
            onTap: () async {
              final result = await context.push(Routes.location);
              if (result != null && mounted) {
                _loadSavedAddress();
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? AppColors.textColor.withOpacity(0.05)
                    : AppColors.borderColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: widget.isDark
                      ? AppColors.white.withOpacity(0.2)
                      : AppColors.textColor.withOpacity(0.2),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_location_alt_outlined,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Manzilni tanlang',
                      style: TextStyle(
                        color: widget.isDark
                            ? AppColors.white.withOpacity(0.6)
                            : AppColors.textColor.withOpacity(0.6),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}