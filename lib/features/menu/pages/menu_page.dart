import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import '../../../core/utils/icons.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController controllerSearch = TextEditingController();

  List categoryImg = [
    'assets/categoryImg/category1.png',
    'assets/categoryImg/category2.png',
    'assets/categoryImg/category3.png',
    'assets/categoryImg/category4.png',
    'assets/categoryImg/category5.png',
    'assets/categoryImg/category6.png',
    'assets/categoryImg/category6.png',
    'assets/categoryImg/category6.png',
  ];

  List categoryText = [
    'Breakfast',
    'Appetizers',
    'Soups/salad',
    'Main Course',
    'Desserts',
    'Drinks',
    'For Kids',
    'Pasta',
  ];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
        titleSpacing: _isSearching ? 10.w : 0,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 2.h,
                    ),
                    key: const ValueKey('SearchField'),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blueGrey.shade700
                          : AppColors.orangeSearch,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: controllerSearch,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: AppColors.white),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSearching = false;
                              controllerSearch.clear();
                            });
                          },
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                )
              : Text(
                  context.translate("menuBottom"),
                  key: const ValueKey('titleMode'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        actions: [
          if (!_isSearching)
            InkWell(
              borderRadius: BorderRadius.circular(100.r),
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: SvgPicture.asset(
                  AppIcons.search,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: DrawerWidgets(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 19.w,
            vertical: 10.h,
          ),
          child: Column(
            spacing: 10.h,
            children: [
              ...List.generate(categoryText.length, (index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        context.push(Routes.categories);
                      },
                      child: Row(
                        spacing: 18.w,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(
                              15.r,
                            ),
                            child: Image.asset(
                              categoryImg[index],
                              width: 80.w,
                              height: 80.h,
                            ),
                          ),
                          Text(
                            categoryText[index],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.black,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
