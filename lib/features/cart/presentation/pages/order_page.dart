import 'package:flutter/material.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../../../core/widgets/appbar_widgets.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(
        title: context.translate('orders'),
      ),
      body: Center(child: Text("malumot yoq"),),
      // body: BlocProvider(
      //   create: (context) => OrdersBloc(
      //     orderRepository: OrderRepository(
      //       client: ApiClient(),
      //     ),
      //   )..add(OrdersLoading()),
      //   child: BlocBuilder<OrdersBloc, OrdersState>(
      //     builder: (context, state) {
      //       if (state.status == Status.loading) {
      //         return Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: 80.w,
      //                 height: 80.w,
      //                 decoration: BoxDecoration(
      //                   color: AppColors.primary.withAlpha(21),
      //                   shape: BoxShape.circle,
      //                 ),
      //                 child: Stack(
      //                   alignment: Alignment.center,
      //                   children: [
      //                     SizedBox(
      //                       width: 60.w,
      //                       height: 60.w,
      //                       child: CircularProgressIndicator(
      //                         strokeWidth: 3,
      //                         valueColor: AlwaysStoppedAnimation<Color>(
      //                           AppColors.primary,
      //                         ),
      //                       ),
      //                     ),
      //                     Icon(
      //                       Icons.restaurant_menu,
      //                       size: 28.sp,
      //                       color: AppColors.primary,
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 24.h),
      //               Text(
      //                 'Buyurtmalar yuklanmoqda...',
      //                 style: TextStyle(
      //                   fontSize: 16.sp,
      //                   fontWeight: FontWeight.w500,
      //                   color: isDark
      //                       ? AppColors.white.withAlpha(179)
      //                       : AppColors.black.withAlpha(153),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
      //       }
      //
      //       if (state.status == Status.error) {
      //         return ErrorState(
      //           isDark: isDark,
      //           onRetry: () {
      //             context.read<OrdersBloc>().add(OrdersLoading());
      //           },
      //         );
      //       }
      //       if (state.status == Status.success) {
      //         if (state.orders.isEmpty) {
      //           return Center(
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.receipt_long_outlined,
      //                   size: 80.sp,
      //                   color: Colors.grey.withAlpha(102),
      //                 ),
      //                 SizedBox(height: 16.h),
      //                 Text(
      //                   "Buyurtmalar yo'q",
      //                   style: TextStyle(
      //                     fontSize: 18.sp,
      //                     fontWeight: FontWeight.w600,
      //                     color: isDark ? AppColors.white : AppColors.textColor,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           );
      //         }
      //         return RefreshIndicator(
      //           backgroundColor: isDark
      //               ? AppColors.darkAppBar
      //               : AppColors.primary,
      //           color: AppColors.white,
      //           onRefresh: () async {
      //             context.read<OrdersBloc>().add(OrdersLoading());
      //           },
      //           child: Padding(
      //             padding: EdgeInsets.only(
      //               left: 16.w,
      //               right: 16.w,
      //               bottom: MediaQuery.of(context).padding.bottom + 17.h,
      //             ),
      //             child: ListView.separated(
      //               physics: const AlwaysScrollableScrollPhysics(
      //                 parent: BouncingScrollPhysics(),
      //               ),
      //               padding: EdgeInsets.symmetric(vertical: 16.h),
      //               itemCount: state.orders.length,
      //               separatorBuilder: (context, index) =>
      //                   SizedBox(height: 12.h),
      //               itemBuilder: (context, index) {
      //                 final order = state.orders[index];
      //                 return InkWell(
      //                   borderRadius: BorderRadius.circular(12.r),
      //                   onLongPress: () {
      //                     showModalBottomSheet(
      //                       context: context,
      //                       backgroundColor: Colors.transparent,
      //                       builder: (BuildContext modalContext) => Container(
      //                         height: isTablet ? 350.h :  200.h,
      //                         width: double.infinity,
      //                         decoration: BoxDecoration(
      //                           color: isDark
      //                               ? AppColors.darkAppBar
      //                               : Colors.white,
      //                           borderRadius: BorderRadius.only(
      //                             topLeft: Radius.circular(20.r),
      //                             topRight: Radius.circular(20.r),
      //                           ),
      //                         ),
      //                         child: Padding(
      //                           padding: EdgeInsets.all(20.w),
      //                           child: Column(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Text(
      //                                 "Mahsulotni bekor qilmoqchimisiz ?",
      //                                 style: TextStyle(
      //                                   fontSize: 18.sp,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: isDark
      //                                       ? Colors.white
      //                                       : AppColors.textColor,
      //                                 ),
      //                               ),
      //                               SizedBox(height: 30.h),
      //                               Row(
      //                                 children: [
      //                                   Expanded(
      //                                     child: Container(
      //                                       decoration: BoxDecoration(
      //                                         border: Border.all(
      //                                           color: AppColors.borderColor,
      //                                         ),
      //                                         borderRadius:
      //                                             BorderRadius.circular(30.r),
      //                                       ),
      //                                       child: TextButtonApp(
      //                                         onPressed: () {
      //                                           Navigator.pop(modalContext);
      //                                         },
      //                                         text: context.translate('cancel'),
      //                                         textColor: isDark
      //                                             ? AppColors.white
      //                                             : AppColors.textColor,
      //                                         buttonColor: isDark
      //                                             ? AppColors.darkAppBar
      //                                             : AppColors.white,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   SizedBox(width: 12.w),
      //                                   Expanded(
      //                                     child: TextButtonApp(
      //                                       onPressed: () {
      //                                         Navigator.pop(modalContext);
      //                                         context.read<OrdersBloc>().add(
      //                                           CancelOrderEvent(
      //                                             orderId: order.id,
      //                                           ),
      //                                         );
      //                                       },
      //                                       text: 'bekor qilish',
      //                                       // text: context.translate('delete'),
      //                                       textColor: AppColors.white,
      //                                       buttonColor: AppColors.primary,
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                   onTap: () {
      //                     context.push(Routes.orderDetail);
      //                   },
      //                   child: Container(
      //                     padding: EdgeInsets.all(16.w),
      //                     decoration: BoxDecoration(
      //                       color: isDark
      //                           ? AppColors.darkAppBar
      //                           : AppColors.white,
      //                       borderRadius: BorderRadius.circular(12.r),
      //                       border: Border.all(
      //                         color: isDark
      //                             ? AppColors.borderColor.withAlpha(51)
      //                             : AppColors.borderColor.withAlpha(77),
      //                       ),
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: isDark
      //                               ? Colors.transparent
      //                               : Colors.black.withAlpha(10),
      //                           blurRadius: 8,
      //                           offset: const Offset(0, 2),
      //                         ),
      //                       ],
      //                     ),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Row(
      //                               children: [
      //                                 Icon(
      //                                   order.orderType.toLowerCase() ==
      //                                           'delivery'
      //                                       ? Icons.delivery_dining
      //                                       : Icons.table_restaurant,
      //                                   size: 18.sp,
      //                                   color: AppColors.primary,
      //                                 ),
      //                                 SizedBox(width: 6.w),
      //                                 Text(
      //                                   order.orderType.toLowerCase() ==
      //                                           'delivery'
      //                                       ? 'Yetkazib berish'
      //                                       : order.tipTable ?? 'Stol',
      //                                   style: TextStyle(
      //                                     fontWeight: FontWeight.w500,
      //                                     fontSize: 14.sp,
      //                                     color: isDark
      //                                         ? AppColors.white.withAlpha(204)
      //                                         : Colors.grey[700],
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                             Container(
      //                               padding: EdgeInsets.symmetric(
      //                                 horizontal: 12.w,
      //                                 vertical: isTablet ? 4 : 6.h,
      //                               ),
      //                               decoration: BoxDecoration(
      //                                 color: _getStatusColor(
      //                                   order.status,
      //                                 ).withAlpha(21),
      //                                 borderRadius: BorderRadius.circular(
      //                                   20.r,
      //                                 ),
      //                               ),
      //                               child: Text(
      //                                 _getStatusText(order.status),
      //                                 style: TextStyle(
      //                                   fontWeight: FontWeight.w600,
      //                                   fontSize: isTablet ? 10.sp : 12.sp,
      //                                   color: _getStatusColor(order.status),
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         SizedBox(height: 12.h),
      //                         Text(
      //                           'Buyurtma #${order.id}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w700,
      //                             fontSize: isTablet ? 15.sp : 18.sp,
      //                             color: isDark
      //                                 ? AppColors.white
      //                                 : AppColors.textColor,
      //                           ),
      //                         ),
      //                         SizedBox(height: 8.h),
      //                         Row(
      //                           children: [
      //                             Icon(
      //                               Icons.location_on_outlined,
      //                               size: isTablet ? 12.sp : 16.sp,
      //                               color: Colors.grey,
      //                             ),
      //                             SizedBox(width: 4.w),
      //                             Expanded(
      //                               child: Text(
      //                                 order.location,
      //                                 style: TextStyle(
      //                                   fontWeight: FontWeight.w400,
      //                                   fontSize: 13.sp,
      //                                   color: Colors.grey,
      //                                 ),
      //                                 maxLines: 1,
      //                                 overflow: TextOverflow.ellipsis,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         SizedBox(height: 12.h),
      //                         Container(
      //                           height: 1,
      //                           color: isDark
      //                               ? AppColors.borderColor.withAlpha(21)
      //                               : AppColors.borderColor.withAlpha(51),
      //                         ),
      //                         SizedBox(height: 12.h),
      //                         Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Column(
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   'To\'lov usuli',
      //                                   style: TextStyle(
      //                                     fontSize: isTablet ? 10.sp : 12.sp,
      //                                     color: Colors.grey,
      //                                   ),
      //                                 ),
      //                                 SizedBox(
      //                                   height: 4.h,
      //                                 ),
      //                                 Row(
      //                                   children: [
      //                                     Icon(
      //                                       order.paymentMethod.toLowerCase() ==
      //                                               'online'
      //                                           ? Icons.credit_card
      //                                           : Icons.money,
      //                                       size: isTablet ? 12.sp : 16.sp,
      //                                       color: AppColors.primary,
      //                                     ),
      //                                     SizedBox(
      //                                       width: 4.w,
      //                                     ),
      //                                     Text(
      //                                       order.paymentMethod.toLowerCase() ==
      //                                               'online'
      //                                           ? 'Online'
      //                                           : 'Naqd',
      //                                       style: TextStyle(
      //                                         fontWeight: FontWeight.w600,
      //                                         fontSize: isTablet ? 12.sp : 14.sp,
      //                                         color: isDark
      //                                             ? AppColors.white
      //                                             : AppColors.textColor,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                             Column(
      //                               crossAxisAlignment: CrossAxisAlignment.end,
      //                               children: [
      //                                 Text(
      //                                   'Jami summa',
      //                                   style: TextStyle(
      //                                     fontSize: 12.sp,
      //                                     color: Colors.grey,
      //                                   ),
      //                                 ),
      //                                 SizedBox(height: 4.h),
      //                                 Text(
      //                                   '${_formatPrice(order.totalPrice)} UZS',
      //                                   style: TextStyle(
      //                                     fontWeight: FontWeight.w700,
      //                                     fontSize: isTablet ? 15.sp : 18.sp,
      //                                     color: AppColors.primary,
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),
      //         );
      //       }
      //
      //       return const SizedBox.shrink();
      //     },
      //   ),
      // ),
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
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Kutilmoqda';
      case 'confirmed':
        return 'Tasdiqlandi';
      case 'preparing':
        return 'Tayyorlanmoqda';
      case 'ready':
        return 'Tayyor';
      case 'delivered':
        return 'Yetkazildi';
      case 'cancelled':
        return 'Bekor qilindi';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.orange;
    }
  }
}
