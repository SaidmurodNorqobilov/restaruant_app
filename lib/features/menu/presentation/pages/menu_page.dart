import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/network/client.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/widgets/drawer_widgets.dart';
import '../../../home/data/repositories/category_repositories.dart';
import '../../../home/presentation/bloc/categoriesBloc/categories_bloc.dart';
import '../../../home/presentation/bloc/categoriesBloc/categories_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController controllerSearch = TextEditingController();
  final String baseUrl = "https://atsrestaurant.pythonanywhere.com";
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    controllerSearch.addListener(() {
      setState(() {
        _searchQuery = controllerSearch.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
        titleSpacing: 0,
        title: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedSlide(
              offset: _isSearching ? const Offset(-1.2, 0) : Offset.zero,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: _isSearching ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  context.translate("menuBottom"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            AnimatedSlide(
              offset: _isSearching ? Offset.zero : const Offset(1.2, 0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: _isSearching ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  height: 40.h,
                  margin: EdgeInsets.only(right: 15.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blueGrey.shade700
                        : AppColors.orangeSearch,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controllerSearch,
                          autofocus: _isSearching,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Qidirish...',
                            hintStyle: TextStyle(
                              color: AppColors.white.withAlpha(179),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        InkWell(
                          onTap: () {
                            controllerSearch.clear();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Icon(
                              Icons.clear,
                              color: Colors.white.withAlpha(179),
                              size: 20.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(100.r),
            onTap: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  controllerSearch.clear();
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: SizedBox(
                  height: 40.h,
                  child: SvgPicture.asset(
                    AppIcons.search,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                secondChild: SizedBox(
                  height: 40.h,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                crossFadeState: _isSearching
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidgets(),
      body: BlocProvider(
        create: (context) => CategoriesBLoc(
          categoryRepository: CategoryRepository(client: ApiClient()),
        )..add(CategoriesLoading()),
        child: BlocBuilder<CategoriesBLoc, CategoriesState>(
          builder: (context, state) {
            if (state.status == Status.loading && state.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(21),
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
                            ? AppColors.white.withAlpha(179)
                            : AppColors.black.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state.status == Status.error && state.categories.isEmpty) {
              return Center(
                child: Text(
                  "Xatolik Yuz berdi",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 20.sp,
                  ),
                ),
              );
            }
            final filteredCategories = _searchQuery.isEmpty
                ? state.categories
                : state.categories.where((category) {
                    return category.name.toLowerCase().contains(_searchQuery);
                  }).toList();

            return RefreshIndicator(
              backgroundColor: isDark
                  ? AppColors.darkAppBar
                  : AppColors.primary,
              onRefresh: () async {
                context.read<CategoriesBLoc>().add(CategoriesLoading());
              },
              child: filteredCategories.isEmpty
                  ? _buildEmptySearchResult(isDark)
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.w,
                        vertical: 15.h,
                      ),
                      itemCount: filteredCategories.length,
                      separatorBuilder: (context, index) => Divider(
                        color: isDark ? Colors.white24 : Colors.black12,
                        height: 25.h,
                      ),
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return _buildCategoryItem(
                          context,
                          category,
                          isDark,
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptySearchResult(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80.sp,
            color: isDark
                ? Colors.white.withAlpha(77)
                : Colors.grey.withAlpha(128),
          ),
          SizedBox(height: 16.h),
          Text(
            'Hech narsa topilmadi',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.white.withAlpha(179)
                  : AppColors.black.withAlpha(153),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Boshqa nom bilan qidirib ko\'ring',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark
                  ? AppColors.white.withAlpha(128)
                  : AppColors.black.withAlpha(102),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    dynamic category,
    bool isDark,
  ) {
    final categoryName = category.name;
    final lowerCaseName = categoryName.toLowerCase();
    final queryLower = _searchQuery.toLowerCase();
    final isTablet = MediaQuery.of(context).size.width > 600;
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () => context.push(Routes.categories, extra: category.id),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Hero(
              tag: 'category_${category.id}',
              child: Container(
                height: isTablet ? 55.w : 85.w,
                width: isTablet ? 55.w : 85.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(21),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: CachedNetworkImage(
                    imageUrl: "$baseUrl${category.image}",
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 200),
                    placeholder: (context, url) => Container(
                      color: isDark ? AppColors.darkAppBar : Colors.grey[100],
                      child: Icon(
                        Icons.fastfood,
                        color: AppColors.primary.withAlpha(77),
                        size: 28.sp,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.fastfood,
                      color: AppColors.primary,
                      size: 28.sp,
                    ),
                    // errorWidget: (context, url, error) => Container(
                    //   color: isDark
                    //       ? Colors.grey.shade800
                    //       : Colors.grey.shade300,
                    //   child: Icon(
                    //     Icons.fastfood,
                    //     color: AppColors.primary,
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child:
                  _searchQuery.isNotEmpty && lowerCaseName.contains(queryLower)
                  ? _buildHighlightedText(
                      categoryName,
                      _searchQuery,
                      isDark,
                    )
                  : Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, bool isDark) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.textColor,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.textColor,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, index),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
          ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withAlpha(21),
            ),
          ),
          TextSpan(
            text: text.substring(index + query.length),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
