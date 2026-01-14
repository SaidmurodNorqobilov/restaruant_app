import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/data/repositories/category_repositories.dart';
import 'package:restaurantapp/features/home/managers/categoriesBloc/categories_state.dart';
import 'package:restaurantapp/features/home/widgets/home_page_appbar.dart';
import 'package:restaurantapp/features/home/widgets/recipe_widgets.dart';
import '../managers/categoriesBloc/categories_bloc.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controllerSearch = TextEditingController();
  final String baseUrl = "https://atsrestaurant.pythonanywhere.com";
  bool _isImagesPreCached = false;

  final List<String> promotionsImg = [
    'https://i.pinimg.com/originals/37/cc/51/37cc518c0d49a2fd03bc93fd151c9ca1.jpg',
    'https://i.pinimg.com/736x/9f/7b/79/9f7b791eb96cffe2766d04204ea1ce50.jpg',
    'https://i.pinimg.com/736x/a6/43/d3/a643d32d686507340fdc4cdd111c14f0.jpg',
    'https://media.istockphoto.com/id/1371064975/ru/%D1%84%D0%BE%D1%82%D0%BE/%D1%82%D1%80%D0%B0%D0%B4%D0%B8%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B9-%D0%BF%D0%BE%D0%BB%D0%BD%D1%8B%D0%B9-%D0%B0%D0%BC%D0%B5%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9-%D0%B7%D0%B0%D0%B2%D1%82%D1%80%D0%B0%D0%BA-%D1%8F%D0%B9%D1%86%D0%B0-%D0%B1%D0%BB%D0%B8%D0%BD%D1%8B-%D1%81-%D0%B1%D0%B5%D0%BA%D0%BE%D0%BD%D0%BE%D0%BC-%D0%B8-%D1%82%D0%BE%D1%81%D1%82%D0%B0%D0%BC%D0%B8.jpg?s=612x612&w=0&k=20&c=qY5NnVsCm_FzST2kUeVIt-QhM4eepr14Y32oW2sXXnk=',
  ];
  final List<String> promotionsTitle = [
    'Milk shakes',
    'Artisan Lattes',
    'Special Cake',
    'Ovqat',
  ];
  final List<String> promotionsText = [
    'Banana, chocolate, vanilla...',
    'Honey, rose, lavendar...',
    'Freshly baked...',
    'Test description',
  ];
  final List<double> promotionsPrice = [35000.00, 30000.00, 79000.00, 110000.00];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;

    final double hPadding = isDesktop ? 40.w : (isTablet ? 30.w : 20.w);
    final double titleSize = isDesktop ? 22.sp : (isTablet ? 20.sp : 18.sp);
    final double catItemSize = isDesktop ? 100.w : (isTablet ? 35.w : 75.w);
    final double catSectionHeight = isDesktop
        ? 320.h
        : (isTablet ? 280.h : 250.h);
    final double recipeCardWidth = isDesktop
        ? 260.w
        : (isTablet ? 220.w : 190.w);
    final double recipeSectionHeight = isDesktop
        ? 320.h
        : (isTablet ? 300.h : 270.h);

    return BlocProvider(
      create: (context) => CategoriesBLoc(
        categoryRepository: CategoryRepository(client: ApiClient()),
      )..add(CategoriesLoading()),
      child: Builder(
        builder: (innerContext) => Scaffold(
          extendBody: true,
          appBar: HomePageAppbar(),
          drawer: const DrawerWidgets(),
          body: RefreshIndicator(
            backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
            color: AppColors.white,
            onRefresh: () async {
              innerContext.read<CategoriesBLoc>().add(CategoriesLoading());
              setState(() {
                _isImagesPreCached = false;
              });
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildSectionHeader(
                    context,
                    'mealCategories',
                    titleSize,
                    hPadding,
                    Icons.restaurant_menu,
                    isDark,
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<CategoriesBLoc, CategoriesState>(
                    builder: (context, state) {
                      if (state.status == Status.loading) {
                        return _buildLoading(catSectionHeight, isDark);
                      }
                      if (state.status == Status.error &&
                          state.categories.isEmpty) {
                        return _buildError(catSectionHeight, isDark);
                      }

                      if (!_isImagesPreCached && state.categories.isNotEmpty) {
                        _precacheImages(state.categories);
                      }

                      return SizedBox(
                        height: catSectionHeight,
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: hPadding),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.w,
                                crossAxisSpacing: 12.h,
                                childAspectRatio: isDesktop
                                    ? 1.0
                                    : (isTablet ? 0.85 : 1.1),
                              ),
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return GestureDetector(
                              onTap: () => context.push(
                                Routes.categories,
                                extra: category.id,
                              ),
                              child: Container(
                                height: catItemSize,
                                width: catItemSize,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkAppBar
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: catItemSize,
                                      width: catItemSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100.r,
                                        ),
                                        child:
                                            category.image != null &&
                                                category.image
                                                    .toString()
                                                    .isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "$baseUrl${category.image}",
                                                fit: BoxFit.cover,
                                                memCacheHeight: 200,
                                                memCacheWidth: 200,
                                                maxHeightDiskCache: 400,
                                                maxWidthDiskCache: 400,
                                                fadeInDuration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                      color: isDark
                                                          ? AppColors.darkAppBar
                                                          : Colors.grey[100],
                                                      child: Icon(
                                                        Icons.fastfood,
                                                        color: AppColors.primary
                                                            .withOpacity(0.3),
                                                        size: 28.sp,
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      color: isDark
                                                          ? AppColors.darkAppBar
                                                          : Colors.grey[100],
                                                      child: Icon(
                                                        Icons.fastfood,
                                                        color:
                                                            AppColors.primary,
                                                        size: 28.sp,
                                                      ),
                                                    ),
                                              )
                                            : Container(
                                                color: isDark
                                                    ? AppColors.darkAppBar
                                                    : Colors.grey[100],
                                                child: Icon(
                                                  Icons.fastfood,
                                                  color: AppColors.primary,
                                                  size: 28.sp,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      child: Text(
                                        category.name,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: isTablet ? 10.sp : 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  _buildRecipeSection(
                    context,
                    'promotions',
                    Icons.local_offer,
                    recipeSectionHeight,
                    recipeCardWidth,
                    hPadding,
                    titleSize,
                    isDark,
                  ),
                  _buildRecipeSection(
                    context,
                    'new',
                    Icons.fiber_new,
                    recipeSectionHeight,
                    recipeCardWidth,
                    hPadding,
                    titleSize,
                    isDark,
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _precacheImages(List categories) async {
    if (_isImagesPreCached) return;

    try {
      await Future.wait(
        categories.map(
          (category) => precacheImage(
            CachedNetworkImageProvider("$baseUrl${category.image}"),
            context,
          ),
        ),
      );
      if (mounted) {
        setState(() {
          _isImagesPreCached = true;
        });
      }
    } catch (e) {
      debugPrint('Error precaching images: $e');
    }
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String titleKey,
    double size,
    double padding,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: size),
          SizedBox(width: 8.w),
          Text(
            context.translate(titleKey),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: size,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeSection(
    BuildContext context,
    String titleKey,
    IconData icon,
    double sHeight,
    double cWidth,
    double padding,
    double tSize,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        _buildSectionHeader(context, titleKey, tSize, padding, icon, isDark),
        SizedBox(height: 16.h),
        SizedBox(
          height: sHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: padding),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: promotionsImg.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => context.push(Routes.promotions, extra: 1),
              child: SizedBox(
                width: cWidth,
                child: RecipeWidgets(
                  img: promotionsImg[index],
                  title: promotionsTitle[index],
                  text: promotionsText[index],
                  price: promotionsPrice[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(double height, bool isDark) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              'Yuklanmoqda...',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(double height, bool isDark) {
    return SizedBox(
      height: height,
      child: Center(
        child: Icon(
          Icons.error_outline,
          size: 40.sp,
          color: Colors.red.withOpacity(0.5),
        ),
      ),
    );
  }
}
