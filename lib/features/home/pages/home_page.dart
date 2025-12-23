import 'package:flutter/material.dart';
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
    'Pizza',
    'Burgers',
  ];

  final List<String> promotionsImg = [
    'https://i.pinimg.com/originals/37/cc/51/37cc518c0d49a2fd03bc93fd151c9ca1.jpg',
    'https://i.pinimg.com/736x/9f/7b/79/9f7b791eb96cffe2766d04204ea1ce50.jpg',
    'https://i.pinimg.com/736x/a6/43/d3/a643d32d686507340fdc4cdd111c14f0.jpg',
  ];
  final List<String> promotionsTitle = [
    'Milk shakes',
    'Artisan Lattes',
    'Special Cake',
  ];
  final List<String> promotionsText = [
    'Banana, chocolate, vanilla, strawberry, caramel/pistachio.',
    'Honey, rose, lavendar, matcha..',
    'Freshly baked delicious cake',
  ];
  final List<double> promotionsPrice = [35.00, 30.00, 70.00];

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
          duration: Duration(milliseconds: 800),
          child: _isSearching
              ? Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 3.h,
                    ),
                    key: const ValueKey('SearchField'),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade700,
                      border: Border.all(
                        color: Colors.black.withOpacity(.2),
                        width: .5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: controllerSearch,
                      onChanged: (text) => debugPrint(text),
                      autofocus: true,
                      cursorColor: Colors.lightBlue.shade300,
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w300,
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColors.white),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close, color: AppColors.white),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isSearching = false;
                              controllerSearch.clear();
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
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
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                    underline: SizedBox(),
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    focusColor: Colors.white,
                    dropdownColor: isDark
                        ? AppColors.darkAppBar
                        : AppColors.primary,
                    value: currentLang,
                    onChanged: (value) async {
                      if (value == null) return;
                      currentLang = value;
                      localization = AppLocalization(value);
                      await localization.load();
                      setState(() {});
                    },
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ru', child: Text('Русский')),
                      DropdownMenuItem(value: 'uz', child: Text('O\'zbek')),
                    ],
                  ),
                ],
              ),
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
      body: SafeArea(
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
                height: isTablet ? 180.h : 220.h,
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
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 220.w : 200.w,
                      ),
                      child: RecipeWidgets(
                        img: promotionsImg[index],
                        title: promotionsTitle[index],
                        text: promotionsText[index],
                        price: promotionsPrice[index],
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
    );
  }
}
