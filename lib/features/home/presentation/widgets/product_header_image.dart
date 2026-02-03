import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_item_model.dart';

class ProductHeaderImage extends StatelessWidget {
  final ProductModelItem product;

  const ProductHeaderImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'product_${product.id}',
          child: product.image != null && product.image.isNotEmpty
              ? Image.network(
            product.image,
            width: double.infinity,
            height: 360.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          )
              : _buildPlaceholder(),
        ),
        if (!product.isActive)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(128),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    "Mahsulot tugagan",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withAlpha(179),
                  Colors.black.withAlpha(77),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 360.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(77),
            AppColors.primary.withAlpha(26),
          ],
        ),
      ),
      child: Icon(
        Icons.restaurant_menu,
        size: 80.sp,
        color: Colors.white.withAlpha(128),
      ),
    );
  }
}