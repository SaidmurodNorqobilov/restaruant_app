import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/cart/widgets/placeholer_icon.dart';

import '../../../core/utils/colors.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../home/widgets/container_row.dart';
import '../../onboarding/widgets/text_button_app.dart';
import '../managers/cartBloc/cart_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final dynamic item;
  final dynamic product;
  final String? imageUrl;
  final int itemQuantity;
  final int itemId;
  final bool isDark;
  final bool isTablet;
  final bool isLandscape;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.product,
    this.imageUrl,
    required this.itemQuantity,
    required this.itemId,
    required this.isDark,
    required this.isTablet,
    required this.isLandscape,
  }) : super(key: key);

  void _showDeleteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) => Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mahsulotni o'chirmoqchimisiz ?",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: TextButtonApp(
                        onPressed: () {
                          Navigator.pop(modalContext);
                        },
                        text: context.translate('cancel'),
                        textColor: isDark
                            ? AppColors.white
                            : AppColors.textColor,
                        buttonColor: isDark
                            ? AppColors.darkAppBar
                            : AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextButtonApp(
                      onPressed: () async {
                        Navigator.pop(modalContext);
                        final cartRepository =
                        context.read<CartRepository>();
                        await cartRepository.deleteCartItem(item.id);
                        context.read<CartBloc>().add(CartLoading());
                      },
                      text: context.translate('delete'),
                      textColor: AppColors.white,
                      buttonColor: AppColors.primary,
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
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onLongPress: () => _showDeleteDialog(context),
      child: Container(
        height: isLandscape ? 72.h : 82.h,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(12.r),
              ),
              child: SizedBox(
                width: (isTablet ? 60.0 : 85.0).w,
                height: double.infinity,
                child: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      PlaceholderIcon(isDark: isDark),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                      ),
                    );
                  },
                )
                    : PlaceholderIcon(isDark: isDark),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product?.name ?? 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 12.sp : 14.sp,
                        color: isDark ? Colors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${(item.price ?? 0.0).toStringAsFixed(0)} SO'M",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CounterRow(
                  count: itemQuantity,
                  onIncrement: () {
                    if (itemId > 0) {
                      context.read<CartBloc>().add(
                        CartUpdate(
                          itemId: itemId,
                          quantity: itemQuantity + 1,
                        ),
                      );
                    }
                  },
                  onDecrement: () {
                    if (itemQuantity > 1 && itemId > 0) {
                      context.read<CartBloc>().add(
                        CartUpdate(
                          itemId: itemId,
                          quantity: itemQuantity - 1,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}