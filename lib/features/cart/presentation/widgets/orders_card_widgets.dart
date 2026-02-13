import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../account/presentation/pages/location_page.dart';
import '../../../onboarding/presentation/widgets/text_button_app.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../bloc/orderBLoc/orders_bloc.dart';
import 'payment_handler_widget.dart';

class OrderCardWidget extends StatefulWidget {
  final OrderModel order;
  final bool isDark;
  final bool isTablet;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.isDark,
    required this.isTablet,
  });

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  String? _pendingTransactionId;

  @override
  Widget build(BuildContext context) {
    final canCancel = [
      'NEW',
      'PENDING',
      'CONFIRMED',
    ].contains(widget.order.status.toUpperCase());

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkAppBar : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: widget.isDark
              ? AppColors.borderColor.withAlpha(51)
              : AppColors.borderColor.withAlpha(77),
          width: 1,
        ),
        boxShadow: widget.isDark
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
          _buildOrderHeader(),
          SizedBox(height: 12.h),
          _buildOrderTitle(),
          SizedBox(height: 8.h),
          _buildOrderTime(),
          SizedBox(height: 8.h),
          _buildOrderAddress(),
          SizedBox(height: 12.h),
          Divider(
            height: 1,
            thickness: 1,
            color: widget.isDark
                ? AppColors.borderColor.withAlpha(21)
                : AppColors.borderColor.withAlpha(51),
          ),
          SizedBox(height: 12.h),
          _buildPriceDetails(),
          SizedBox(height: 12.h),
          _buildOrderFooter(),
          if (canCancel) ...[
            SizedBox(height: 12.h),
            _buildCancelButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
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
                widget.order.orderType.toUpperCase() == 'DELIVERY'
                    ? Icons.directions_car_filled
                    : Icons.table_restaurant,
                size: widget.isTablet ? 16.sp : 18.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              widget.order.orderType.toUpperCase() == 'DELIVERY'
                  ? 'Yetkazib berish'
                  : 'Restoranda',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: widget.isTablet ? 12.sp : 14.sp,
                color: widget.isDark
                    ? AppColors.white.withAlpha(204)
                    : AppColors.textColor,
              ),
            ),
          ],
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withAlpha(26),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _getStatusColor().withAlpha(51), width: 1),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: widget.isTablet ? 10.sp : 12.sp,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Widget _buildOrderTitle() {
    if (widget.order.items.isEmpty) {
      return _buildEmptyItems();
    }
    if (widget.order.items.length > 1) {
      return _buildMultipleItems();
    }
    return _buildSingleItem();
  }

  Widget _buildEmptyItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buyurtma #${widget.order.orderNumber ?? '1'}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: widget.isTablet ? 12.sp : 18.sp,
            color: widget.isDark ? AppColors.white : AppColors.textColor,
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
    );
  }

  Widget _buildMultipleItems() {
    final totalItems = widget.order.items.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buyurtma #${widget.order.orderNumber ?? "1"}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: widget.isTablet ? 14.sp : 18.sp,
            color: widget.isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${widget.order.items.length} xil mahsulot • $totalItems ta',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: widget.isTablet ? 10.sp : 13.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleItem() {
    final item = widget.order.items.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buyurtma #${widget.order.orderNumber ?? '1'}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: widget.isTablet ? 14.sp : 18.sp,
            color: widget.isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${item.productName} • ${item.quantity} ta',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: widget.isTablet ? 10.sp : 13.sp,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildOrderTime() {
    final dateFormat = DateFormat('dd.MM.yyyy, HH:mm');
    final formattedDate = dateFormat.format(widget.order.createdAt);

    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: widget.isTablet ? 12.sp : 14.sp,
          color: Colors.grey[600],
        ),
        SizedBox(width: 6.w),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: widget.isTablet ? 10.sp : 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderAddress() {
    final hasCoordinates = widget.order.lat != '0' && widget.order.lng != '0';
    final latitude = double.tryParse(widget.order.lat);
    final longitude = double.tryParse(widget.order.lng);

    return InkWell(
      onTap: hasCoordinates && latitude != null && longitude != null
          ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationPage(
              mode: LocationPageMode.view,
              locationId: widget.order.location?.id,
              initialTitle:
              widget.order.location?.title ?? 'Buyurtma manzili',
              initialAddress: widget.order.address,
              initialLat: latitude,
              initialLng: longitude,
            ),
          ),
        );
      }
          : null,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
              size: widget.isTablet ? 14.sp : 16.sp,
              color: hasCoordinates ? AppColors.primary : Colors.grey[600],
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                widget.order.address.isEmpty ? "Manzil" : widget.order.address,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: widget.isTablet ? 10.sp : 13.sp,
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

  Widget _buildPriceDetails() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildPriceRow('Mahsulotlar narxi', widget.order.itemsPrice),
          SizedBox(height: 6.h),
          _buildPriceRow('Yetkazib berish', widget.order.deliveryFee),
          if (widget.order.usedCoins != '0') ...[
            SizedBox(height: 6.h),
            _buildPriceRow(
              'Ishlatilgan coinlar',
              '-${widget.order.usedCoins}',
              valueColor: Colors.green,
            ),
          ],
          SizedBox(height: 8.h),
          Divider(
            height: 1,
            color: widget.isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jami',
                style: TextStyle(
                  fontSize: widget.isTablet ? 13.sp : 15.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              Text(
                '${_formatPrice(widget.order.totalPrice)} UZS',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: widget.isTablet ? 15.sp : 17.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: widget.isTablet ? 11.sp : 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '${_formatPrice(value)} UZS',
          style: TextStyle(
            fontSize: widget.isTablet ? 11.sp : 13.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ??
                (widget.isDark ? AppColors.white : AppColors.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPaymentInfo()),
        if (widget.order.earnedCoins != '0') ...[
          SizedBox(width: 12.w),
          _buildEarnedCoins(),
        ],
      ],
    );
  }

  Widget _buildPaymentInfo() {
    final isOnline =
        widget.order.paymentMethod.toUpperCase() == 'PAYMENT_ONLINE';
    final isPaid = widget.order.paymentStatus.toUpperCase() == 'PAID' ||
        widget.order.paymentStatus.toUpperCase() == 'TO\'LANDI' ||
        widget.order.paymentStatus.toUpperCase() == 'TOLANDI';
    final isPending = widget.order.paymentStatus.toUpperCase() == 'PENDING' ||
        widget.order.paymentStatus.toUpperCase() == 'KUTILMOQDA';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To'lov usuli",
          style: TextStyle(
            fontSize: widget.isTablet ? 10.sp : 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(
              isOnline ? Icons.credit_card : Icons.payments_outlined,
              size: widget.isTablet ? 14.sp : 16.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                widget.order.paymentMethod,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: widget.isTablet ? 13.sp : 14.sp,
                  color: widget.isDark ? AppColors.white : AppColors.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          "To'lov holati",
          style: TextStyle(
            fontSize: widget.isTablet ? 10.sp : 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(
              isPaid
                  ? Icons.check_circle
                  : isPending
                  ? Icons.pending
                  : Icons.error_outline,
              size: widget.isTablet ? 14.sp : 16.sp,
              color: isPaid
                  ? Colors.green
                  : isPending
                  ? AppColors.orange
                  : Colors.red,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                widget.order.paymentStatus,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: widget.isTablet ? 13.sp : 14.sp,
                  color: widget.isDark ? AppColors.white : AppColors.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (!isPaid && isOnline) ...[
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showPaymentSheet(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              icon: Icon(Icons.payment, size: 16.sp),
              label: Text(
                "To'lash",
                style: TextStyle(
                  fontSize: widget.isTablet ? 11.sp : 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEarnedCoins() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade400, Colors.orange.shade400],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars_rounded,
            size: widget.isTablet ? 16.sp : 18.sp,
            color: Colors.white,
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ishlab topildi',
                style: TextStyle(
                  fontSize: widget.isTablet ? 9.sp : 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(230),
                ),
              ),
              Text(
                '+${widget.order.earnedCoins} coins',
                style: TextStyle(
                  fontSize: widget.isTablet ? 12.sp : 14.sp,
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

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showCancelDialog,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.withAlpha(128), width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(Icons.cancel_outlined, size: 18.sp),
        label: Text(
          'Buyurtmani bekor qilish',
          style: TextStyle(
            fontSize: widget.isTablet ? 12.sp : 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        String? selectedPaymentProvider;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.darkAppBar : AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: SafeArea(
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(26),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.payment,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "To'lov tizimini tanlang",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isDark
                                      ? AppColors.white
                                      : AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Buyurtma #${widget.order.orderNumber ?? widget.order.id.substring(0, 8)}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildPaymentProviderTile(
                      'CLICK',
                      'Click',
                      Image.asset(AppIcons.click, width: 32.w, height: 32.w),
                      Colors.blue,
                      selectedPaymentProvider == 'CLICK',
                          () => setModalState(
                              () => selectedPaymentProvider = 'CLICK'),
                    ),
                    SizedBox(height: 12.h),
                    _buildPaymentProviderTile(
                      'PAYME',
                      'Payme',
                      SvgPicture.asset(AppIcons.payme,
                          width: 32.w, height: 32.w),
                      Colors.cyan,
                      selectedPaymentProvider == 'PAYME',
                          () => setModalState(
                              () => selectedPaymentProvider = 'PAYME'),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.borderColor, width: 1.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextButtonApp(
                              onPressed: () => Navigator.pop(modalContext),
                              text: 'Bekor qilish',
                              textColor: widget.isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                              buttonColor: widget.isDark
                                  ? AppColors.darkAppBar
                                  : AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextButtonApp(
                            onPressed: () async {
                              // Navigator.pop(modalContext);
                              // await _processPayment(
                              //     selectedPaymentProvider!);
                            },
                            text: "To'lash",
                            textColor: AppColors.white,
                            buttonColor: selectedPaymentProvider == null
                                ? Colors.grey
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentProviderTile(String provider, String title, Widget icon,
      Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withAlpha(26)
              : widget.isDark
              ? AppColors.white.withAlpha(13)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
          border:
          Border.all(color: isSelected ? color : Colors.transparent, width: 2),
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
                  color: widget.isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 24.sp),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkAppBar : Colors.white,
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
            Icon(Icons.warning_amber_rounded,
                size: 48.sp, color: AppColors.orange),
            SizedBox(height: 16.h),
            Text(
              "Buyurtmani bekor qilish",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: widget.isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Buyurtma #${widget.order.orderNumber ?? widget.order.id.substring(0, 8)} ni bekor qilmoqchimisiz?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.borderColor, width: 1.5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButtonApp(
                      onPressed: () => Navigator.pop(modalContext),
                      text: 'Yo\'q',
                      textColor: widget.isDark
                          ? AppColors.white
                          : AppColors.textColor,
                      buttonColor: widget.isDark
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
                      context.read<OrdersBloc>().add(
                        CancelOrderEvent(orderId: widget.order.id),
                      );
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

  // Future<void> _processPayment(String paymentProvider) async {
  //   try {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(
  //         child: Container(
  //           padding: EdgeInsets.all(24.w),
  //           decoration: BoxDecoration(
  //             color: widget.isDark ? AppColors.darkAppBar : AppColors.white,
  //             borderRadius: BorderRadius.circular(16.r),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const CircularProgressIndicator(color: AppColors.primary),
  //               SizedBox(height: 16.h),
  //               Text(
  //                 "To'lov tayyorlanmoqda...",
  //                 style:
  //                 TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //
  //     final repository = context.read<OrderRepository>();
  //     // final result = await repository.retryPayment(
  //     //   orderId: widget.order.id,
  //     //   paymentProvider: paymentProvider,
  //     //   paymentMethod: 'PAYMENT_ONLINE',
  //     // );
  //
  //     if (!mounted) return;
  //     Navigator.pop(context);
  //
  //     result.fold(
  //           (error) {
  //         showTopSnackBar(
  //           Overlay.of(context),
  //           CustomSnackBar.error(
  //             message: "Xatolik yuz berdi",
  //             backgroundColor: Colors.red,
  //             borderRadius: BorderRadius.circular(10.r),
  //           ),
  //           displayDuration: const Duration(seconds: 2),
  //         );
  //       },
  //           (data) async {
  //         if (data['url'] != null && data['url'].toString().isNotEmpty) {
  //           String? transactionId;
  //           if (data['transactions'] != null &&
  //               data['transactions'].isNotEmpty) {
  //             transactionId = data['transactions'][0]['id'];
  //           } else if (data['url'].toString().contains('transaction_param=')) {
  //             final uri = Uri.parse(data['url']);
  //             transactionId = uri.queryParameters['transaction_param'];
  //           }
  //
  //           if (transactionId != null) {
  //             setState(() => _pendingTransactionId = transactionId);
  //
  //             await PaymentHandler.handleClickPayment(
  //               context: context,
  //               paymentUrl: data['url'],
  //               transactionId: transactionId,
  //               onCancel: () {
  //                 if (mounted) {
  //                   setState(() => _pendingTransactionId = null);
  //                   context.read<OrdersBloc>().add(OrdersLoading());
  //                 }
  //               },
  //             );
  //           }
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     if (!mounted) return;
  //     Navigator.pop(context);
  //     showTopSnackBar(
  //       Overlay.of(context),
  //       CustomSnackBar.error(
  //         message: "Xatolik yuz berdi",
  //         backgroundColor: Colors.red,
  //         borderRadius: BorderRadius.circular(10.r),
  //       ),
  //       displayDuration: const Duration(seconds: 2),
  //     );
  //   }
  // }

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

  String _getStatusText() {
    switch (widget.order.status.toUpperCase()) {
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
        return widget.order.status;
    }
  }

  Color _getStatusColor() {
    switch (widget.order.status.toUpperCase()) {
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