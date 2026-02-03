import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/appbar_widgets.dart';
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
  bool hasLocation = false;
  String? savedAddress;

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
      setState(() {
        hasLocation = true;
        savedAddress = address;
      });
      if (mounted) {
        _showLocationConfirmDialog(address);
      }
    } else {
      setState(() {
        hasLocation = false;
        savedAddress = null;
      });
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
                color: Colors.black.withAlpha(26),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
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
                      ? AppColors.textColor.withAlpha(26)
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
                      ? AppColors.white.withAlpha(179)
                      : AppColors.textColor.withAlpha(179),
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
                              ? AppColors.white.withAlpha(77)
                              : AppColors.textColor.withAlpha(77),
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
                  // Location Banner (faqat delivery tanlangan va location yo'q bo'lsa)
                  if (!hasLocation)
                    Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(77),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(51),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_off,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Joylashuv tanlanmagan",
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.textColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Yetkazib berish uchun manzilni tanlang",
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.white.withAlpha(179)
                                        : AppColors.textColor.withAlpha(179),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          ElevatedButton(
                            onPressed: () {
                              context.push(Routes.location);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Tanlash",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (selectedDeliveryType == 'eat_in')
                    Container(
                      width: double.infinity,
                      height: 160,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.restaurant,
                              size: 120,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.table_restaurant, color: Colors.white, size: 28),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Restoranda tanovul",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Issiqina ovqat va a'lo darajadagi xizmat sizni kutmoqda.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "Stol band qilish shart emas",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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