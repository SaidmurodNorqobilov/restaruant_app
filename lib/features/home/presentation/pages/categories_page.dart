import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../core/network/client.dart';
import '../../../../core/widgets/appbar_widgets.dart';
import '../../../../core/widgets/common_state_widgets.dart';
import '../../data/repositories/category_repositories.dart';
import '../bloc/categoriesBloc/categories_bloc.dart';
import '../bloc/categoriesBloc/categories_state.dart';
import '../widgets/recipe_widgets.dart';

class CategoriesPage extends StatefulWidget {
  final String categoryId;

  const CategoriesPage({super.key, required this.categoryId});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isImagesPreCached = false;
  late final CategoriesBLoc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CategoriesBLoc(
      categoryRepository: CategoryRepository(
        client: ApiClient(),
      ),
    )..add(
      CategoryGetId(widget.categoryId),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_bloc.state.isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.75;

    if (currentScroll >= threshold && !_bloc.state.hasReachedMax) {
      _bloc.add(LoadMoreProducts(widget.categoryId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int crossAxisCount = 2;
    double mainAxisExtent = 290.h;
    double horizontalPadding = 20.w;
    double verticalPadding = 20.h;

    if (isDesktop) {
      crossAxisCount = 4;
      mainAxisExtent = 340.h;
      horizontalPadding = 40.w;
      verticalPadding = 30.h;
    } else if (isTablet) {
      crossAxisCount = 3;
      mainAxisExtent = 320.h;
      horizontalPadding = 30.w;
      verticalPadding = 25.h;
    }

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        extendBody: true,
        appBar: const AppBarWidgets(title: 'Products'),
        body: BlocBuilder<CategoriesBLoc, CategoriesState>(
          builder: (context, state) {
            if (state.status == Status.loading && state.products.isEmpty) {
              return LoadingState(
                isDark: isDark,
                isTablet: isTablet,
              );
            }
            if (state.status == Status.error) {
              return ErrorState(
                isDark: isDark,
                onRetry: () {
                  _bloc.add(CategoryGetId(widget.categoryId));
                },
              );
            }
            if (state.products.isEmpty && state.status == Status.success) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 40.w : 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isTablet ? 140.w : 120.w,
                        height: isTablet ? 140.w : 120.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withAlpha(21),
                              AppColors.primary.withAlpha(13),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: isTablet ? 70.sp : 60.sp,
                          color: AppColors.primary.withAlpha(153),
                        ),
                      ),
                      SizedBox(height: isTablet ? 40.h : 32.h),
                      Text(
                        'Hozircha mahsulot yo\'q',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 28.sp : 24.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      Text(
                        'Bu kategoriyada hozircha mahsulotlar\nmavjud emas. Keyinroq qaytib ko\'ring!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 16.sp : 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.white.withAlpha(179)
                              : AppColors.black.withAlpha(153),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: isTablet ? 48.h : 40.h,
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 40.w : 32.w,
                            vertical: isTablet ? 18.h : 16.h,
                          ),
                          side: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: isTablet ? 24.sp : 20.sp,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Orqaga qaytish',
                          style: TextStyle(
                            fontSize: isTablet ? 18.sp : 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!_isImagesPreCached && state.products.isNotEmpty) {
              _precacheProductImages(state.products);
            }

            return RefreshIndicator(
              backgroundColor: isDark ? AppColors.darkAppBar : AppColors.white,
              color: AppColors.primary,
              onRefresh: () async {
                _bloc.add(CategoryGetId(widget.categoryId));
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  isTablet ? 140.h : 120.h,
                ),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: !state.hasReachedMax
                    ? state.products.length + 1
                    : state.products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isTablet ? 20.w : 15.w,
                  mainAxisSpacing: isTablet ? 20.h : 15.h,
                  mainAxisExtent: mainAxisExtent,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.products.length) {
                    return GridTile(
                      child: Align(
                        alignment: AlignmentGeometry.center,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  final product = state.products[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(Routes.recipeDetails, extra: product);
                    },
                    child: RecipeWidgets(
                      img: product.image,
                      title: product.name,
                      text: product.description ?? "tavsif yo'q",
                      price: product.price.toDouble(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _precacheProductImages(List products) async {
    if (_isImagesPreCached) return;

    try {
      final imagesToCache = products
          .where((product) =>
      product.image != null &&
          product.image.toString().isNotEmpty &&
          product.image.toString().startsWith('http'))
          .toList();

      if (imagesToCache.isEmpty) {
        if (mounted) {
          setState(() {
            _isImagesPreCached = true;
          });
        }
        return;
      }

      await Future.wait(
        imagesToCache.map((product) {
          return precacheImage(
            CachedNetworkImageProvider(product.image),
            context,
          );
        }),
        eagerError: false,
      );

      if (mounted) {
        setState(() {
          _isImagesPreCached = true;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Error precaching product images');
      if (mounted) {
        setState(() {
          _isImagesPreCached = true;
        });
      }
    }
  }
}