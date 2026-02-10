import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/constants/app_icons.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/deliveryBloc/delivery_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../core/widgets/appbar_widgets.dart';
import '../../../account/presentation/bloc/locationBloc/location_bloc.dart';
import '../../../account/presentation/bloc/locationBloc/location_state.dart';
import '../bloc/deliveryBloc/delivery_state.dart';
import '../widgets/delevery_type_selection_widget.dart';
import '../widgets/location_selection_sheet.dart';
import '../widgets/order_summary_section_widget.dart';
import '../widgets/payment_method_section.dart';
import '../../data/datasources/order_service.dart';
import '../../data/repositories/order_repository.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedDeliveryType = 'delivery';
  String selectedPaymentMethod = '';
  String? selectedPaymentProvider;
  String? selectedLocationId;
  String? selectedLocationAddress;

  final _formKey = GlobalKey<FormState>();
  late Map<String, double> orderTotals;
  bool isSubmitting = false;

  double get subtotal => orderTotals['product_total'] ?? 0.0;

  double get deliveryFee {
    if (selectedDeliveryType != 'delivery') return 0.0;
    final state = context.read<DeliveryCubit>().state;
    if (state.deliveries.isEmpty) return 0.0;
    final threshold =
        double.tryParse(state.deliveries[0].freeDeliveryThreshold) ?? 0.0;
    if (subtotal >= threshold) return 0.0;
    return double.tryParse(state.deliveries[0].deliveryPrice) ?? 0.0;
  }

  double get total => subtotal + deliveryFee;

  @override
  void initState() {
    super.initState();
    final orderService = OrderService();
    orderTotals = orderService.calculateOrderTotals();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedLocation();
    });
    context.read<MyLocationBloc>().add(MyLocationLoadingEvent());
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? locationId = prefs.getString('selected_location_id');
    final String? address = prefs.getString('selected_location_address');

    if (locationId != null && address != null) {
      setState(() {
        selectedLocationId = locationId;
        selectedLocationAddress = address;
      });
    }
  }

  Future<void> _saveSelectedLocation(String locationId, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_location_id', locationId);
    await prefs.setString('selected_location_address', address);

    setState(() {
      selectedLocationId = locationId;
      selectedLocationAddress = address;
    });
  }

  void _showPaymentProviderSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkAppBar : AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.white.withAlpha(77)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "To'lov tizimini tanlang",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              SizedBox(height: 24.h),
              _buildPaymentProviderOption(
                isDark: isDark,
                provider: 'CLICK',
                title: 'Click',
                icon: Image.asset(
                  AppIcons.click,
                  fit: BoxFit.contain,
                ),
                color: Colors.blue,
              ),
              SizedBox(height: 12.h),
              _buildPaymentProviderOption(
                isDark: isDark,
                provider: 'PAYME',
                title: 'Payme',
                icon: SvgPicture.asset(
                  AppIcons.payme,
                  fit: BoxFit.contain,
                ),
                color: Colors.cyan,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentProviderOption({
    required bool isDark,
    required String provider,
    required String title,
    required Widget icon,
    required Color color,
  }) {
    final isSelected = selectedPaymentProvider == provider;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentProvider = provider;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withAlpha(26)
              : isDark
              ? AppColors.white.withAlpha(13)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(child: icon),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  String _getOrderType() {
    switch (selectedDeliveryType) {
      case 'delivery':
        return 'DELIVERY';
      case 'take_away':
        return 'PICKUP';
      default:
        return 'DELIVERY';
    }
  }

  String _getPaymentMethod() {
    switch (selectedPaymentMethod) {
      case 'cash':
        return 'PAYMENT_CASH';
      case 'card':
        return 'PAYMENT_TERMINAL';
      case 'online':
        return 'PAYMENT_ONLINE';
      default:
        return 'PAYMENT_CASH';
    }
  }

  Future<void> _submitOrder() async {
    if (selectedPaymentMethod.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "To'lov turini tanlang",
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10.r),
        ),
        displayDuration: const Duration(seconds: 2),
      );
      return;
    }

    if (selectedDeliveryType == 'delivery' && selectedLocationId == null) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Yetkazib berish manzilini tanlang",
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10.r),
        ),
        displayDuration: const Duration(seconds: 2),
      );
      return;
    }

    if (selectedPaymentMethod == 'online' && selectedPaymentProvider == null) {
      _showPaymentProviderSheet();
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final orderService = OrderService();
      final orderData = orderService.prepareOrderData(
        orderType: _getOrderType(),
        paymentProvider: selectedPaymentProvider ?? 'CLICK',
        paymentMethod: _getPaymentMethod(),
        address: selectedDeliveryType == 'delivery'
            ? (selectedLocationAddress ?? '')
            : '',
        locationId: selectedDeliveryType == 'delivery'
            ? (selectedLocationId ?? '')
            : '',
      );
      final repository = context.read<OrderRepository>();

      final result = await repository.addOrders(
        orderType: _getOrderType(),
        paymentProvider: selectedPaymentProvider ?? 'CLICK',
        paymentMethod: _getPaymentMethod(),
        address: selectedDeliveryType == 'delivery'
            ? (selectedLocationAddress ?? '')
            : '',
        locationId: selectedDeliveryType == 'delivery'
            ? (selectedLocationId ?? '')
            : '',
        products: orderData['products'] ?? [],
        modifiers: orderData['modifiers'] ?? [],
      );

      if (!mounted) return;

      result.fold(
        (error) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: "Xatolik yuz berdi",
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(10.r),
            ),
            displayDuration: const Duration(seconds: 2),
          );
        },
        (data) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Buyurtma muvaffaqiyatli yaratildi",
              backgroundColor: Colors.green,
              borderRadius: BorderRadius.circular(10.r),
            ),
            displayDuration: const Duration(seconds: 2),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.push(Routes.orders);
            }
          });
        },
      );
    } catch (e) {
      if (!mounted) return;

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Xatolik yuz berdi",
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10.r),
        ),
        displayDuration: const Duration(seconds: 2),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidgets(title: "Checkout"),
      body: BlocBuilder<MyLocationBloc, MyLocationState>(
        builder: (context, locationState) {
          return Stack(
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
                      if (selectedDeliveryType == 'delivery')
                        GestureDetector(
                          onTap: () {
                            LocationSelectionSheet.show(
                              context: context,
                              state: locationState,
                              initialSelectedId: selectedLocationId,
                              onLocationSelected: (id, address) {
                                setState(() {
                                  selectedLocationId = id;
                                  selectedLocationAddress = address;
                                });
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: selectedLocationId != null
                                  ? AppColors.primary.withAlpha(26)
                                  : AppColors.primary.withAlpha(13),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: selectedLocationId != null
                                    ? AppColors.primary
                                    : AppColors.primary.withAlpha(77),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    color: selectedLocationId != null
                                        ? AppColors.primary
                                        : AppColors.primary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    selectedLocationId != null
                                        ? Icons.location_on
                                        : Icons.location_off,
                                    color: selectedLocationId != null
                                        ? AppColors.white
                                        : AppColors.primary,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedLocationId != null
                                            ? "Yetkazib berish manzili"
                                            : "Manzil tanlanmagan",
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.textColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        selectedLocationAddress ??
                                            "Yetkazib berish uchun manzil tanlang",
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.white.withAlpha(179)
                                              : AppColors.textColor.withAlpha(
                                                  179,
                                                ),
                                          fontSize: 13.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (selectedDeliveryType == 'eat_in')
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.deepOrange.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withAlpha(77),
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
                                  size: 120.sp,
                                  color: Colors.white.withAlpha(51),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.table_restaurant,
                                        color: Colors.white,
                                        size: 28.sp,
                                      ),
                                      SizedBox(width: 10.w),
                                      Flexible(
                                        child: Text(
                                          "Restoranda tanovul",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Issiqina ovqat va a'lo darajadagi xizmat sizni kutmoqda.",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(51),
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    child: Text(
                                      "Stol band qilish shart emas",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                      ),
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
                            if (value != 'delivery') {
                              selectedLocationId = null;
                              selectedLocationAddress = null;
                            }
                            if (value == 'delivery' &&
                                selectedPaymentMethod == 'online') {
                              selectedPaymentMethod = '';
                            }
                            final orderService = OrderService();
                            orderTotals = orderService.calculateOrderTotals();
                          });
                        },
                      ),

                      SizedBox(height: 16.h),

                      BlocBuilder<DeliveryCubit, DeliveryState>(
                        builder: (context, state) => OrderSummarySection(
                          isDark: isDark,
                          subtotal: subtotal,
                          freeDeliveryThreshold: state.deliveries.isNotEmpty
                              ? double.tryParse(
                                      state.deliveries[0].freeDeliveryThreshold,
                                    ) ??
                                    0.0
                              : 0.0,
                          deliveryPrice: state.deliveries.isNotEmpty
                              ? double.tryParse(
                                      state.deliveries[0].deliveryPrice,
                                    ) ??
                                    0.0
                              : 0.0,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      PaymentMethodSection(
                        isDark: isDark,
                        selectedPaymentMethod: selectedPaymentMethod,
                        selectedDeliveryType: selectedDeliveryType,
                        onPaymentMethodChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value;
                            if (value == 'online') {
                              _showPaymentProviderSheet();
                            } else {
                              selectedPaymentProvider = null;
                            }
                          });
                        },
                      ),

                      if (selectedPaymentMethod == 'online' &&
                          selectedPaymentProvider != null)
                        Container(
                          margin: EdgeInsets.only(top: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: selectedPaymentProvider == 'CLICK'
                                ? Colors.blue.withAlpha(26)
                                : Colors.green.withAlpha(26),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: selectedPaymentProvider == 'CLICK'
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedPaymentProvider == 'CLICK'
                                    ? Icons.credit_card
                                    : Icons.payment,
                                color: selectedPaymentProvider == 'CLICK'
                                    ? Colors.blue
                                    : Colors.green,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                "Tanlangan: ${selectedPaymentProvider == 'CLICK' ? 'Click' : 'Payme'}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textColor,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _showPaymentProviderSheet,
                                child: Text(
                                  "O'zgartirish",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkAppBar : AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jami:",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textColor,
                              ),
                            ),
                            Text(
                              "${total.toStringAsFixed(0)} so'm",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _submitOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: isSubmitting
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Buyurtma berish",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (isSubmitting)
                Container(
                  color: Colors.black.withAlpha(128),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
