import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/common/widgets/common_state_widgets.dart';
import 'package:restaurantapp/features/home/managers/categoriesBloc/categories_state.dart';
import 'package:restaurantapp/features/home/widgets/recipe_widgets.dart';
import '../../../core/client.dart';
import '../../../data/repositories/category_repositories.dart';
import '../../common/widgets/appbar_widgets.dart';
import '../managers/categoriesBloc/categories_bloc.dart';

class CategoriesPage extends StatefulWidget {
  final int categoryId;

  const CategoriesPage({super.key, required this.categoryId});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final String imageUrlBase = "https://atsrestaurant.pythonanywhere.com";
  bool _isImagesPreCached = false;

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

    return BlocProvider(
      create: (context) => CategoriesBLoc(
        categoryRepository: CategoryRepository(client: ApiClient()),
      )..add(CategoryGetId(widget.categoryId)),
      child: Scaffold(
        extendBody: true,
        appBar: const AppBarWidgets(title: 'Products'),
        body: BlocBuilder<CategoriesBLoc, CategoriesState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return LoadingState(
                isDark: isDark,
                isTablet: isTablet,
              );


              // return Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         width: isTablet ? 100.w : 80.w,
              //         height: isTablet ? 100.w : 80.w,
              //         decoration: BoxDecoration(
              //           color: AppColors.primary.withAlpha(21),
              //           shape: BoxShape.circle,
              //         ),
              //         child: Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             SizedBox(
              //               width: isTablet ? 75.w : 60.w,
              //               height: isTablet ? 75.w : 60.w,
              //               child: CircularProgressIndicator(
              //                 strokeWidth: isTablet ? 4 : 3,
              //                 valueColor: AlwaysStoppedAnimation<Color>(
              //                   AppColors.primary,
              //                 ),
              //               ),
              //             ),
              //             Icon(
              //               Icons.restaurant_menu,
              //               size: isTablet ? 35.sp : 28.sp,
              //               color: AppColors.primary,
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(height: isTablet ? 30.h : 24.h),
              //       Text(
              //         'Mahsulotlar yuklanmoqda...',
              //         style: TextStyle(
              //           fontSize: isTablet ? 18.sp : 16.sp,
              //           fontWeight: FontWeight.w500,
              //           color: isDark
              //               ? AppColors.white.withAlpha(179)
              //               : AppColors.black.withOpacity(0.6),
              //         ),
              //       ),
              //     ],
              //   ),
              // );
            }

            if (state.status == Status.error) {
              return ErrorState(
                isDark: isDark,
                onRetry: () {
                  setState(() {});
                },
              );
              //               return Center(
              //                 child: Padding(
              //                   padding: EdgeInsets.all(isTablet ? 40.w : 32.w),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Container(
              //                         width: isTablet ? 120.w : 100.w,
              //                         height: isTablet ? 120.w : 100.w,
              //                         decoration: BoxDecoration(
              //                           color: AppColors.red.withAlpha(21)
              // ,
              //                           shape: BoxShape.circle,
              //                         ),
              //                         child: Icon(
              //                           Icons.error_outline_rounded,
              //                           size: isTablet ? 60.sp : 50.sp,
              //                           color: AppColors.red,
              //                         ),
              //                       ),
              //                       SizedBox(height: isTablet ? 30.h : 24.h),
              //                       Text(
              //                         'Xatolik yuz berdi',
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           fontSize: isTablet ? 24.sp : 20.sp,
              //                           fontWeight: FontWeight.w700,
              //                           color: isDark ? AppColors.white : AppColors.black,
              //                         ),
              //                       ),
              //                       SizedBox(height: isTablet ? 16.h : 12.h),
              //                       Text(
              //                         'Mahsulotlarni yuklashda muammo yuz berdi.\nKeyinroq qaytadan urinib ko\'ring.',
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           fontSize: isTablet ? 16.sp : 14.sp,
              //                           fontWeight: FontWeight.w400,
              //                           color: isDark
              //                               ? AppColors.white.withAlpha(179)
              //
              //                               : AppColors.black.withOpacity(0.6),
              //                           height: 1.5,
              //                         ),
              //                       ),
              //                       SizedBox(height: isTablet ? 40.h : 32.h),
              //                       ElevatedButton.icon(
              //                         onPressed: () {
              //                           setState(() {
              //                             _isImagesPreCached = false;
              //                           });
              //                           context.read<CategoriesBLoc>().add(
              //                             CategoryGetId(widget.categoryId),
              //                           );
              //                         },
              //                         style: ElevatedButton.styleFrom(
              //                           backgroundColor: AppColors.primary,
              //                           padding: EdgeInsets.symmetric(
              //                             horizontal: isTablet ? 40.w : 32.w,
              //                             vertical: isTablet ? 18.h : 16.h,
              //                           ),
              //                           shape: RoundedRectangleBorder(
              //                             borderRadius: BorderRadius.circular(12.r),
              //                           ),
              //                           elevation: 0,
              //                         ),
              //                         icon: Icon(
              //                           Icons.refresh_rounded,
              //                           size: isTablet ? 24.sp : 20.sp,
              //                           color: AppColors.white,
              //                         ),
              //                         label: Text(
              //                           'Qayta urinish',
              //                           style: TextStyle(
              //                             fontSize: isTablet ? 18.sp : 16.sp,
              //                             fontWeight: FontWeight.w600,
              //                             color: AppColors.white,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               );
            }

            if (state.products.isEmpty) {
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
                              AppColors.primary.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: isTablet ? 70.sp : 60.sp,
                          color: AppColors.primary.withOpacity(0.6),
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
                              : AppColors.black.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: isTablet ? 48.h : 40.h),
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

            return GridView.builder(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                isTablet ? 140.h : 120.h,
              ),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),                itemCount: state.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: isTablet ? 20.w : 15.w,
                mainAxisSpacing: isTablet ? 20.h : 15.h,
                mainAxisExtent: mainAxisExtent,
              ),
              itemBuilder: (BuildContext context, int index) {
                final product = state.products[index];
                final String fullImgUrl = product.image.startsWith('http')
                    ? product.image
                    : "$imageUrlBase${product.image}";

                return GestureDetector(
                  onTap: () {
                    context.push(Routes.recipeDetails, extra: product);
                  },
                  child: RecipeWidgets(
                    img: fullImgUrl,
                    title: product.name,
                    text: product.description,
                    price: product.finalPrice.toDouble(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _precacheProductImages(List products) async {
    if (_isImagesPreCached) return;

    try {
      await Future.wait(
        products.map((product) {
          final String fullImgUrl = product.image.startsWith('http')
              ? product.image
              : "$imageUrlBase${product.image}";
          return precacheImage(
            CachedNetworkImageProvider(fullImgUrl),
            context,
          );
        }),
      );
      if (mounted) {
        setState(() {
          _isImagesPreCached = true;
        });
      }
    } catch (e) {
      debugPrint('Error precaching product images: $e');
    }
  }
}
