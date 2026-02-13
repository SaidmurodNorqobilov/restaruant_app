import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../../../core/utils/status.dart';
import '../../../../core/widgets/appbar_widgets.dart';
import '../../../../core/widgets/common_state_widgets.dart';
import '../bloc/orderBLoc/orders_bloc.dart';
import '../bloc/orderBLoc/orders_state.dart';
import '../widgets/orders_card_widgets.dart';
import '../widgets/orders_loading_widgets.dart';

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
            return OrdersLoadingWidget(isDark: isDark);
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
              return OrdersEmptyWidget(isDark: isDark);
            }
            return _buildOrdersList(state, isDark, isTablet);
          }

          return const SizedBox.shrink();
        },
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
            return OrderCardWidget(
              order: order,
              isDark: isDark,
              isTablet: isTablet,
            );
          },
        ),
      ),
    );
  }
}