import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/data/models/category_model.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_bloc.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_state.dart';
import 'package:restaurantapp/features/home/managers/productBloc/product_bloc.dart';
import 'package:restaurantapp/features/home/managers/productBloc/product_state.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

class RecipeBottomSheet {
   void show({
    required BuildContext context,
    required ProductModel product,
  }) {
    final productBloc = context.read<ProductBloc>();
    final userProfileBloc = context.read<UserProfileBloc>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: productBloc),
          BlocProvider.value(value: userProfileBloc),
        ],
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: _RecipeBottomSheetContent(
            product: product,
            isDark: isDark,
            isTablet: isTablet,
            imageUrlBase: "https://atsrestaurant.pythonanywhere.com",
            parentContext: context,
          ),
        ),
      ),
    );
  }
}

class _RecipeBottomSheetContent extends StatefulWidget {
  final ProductModel product;
  final bool isDark;
  final bool isTablet;
  final String imageUrlBase;
  final BuildContext parentContext;

  const _RecipeBottomSheetContent({
    required this.product,
    required this.isDark,
    required this.isTablet,
    required this.imageUrlBase,
    required this.parentContext,
  });

  @override
  State<_RecipeBottomSheetContent> createState() =>
      _RecipeBottomSheetContentState();
}

class _RecipeBottomSheetContentState extends State<_RecipeBottomSheetContent>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get totalPrice => widget.product.finalPrice * quantity;

  @override
  Widget build(BuildContext context) {
    final String fullImgUrl = (widget.product.image != null && widget.product.image.startsWith('http'))
        ? widget.product.image
        : "${widget.imageUrlBase}${widget.product.image ?? ''}";

    return DraggableScrollableSheet(
      initialChildSize: widget.isTablet ? 0.75 : 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.darkAppBar : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Column(
                children: [
                  _buildHandleBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(fullImgUrl),
                          _buildDetails(),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomAction(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      width: 45.w,
      height: 4.5.h,
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.white24 : Colors.grey[300],
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _buildImageSection(String url) {
    final bool hasImage = widget.product.image != null && widget.product.image.isNotEmpty;
    return Stack(
      children: [
        Container(
          height: widget.isTablet ? 380.h : 280.h,
          width: double.infinity,
          margin: EdgeInsets.all(widget.isTablet ? 25.w : 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: hasImage
                ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingIndicator(loadingProgress);
              },
            )
                : _buildPlaceholder(),
          ),
        ),
        Positioned(
          top: 30.h,
          right: 30.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 22.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 40.w : 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: widget.isTablet ? 26.sp : 22.sp,
                    fontWeight: FontWeight.w800,
                    color: widget.isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
              ),
              _buildPriceTag(),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : AppColors.textColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.product.description,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: widget.isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        "${totalPrice.toStringAsFixed(0)} SO'M",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, MediaQuery.of(context).padding.bottom + 16.h),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkAppBar : Colors.white,
        border: Border(top: BorderSide(color: widget.isDark ? Colors.white10 : Colors.black12, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: widget.isDark ? Colors.white : Colors.black)),
              SizedBox(
                height: 45.h,
                child: CounterRow(
                  count: quantity,
                  onIncrement: () => setState(() => quantity++),
                  onDecrement: () => setState(() { if (quantity > 1) quantity--; }),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildAddToCartButton(),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userState) {
        return BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Added to cart!"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                    label: 'View',
                    textColor: Colors.white,
                    onPressed: () => context.push(Routes.cart),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 54.h,
              child: TextButtonApp(
                onPressed: () {
                  if (userState.user == null) {
                    Navigator.pop(context);
                    _showLoginDialog(
                      widget.parentContext,
                      widget.isDark,
                      widget.isTablet,
                    );
                    return;
                  }
                  context.read<ProductBloc>().add(
                    AddOrderItemEvent(
                      productId: widget.product.id,
                      quantity: quantity,
                    ),
                  );
                },
                text:
                state.status == Status.loading ? 'Adding...' : 'Add to Cart',
                textColor: Colors.white,
                buttonColor: AppColors.primary,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: widget.isDark ? Colors.white10 : Colors.grey[100],
      child: Icon(Icons.fastfood_rounded, size: 50.r, color: Colors.grey),
    );
  }

  Widget _buildLoadingIndicator(ImageChunkEvent progress) {
    return Center(
      child: CircularProgressIndicator(
        value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
        strokeWidth: 2,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Added to cart!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        action: SnackBarAction(label: 'View', textColor: Colors.white, onPressed: () => context.push(Routes.cart)),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(30.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 60.r, color: AppColors.primary),
            SizedBox(height: 20.h),
            Text('Login Required', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Text('Please login to continue shopping', textAlign: TextAlign.center),
            SizedBox(height: 30.h),
            TextButtonApp(
              textColor: AppColors.white,
              text: 'Login Now',
              onPressed: () { Navigator.pop(ctx); context.push(Routes.login); },
              buttonColor: AppColors.primary,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}