import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/features/cart/data/datasources/cart_service.dart';
import 'package:restaurantapp/features/cart/data/datasources/order_service.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/orderBLoc/orders_bloc.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/orderBLoc/orders_state.dart';
import '../../../../../core/utils/status.dart';
import '../bloc/deliveryBloc/delivery_cubit.dart';
import '../bloc/deliveryBloc/delivery_state.dart';

class CheckoutBottomBar extends StatefulWidget {
  final String selectedDeliveryType;
  final bool isDark;
  final double total;
  final String selectedPaymentMethod;
  final GlobalKey<FormState> formKey;
  final String? selectedLocationId;
  final String? selectedLocationAddress;

  const CheckoutBottomBar({
    super.key,
    required this.selectedDeliveryType,
    required this.isDark,
    required this.total,
    required this.selectedPaymentMethod,
    required this.formKey,
    this.selectedLocationId,
    this.selectedLocationAddress,
  });

  @override
  State<CheckoutBottomBar> createState() => _CheckoutBottomBarState();
}

class _CheckoutBottomBarState extends State<CheckoutBottomBar> {
  bool _isProcessing = false;

  void _handleCheckout(BuildContext context,
      double finalCalculatedTotal) async {
    if (_isProcessing) return;
    if (!widget.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Text('Iltimos, barcha maydonlarni to\'ldiring'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }
    if (widget.selectedDeliveryType == 'delivery') {
      if (widget.selectedLocationId == null ||
          widget.selectedLocationAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.location_off, color: Colors.white),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text('Iltimos, yetkazib berish manzilini tanlang'),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
        return;
      }
    }
    final cartService = CartService();
    final cartItems = cartService.getAllItems();

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.shopping_cart_outlined, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Text('Savatingiz bo\'sh'),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) =>
          PopScope(
            canPop: false,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.darkAppBar : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16.h),
                    Text(
                      'Buyurtma tayyorlanmoqda...',
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    try {
      final orderService = OrderService();
      String address = '';
      String locationId = '';

      if (widget.selectedDeliveryType == 'delivery') {
        address = widget.selectedLocationAddress ?? '';
        locationId = widget.selectedLocationId ?? '';
      } else if (widget.selectedDeliveryType == 'eat_in') {
        address = 'Restaurant - Dine In';
        locationId = 'restaurant_location';
      } else if (widget.selectedDeliveryType == 'take_away') {
        address = 'Restaurant - Take Away';
        locationId = 'restaurant_location';
      }

      final orderData = orderService.prepareOrderData(
        orderType: widget.selectedDeliveryType,
        paymentProvider: widget.selectedPaymentMethod,
        paymentMethod: widget.selectedPaymentMethod,
        address: address,
        locationId: locationId,
      );

      if (!mounted) return;
      context.read<OrdersBloc>().add(AddOrderEvent(orderData: orderData));
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12.w),
                Expanded(child: Text('Xatolik')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          PopScope(
            canPop: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              backgroundColor: widget.isDark ? AppColors.darkAppBar : Colors
                  .white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 50.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Buyurtma qabul qilindi!',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Buyurtmangiz muvaffaqiyatli qabul qilindi. Tez orada sizga yetkaziladi.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: widget.isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            context.go('/');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            'Bosh sahifa',
                            style: TextStyle(
                              color: AppColors.primary,
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
                            Navigator.pop(dialogContext);
                            context.go(Routes.orders);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            'Buyurtmalarim',
                            style: TextStyle(
                              color: Colors.white,
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
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.status == Status.success) {
          setState(() {
            _isProcessing = false;
          });
          Navigator.pop(context);
          final cartService = CartService();
          cartService.clearCart();
          _showSuccessDialog(context);
        } else if (state.status == Status.error) {
          setState(() {
            _isProcessing = false;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xatolik yuz berdi'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      },
      child: BlocBuilder<DeliveryCubit, DeliveryState>(
        builder: (context, deliveryState) {
          double currentDeliveryFee = 0;
          double subtotal = CartService().getTotalPrice();

          if (widget.selectedDeliveryType == 'delivery' &&
              deliveryState.status == Status.success &&
              deliveryState.deliveries.isNotEmpty) {
            final deliveryInfo = deliveryState.deliveries.first;
            final threshold = double.tryParse(
                deliveryInfo.freeDeliveryThreshold) ?? 0;
            final price = double.tryParse(deliveryInfo.deliveryPrice) ?? 0;

            if (subtotal < threshold) {
              currentDeliveryFee = price;
            }
          }

          final finalTotal = subtotal + currentDeliveryFee;

          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.darkAppBar : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jami to\'lov:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: widget.isDark ? Colors.white70 : Colors
                                    .black54,
                              ),
                            ),
                            if (widget.selectedDeliveryType == 'delivery' &&
                                currentDeliveryFee == 0)
                              Text(
                                "Bepul yetkazib berish",
                                style: TextStyle(color: Colors.green,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                          ],
                        ),
                        Text(
                          '${finalTotal.toStringAsFixed(0)} SO\'M',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : () =>
                            _handleCheckout(context, finalTotal),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isProcessing
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isProcessing)
                              SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 22.sp,
                              ),
                            SizedBox(width: 8.w),
                            Text(
                              _isProcessing
                                  ? 'Yuborilmoqda...'
                                  : 'Buyurtmani tasdiqlash',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}