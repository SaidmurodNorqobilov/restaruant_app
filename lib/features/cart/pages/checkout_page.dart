import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/checkout_bottom_bar_widget.dart';
import '../widgets/customer_info_section_widget.dart';
import '../widgets/delevery_type_selection_widget.dart';
import '../widgets/order_summary_section_widget.dart';
import '../widgets/payment_method_section.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedDeliveryType = 'delivery';
  String selectedPaymentMethod = 'card';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController tableNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final double subtotal = 120.00;
  final double deliveryFee = 15.00;
  final double tax = 18.00;

  double get total => subtotal + deliveryFee + tax;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSavedLocationOnStart();
    });
  }

  Future<void> _checkSavedLocationOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? address = prefs.getString('saved_address');

    if (address != null && address.isNotEmpty) {
      if (mounted) {
        _showLocationConfirmDialog(address);
      }
    } else {
      if (selectedDeliveryType == 'delivery' && mounted) {
        context.push(Routes.location);
      }
    }
  }

  void _showLocationConfirmDialog(String address) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkAppBar : AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 30.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Manzilni tasdiqlang",
                style: TextStyle(
                  color: isDark ? AppColors.white : AppColors.textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textColor.withOpacity(0.1)
                      : AppColors.borderColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(
                          color: isDark ? AppColors.white : AppColors.textColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                "Manzilni o'zgartirishni xohlaysizmi?",
                style: TextStyle(
                  color: isDark
                      ? AppColors.white.withOpacity(0.7)
                      : AppColors.textColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.white.withOpacity(0.3)
                              : AppColors.textColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Yo'q, qolsin",
                        style: TextStyle(
                          color: isDark ? AppColors.white : AppColors.textColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) {
                            context.push(Routes.location);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "O'zgartirish",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    tableNumberController.dispose();
    super.dispose();
  }

  bool get showDeliveryFields => selectedDeliveryType == 'delivery';

  bool get showTableField =>
      selectedDeliveryType == 'eat_in' || selectedDeliveryType == 'take_away';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: "Checkout"),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 140.h,
                top: 16.h,
                right: 16.w,
                left: 16.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DeliveryTypeSection(
                    isDark: isDark,
                    selectedDeliveryType: selectedDeliveryType,
                    onDeliveryTypeChanged: (value) {
                      setState(() {
                        selectedDeliveryType = value;
                        if (value == 'delivery' &&
                            selectedPaymentMethod == 'online') {
                          selectedPaymentMethod = 'cash';
                        }
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  OrderSummarySection(
                    isDark: isDark,
                    subtotal: subtotal,
                    deliveryFee: deliveryFee,
                    tax: tax,
                    total: total,
                  ),
                  SizedBox(height: 16.h),
                  PaymentMethodSection(
                    isDark: isDark,
                    selectedPaymentMethod: selectedPaymentMethod,
                    selectedDeliveryType: selectedDeliveryType,
                    onPaymentMethodChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomerInfoSection(
                    isDark: isDark,
                    showDeliveryFields: showDeliveryFields,
                    showTableField: showTableField,
                    nameController: nameController,
                    phoneController: phoneController,
                    locationController: locationController,
                    tableNumberController: tableNumberController,
                  ),
                  SizedBox(height: 46.h),
                ],
              ),
            ),
          ),
          CheckoutBottomBar(
            selectedDeliveryType: selectedDeliveryType,
            isDark: isDark,
            total: total,
            selectedPaymentMethod: selectedPaymentMethod,
            formKey: _formKey,
          ),
        ],
      ),
    );
  }
}