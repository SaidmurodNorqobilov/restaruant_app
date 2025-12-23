import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import 'package:restaurantapp/main.dart';

import '../../../core/utils/icons.dart';
import '../../common/widgets/bottom_navigation_bar_app.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      appBar: AppBarHome(
        title: Text(localization.translate("menuBottom"),),
        actions: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              AppIcons.search,
              width: 18.w,
              height: 18.h,
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(
            width: 10.w,
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
                              color: isDark ? AppColors.white : AppColors.textColor,
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
