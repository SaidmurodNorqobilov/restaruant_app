import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:appbar_animated/appbar_animated.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../accaunt/presentation/bloc/userBloc/user_profile_bloc.dart';
import '../../../accaunt/presentation/bloc/userBloc/user_profile_state.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_item_model.dart';
import '../../../cart/data/datasources/cart_service.dart';
import '../bloc/productBloc/product_bloc.dart';
import '../bloc/productBloc/product_state.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/login_dialog.dart';
import '../widgets/modifier_group_widget.dart';
import '../widgets/product_header_image.dart';
import '../widgets/product_section_header.dart';
import '../widgets/quantity_counter.dart';

class RecipeDetailsPage extends StatefulWidget {
  final ProductModelItem product;

  const RecipeDetailsPage({super.key, required this.product});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  int quantity = 1;
  Map<String, List<ModifiersModel>> selectedModifiers = {};

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(GetUserProfile());
    context.read<ProductBloc>().add(
      GetProductDetailEvent(widget.product.id),
    );
  }

  double get currentPrice {
    double modifiersTotal = 0;
    selectedModifiers.forEach((groupId, modifiers) {
      for (var mod in modifiers) {
        modifiersTotal += mod.price;
      }
    });
    return (widget.product.price + modifiersTotal) * quantity;
  }

  void increment() {
    if (widget.product.isActive) {
      setState(() => quantity++);
    }
  }

  void decrement() {
    if (widget.product.isActive && quantity > 1) {
      setState(() => quantity--);
    }
  }

  void toggleModifier(
    ProductModifierGroupModel group,
    ModifiersModel modifier,
  ) {
    if (!widget.product.isActive) return;

    setState(() {
      if (selectedModifiers[group.id] == null) {
        selectedModifiers[group.id] = [];
      }
      final list = selectedModifiers[group.id]!;
      if (list.contains(modifier)) {
        list.remove(modifier);
      } else {
        if (group.maxSelectedAmount == 1) {
          list.clear();
          list.add(modifier);
        } else if (list.length < group.maxSelectedAmount) {
          list.add(modifier);
        }
      }
    });
  }

  void handleAddToCart(BuildContext context, UserProfileState userState) {
    if (userState.user == null) {
      LoginDialog.show(context);
      return;
    }
    final cartService = CartService();
    final productToAdd = ProductItemModel(
      id: widget.product.id,
      name: widget.product.name,
      description: widget.product.description,
      price: widget.product.price,
      image: widget.product.image,
      vat: widget.product.vat,
      measureUnit: widget.product.measureUnit,
      measure: widget.product.measure,
      sortOrder: widget.product.sortOrder,
      isActive: widget.product.isActive,
      categoryId: widget.product.categoryId,
      modifierGroups: [],
      quantity: quantity,
    );
    cartService.addToCart(productToAdd, quantity: quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Savatga qo\'shildi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(230),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 6,
        action: SnackBarAction(
          label: 'Ko\'rish',
          textColor: Colors.white,
          backgroundColor: Colors.white.withAlpha(51),
          onPressed: () => context.go(Routes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar: ColorBuilder(
          Colors.transparent,
          isDark ? AppColors.darkAppBar : AppColors.primary,
        ),
        textColorAppBar: const ColorBuilder(Colors.white, Colors.white),
        appBarBuilder: (context, colorAnimated) => AppBar(
          backgroundColor: colorAnimated.background,
          elevation: 0,
          leading: Container(
            margin: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                AppIcons.backArrow,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => context.pop(),
            ),
          ),
          title: AnimatedOpacity(
            opacity: colorAnimated.background == Colors.transparent ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.product.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final detail = state.selectedProduct;
            return Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      ProductHeaderImage(product: widget.product),
                      Transform.translate(
                        offset: Offset(0, -30.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.w,
                              30.h,
                              24.w,
                              120.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.product.name,
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.textColor,
                                        ),
                                      ),
                                    ),
                                    if (!widget.product.isActive)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withAlpha(26),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        child: Text(
                                          "Tugagan",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.scale_outlined,
                                            size: 16.sp,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "${widget.product.measure} ${widget.product.measureUnit}",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${currentPrice.toStringAsFixed(0)} SO'M",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24.sp,
                                        color: widget.product.isActive
                                            ? AppColors.primary
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                if (widget.product.description != null &&
                                    widget.product.description!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ProductSectionHeader(
                                        title: "Tavsif",
                                        icon: Icons.description_outlined,
                                        isDark: isDark,
                                      ),
                                      SizedBox(height: 12.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.darkAppBar
                                              : AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                        child: Text(
                                          widget.product.description ??
                                              "Tavsif yo'q",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            height: 1.6,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                    ],
                                  ),
                                if (state.status == Status.loading)
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.h),
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                if (detail != null &&
                                    detail.modifierGroups.isNotEmpty)
                                  ...detail.modifierGroups.map(
                                    (group) => ModifierGroupWidget(
                                      group: group,
                                      isDark: isDark,
                                      isProductActive: widget.product.isActive,
                                      selectedModifiers: selectedModifiers,
                                      onToggleModifier: toggleModifier,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                    ),
                    child: SafeArea(
                      child: BlocBuilder<UserProfileBloc, UserProfileState>(
                        builder: (context, userState) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.product.isActive)
                              QuantityCounter(
                                quantity: quantity,
                                isDark: isDark,
                                isProductActive: widget.product.isActive,
                                onIncrement: increment,
                                onDecrement: decrement,
                              ),
                            SizedBox(
                              height: 16.h,
                            ),
                            AddToCartButton(
                              // bu joyda agar product tugagan bolsa uni korinmay
                              // turishi uchun isActiv deganga qarab product bor yoki yuqlgini korib bilamz
                              // hozircha test qilish uchun true yozib qoydm
                              // cart va add cart qilib test qilish uchun
                              // isProductActive: widget.product.isActive,
                              isProductActive: true,
                              status: state.status,
                              currentPrice: currentPrice,
                              onPressed: () =>
                                  handleAddToCart(context, userState),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
