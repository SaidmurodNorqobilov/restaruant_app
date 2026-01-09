import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDesktop = screenWidth > 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int crossAxisCount = 2;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
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
                      'Mahsulotlar yuklanmoqda...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.white.withOpacity(0.7)
                            : AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.status == Status.error) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 50.sp,
                          color: AppColors.red,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Xatolik yuz berdi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Mahsulotlarni yuklashda muammo yuz berdi.\nKeyinroq qaytadan urinib ko\'ring.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.white.withOpacity(0.7)
                              : AppColors.black.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<CategoriesBLoc>().add(
                            CategoryGetId(widget.categoryId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 16.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 20.sp,
                          color: AppColors.white,
                        ),
                        label: Text(
                          'Qayta urinish',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.products.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.primary.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 60.sp,
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        'Hozircha mahsulot yo\'q',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Bu kategoriyada hozircha mahsulotlar\nmavjud emas. Keyinroq qaytib ko\'ring!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.white.withOpacity(0.7)
                              : AppColors.black.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 16.h,
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
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Orqaga qaytish',
                          style: TextStyle(
                            fontSize: 16.sp,
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

            return GridView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
              physics: const BouncingScrollPhysics(),
              itemCount: state.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                mainAxisExtent: isTablet ? 320.h : 290.h,
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
}