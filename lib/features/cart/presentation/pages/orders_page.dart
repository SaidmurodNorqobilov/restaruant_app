import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/status.dart';
import '../../../../core/widgets/appbar_widgets.dart';
import '../../../../core/widgets/common_state_widgets.dart';
import '../../../account/presentation/pages/location_page.dart';
import '../../../onboarding/presentation/widgets/text_button_app.dart';
import '../bloc/orderBLoc/orders_bloc.dart';
import '../bloc/orderBLoc/orders_state.dart';
import '../../data/models/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(OrdersLoading());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidgets(
        title: context.translate('orders'),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return _buildLoadingState(isDark);
          }
          if (state.status == Status.error) {
            return ErrorState(
              isDark: isDark,
              onRetry: () {
                context.read<OrdersBloc>().add(OrdersLoading());
              },
            );
          }

          if (state.status == Status.success) {
            if (state.orders.isEmpty) {
              return _buildEmptyState(isDark);
            }
            return _buildOrdersList(state, isDark, isTablet);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(21),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60.w,
                  height: 60.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Icon(
                  Icons.restaurant_menu,
                  size: 28.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Buyurtmalar yuklanmoqda...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.white.withAlpha(179)
                  : AppColors.black.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(21),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 60.sp,
              color: AppColors.primary.withAlpha(128),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Buyurtmalar yo'q",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Hozircha buyurtmalaringiz mavjud emas",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(OrdersState state, bool isDark, bool isTablet) {
    return RefreshIndicator(
      backgroundColor: isDark ? AppColors.darkAppBar : AppColors.white,
      color: AppColors.primary,
      onRefresh: () async {
        context.read<OrdersBloc>().add(OrdersLoading());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.only(
            top: 16.h,
            bottom: MediaQuery.of(context).padding.bottom + 16.h,
          ),
          itemCount: state.orders.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final order = state.orders[index];
            return _buildOrderCard(order, isDark, isTablet);
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isDark, bool isTablet) {
    final canCancel = [
      'NEW',
      'PENDING',
      'CONFIRMED',
    ].contains(order.status.toUpperCase());

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.borderColor.withAlpha(51)
              : AppColors.borderColor.withAlpha(77),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderHeader(order, isDark, isTablet),
          SizedBox(height: 12.h),
          _buildOrderTitle(order, isDark, isTablet),
          SizedBox(height: 8.h),
          _buildOrderTime(order, isDark, isTablet),
          SizedBox(height: 8.h),
          _buildOrderAddress(order, isTablet, isDark),
          SizedBox(height: 12.h),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark
                ? AppColors.borderColor.withAlpha(21)
                : AppColors.borderColor.withAlpha(51),
          ),
          SizedBox(height: 12.h),
          _buildPriceDetails(order, isDark, isTablet),
          SizedBox(height: 12.h),
          _buildOrderFooter(order, isDark, isTablet),

          if (canCancel) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(order, isDark, isTablet),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(
                    color: Colors.red.withAlpha(128),
                    width: 1.5,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.cancel_outlined, size: 18.sp),
                label: Text(
                  'Buyurtmani bekor qilish',
                  style: TextStyle(
                    fontSize: isTablet ? 12.sp : 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderHeader(OrderModel order, bool isDark, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(21),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                order.orderType.toUpperCase() == 'DELIVERY'
                    ? Icons.directions_car_filled
                    : Icons.table_restaurant,
                size: isTablet ? 16.sp : 18.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              order.orderType.toUpperCase() == 'DELIVERY'
                  ? 'Yetkazib berish'
                  : 'Restoranda',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 12.sp : 14.sp,
                color: isDark
                    ? AppColors.white.withAlpha(204)
                    : AppColors.textColor,
              ),
            ),
          ],
        ),
        _buildStatusBadge(order.status, isTablet),
      ],
    );
  }

  Widget _buildStatusBadge(String status, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withAlpha(26),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _getStatusColor(status).withAlpha(51),
          width: 1,
        ),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: isTablet ? 10.sp : 12.sp,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Widget _buildOrderTitle(OrderModel order, bool isDark, bool isTablet) {
    if (order.items.isEmpty) {
      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buyurtma #${order.orderNumber ?? order.id.substring(0, 8)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 12.sp : 18.sp,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Mahsulot yo\'q',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (order.items.length > 1) {
      final totalItems = order.items.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buyurtma #${order.orderNumber ?? order.id.substring(0, 8)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 14.sp : 18.sp,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${order.items.length} xil mahsulot • $totalItems ta',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 10.sp : 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final item = order.items.first;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buyurtma #${order.orderNumber ?? order.id.substring(0, 8)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isTablet ? 14.sp : 18.sp,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                '${item.productName} • ${item.quantity} ta',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? 10.sp : 13.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTime(OrderModel order, bool isDark, bool isTablet) {
    final dateFormat = DateFormat('dd.MM.yyyy, HH:mm');
    final formattedDate = dateFormat.format(order.createdAt);

    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: isTablet ? 12.sp : 14.sp,
          color: Colors.grey[600],
        ),
        SizedBox(width: 6.w),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: isTablet ? 10.sp : 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderAddress(OrderModel order, bool isTablet, bool isDark) {
    // Lat va Lng borligini tekshirish
    final hasCoordinates = order.lat != '0' && order.lng != '0';
    final latitude = double.tryParse(order.lat);
    final longitude = double.tryParse(order.lng);

    return InkWell(
      onTap: hasCoordinates && latitude != null && longitude != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPage(
                    mode: LocationPageMode.view,
                    locationId: order.location?.id,
                    initialTitle: order.location?.title ?? 'Buyurtma manzili',
                    initialAddress: order.address,
                    initialLat: latitude,
                    initialLng: longitude,
                  ),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasCoordinates ? AppColors.primary : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: isTablet ? 14.sp : 16.sp,
              color: hasCoordinates ? AppColors.primary : Colors.grey[600],
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                order.address,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? 10.sp : 13.sp,
                  color: hasCoordinates ? AppColors.primary : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasCoordinates) ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.visibility_outlined,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails(OrderModel order, bool isDark, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Mahsulotlar narxi',
            order.itemsPrice,
            isDark,
            isTablet,
          ),
          SizedBox(height: 6.h),
          _buildPriceRow(
            'Yetkazib berish',
            order.deliveryFee,
            isDark,
            isTablet,
          ),
          if (order.usedCoins != '0') ...[
            SizedBox(height: 6.h),
            _buildPriceRow(
              'Ishlatilgan coinlar',
              '-${order.usedCoins}',
              isDark,
              isTablet,
              valueColor: Colors.green,
            ),
          ],
          SizedBox(height: 8.h),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jami',
                style: TextStyle(
                  fontSize: isTablet ? 13.sp : 15.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              Text(
                '${_formatPrice(order.totalPrice)} UZS',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isTablet ? 15.sp : 17.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    bool isDark,
    bool isTablet, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 11.sp : 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '${_formatPrice(value)} UZS',
          style: TextStyle(
            fontSize: isTablet ? 11.sp : 13.sp,
            fontWeight: FontWeight.w600,
            color:
                valueColor ?? (isDark ? AppColors.white : AppColors.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderFooter(OrderModel order, bool isDark, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPaymentInfo(order, isDark, isTablet),
        if (order.earnedCoins != '0')
          _buildEarnedCoins(order, isDark, isTablet),
      ],
    );
  }

  Widget _buildPaymentInfo(OrderModel order, bool isDark, bool isTablet) {
    final isOnline = order.paymentMethod.toUpperCase() == 'PAYMENT_ONLINE';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To'lov usuli",
          style: TextStyle(
            fontSize: isTablet ? 10.sp : 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(
              isOnline ? Icons.credit_card : Icons.payments_outlined,
              size: isTablet ? 14.sp : 16.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              isOnline ? 'Online' : 'Naqd',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 13.sp : 14.sp,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarnedCoins(OrderModel order, bool isDark, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade400,
            Colors.orange.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.stars_rounded,
            size: isTablet ? 16.sp : 18.sp,
            color: Colors.white,
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ishlab topildi',
                style: TextStyle(
                  fontSize: isTablet ? 9.sp : 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(230),
                ),
              ),
              Text(
                '+${order.earnedCoins} coins',
                style: TextStyle(
                  fontSize: isTablet ? 12.sp : 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OrderModel order, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Icon(
              Icons.warning_amber_rounded,
              size: 48.sp,
              color: AppColors.orange,
            ),
            SizedBox(height: 16.h),
            Text(
              "Buyurtmani bekor qilish",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Buyurtma #${order.orderNumber ?? order.id.substring(0, 8)} ni bekor qilmoqchimisiz?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButtonApp(
                      onPressed: () {
                        Navigator.pop(modalContext);
                      },
                      text: 'Yo\'q',
                      textColor: isDark ? AppColors.white : AppColors.textColor,
                      buttonColor: isDark
                          ? AppColors.darkAppBar
                          : AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextButtonApp(
                    onPressed: () {
                      Navigator.pop(modalContext);
                      // context.read<OrdersBloc>().add(
                      //   CancelOrderEvent(orderId: order.id),
                      // );
                    },
                    text: 'Ha, bekor qilish',
                    textColor: AppColors.white,
                    buttonColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final num = double.parse(price);
      return num.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );
    } catch (e) {
      return price;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return 'Yangi';
      case 'PENDING':
        return 'Kutilmoqda';
      case 'CONFIRMED':
        return 'Tasdiqlandi';
      case 'PREPARING':
        return 'Tayyorlanmoqda';
      case 'READY':
        return 'Tayyor';
      case 'DELIVERED':
        return 'Yetkazildi';
      case 'CANCELLED':
        return 'Bekor qilindi';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return Colors.blue;
      case 'PENDING':
        return AppColors.orange;
      case 'CONFIRMED':
        return Colors.green;
      case 'PREPARING':
        return Colors.purple;
      case 'READY':
        return Colors.teal;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return AppColors.orange;
    }
  }
}
