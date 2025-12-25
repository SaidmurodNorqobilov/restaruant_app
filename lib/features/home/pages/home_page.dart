import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/icons.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/home/widgets/recipe_widgets.dart';
import '../../../core/utils/language.dart';
import '../../../core/utils/colors.dart';
import '../../../main.dart';
import '../../common/manager/langBloc/language_bloc.dart';
import '../../common/manager/langBloc/language_event.dart';
import '../../common/manager/langBloc/language_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controllerSearch = TextEditingController();

  final List<String> categoryImg = [
    'assets/categoryImg/category1.png',
    'assets/categoryImg/category2.png',
    'assets/categoryImg/category3.png',
    'assets/categoryImg/category4.png',
    'assets/categoryImg/category5.png',
    'assets/categoryImg/category6.png',
    'assets/categoryImg/category6.png',
    'assets/categoryImg/category6.png',
    'assets/categoryImg/category6.png',
  ];

  final List<String> categoryText = [
    'Breakfast',
    'Appetizers',
    'Soups/salad',
    'Main Course',
    'Desserts',
    'Drinks',
    'For Kids',
    'Pasta',
    'Burgers',
  ];

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
    'ovqat karochi',
  ];
  final List<String> promotionsText = [
    'Banana, chocolate, vanilla, strawberry, caramel/pistachio.',
    'Honey, rose, lavendar, matcha..',
    'Freshly baked delicious cake',
    'test uchun',
  ];
  final List<double> promotionsPrice = [35.00, 30.00, 70.00, 1000.00];

  String currentLang = 'en';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
        titleSpacing: 0,
        title: AnimatedSwitcher(
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          duration: Duration(milliseconds: 300),
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
                  'ATS',
                  key: const ValueKey('TitleText'),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        actions: [
          if (!_isSearching)
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, langState) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                        underline: const SizedBox(),
                        iconDisabledColor: Colors.white,
                        iconEnabledColor: Colors.white,
                        focusColor: Colors.white,
                        dropdownColor: isDark
                            ? AppColors.darkAppBar
                            : AppColors.primary,
                        value: langState.languageCode,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<LanguageBloc>().add(
                              LanguageChanged(value),
                            );
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'ru', child: Text('Русский')),
                          DropdownMenuItem(value: 'uz', child: Text('O\'zbek')),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          if (!_isSearching)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Icon(
                Icons.language,
                color: Colors.white,
              ),
            ),

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
      body: RefreshIndicator(
        color: isDark ? AppColors.darkAppBar : AppColors.primary,
        onRefresh: () async {},
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                  child: Text(
                    'Meal categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isTablet ? 20.sp : 18.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: isTablet ? 200.h : 220.h,
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categoryImg.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15.w,
                      crossAxisSpacing: 10.h,
                      childAspectRatio: isTablet ? 0.7 : 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => context.push(Routes.categories),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: isTablet ? 60.h : 65.w,
                              width: isTablet ? 60.h : 65.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.r),
                                child: Image.asset(
                                  categoryImg[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Flexible(
                              child: Text(
                                categoryText[index],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isTablet ? 11.sp : 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Promotions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isTablet ? 20.sp : 18.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  height: isTablet ? 280.h : 260.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: promotionsImg.length,
                    separatorBuilder: (context, index) => SizedBox(width: 15.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(Routes.promotions, extra: 1);
                        },
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
                      );
                    },
                  ),
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Yana nimadurlar )',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isTablet ? 20.sp : 18.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  height: isTablet ? 280.h : 260.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: promotionsImg.length,
                    separatorBuilder: (context, index) => SizedBox(width: 15.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(Routes.promotions, extra: 1);
                        },
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
                      );
                    },
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
