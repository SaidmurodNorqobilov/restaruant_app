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
  final List<double> promotionsPrice = [35.00, 30.00, 70.00, 100.00];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

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
            onRefresh: () async => innerContext.read<CategoriesBLoc>().add(
              CategoriesLoading(),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                    child: Text(
                      context.translate('mealCategories'),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 20.sp : 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  BlocBuilder<CategoriesBLoc, CategoriesState>(
                    builder: (context, state) {
                      if (state.status == Status.loading &&
                          state.categories.isEmpty) {
                        return SizedBox(
                          height: 120.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state.status == Status.error &&
                          state.categories.isEmpty) {
                        return Center(
                          child: Text("Xatolik yuz berdi"),
                        );
                      }
                      return SizedBox(
                        height: isTablet ? 230.h : 250.h,
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.w,
                                crossAxisSpacing: 10.h,
                                childAspectRatio: isTablet ? 0.7 : 1.2,
                              ),
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return GestureDetector(
                              onTap: () => context.push(
                                Routes.categories,
                                extra: state.categories[index].id,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 75.w,
                                    width: 75.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.r),
                                      child: CachedNetworkImage(
                                        imageUrl: "$baseUrl${category.image}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: Colors.grey.shade200,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.fastfood),
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    category.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 15.h),
                    child: Text(
                      context.translate('promotions'),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 20.sp : 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isTablet ? 280.h : 260.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: promotionsImg.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 15.w),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => context.push(Routes.promotions, extra: 1),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 220.w : 200.w,
                          ),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 15.h),
                    child: Text(
                      context.translate('new'),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 20.sp : 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isTablet ? 280.h : 260.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: promotionsImg.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 15.w),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => context.push(Routes.promotions, extra: 1),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 220.w : 200.w,
                          ),
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
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
