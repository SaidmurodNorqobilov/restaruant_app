import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/features/home/widgets/recipe_widgets.dart';
import '../../common/widgets/appbar_widgets.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<String> breakfastList = [
    'https://i.pinimg.com/736x/2d/64/85/2d6485a63c2af38bee13e5ca13bf42b6.jpg',
    'https://i.pinimg.com/736x/29/cc/61/29cc6154b06aaf45a1276cf460b714a7.jpg',
    'https://www.foodandwine.com/thmb/eN9iNzrq2SrcDOnkR5CJm2dr2A4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/full-english-breakfast-FT-Recipe0225-0bab8edfd24a44b087a3548254dbb409.jpeg',
    'https://i.pinimg.com/736x/56/4a/1d/564a1d27337ce2fff4b15ee2098eceaa.jpg',
    'https://i.pinimg.com/736x/22/4f/f1/224ff168322e1f318852ed49b0937d14.jpg',
  ];

  final List<String> breakfastTitle = [
    'ovqat', 'ovqat1', 'ovqat2', 'ovqa3', 'ovqat4',
  ];

  final List<String> breakfastText = [
    'wegfaergraeg', 'erg er aergg', 'oerg ergrgea2', 'ov reaqaer gerga', 'oregaerg vqat4',
  ];

  final List<double> breakfastPrice = [
    32.00, 23.00, 23.00, 76.00, 100.00,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDesktop = screenWidth > 900;

    int crossAxisCount = 2;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    return Scaffold(
      extendBody: true,
      appBar: const AppBarWidgets(title: 'Breakfast'),
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
        physics: const BouncingScrollPhysics(),
        itemCount: breakfastList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          mainAxisExtent: isTablet ? 320.h : 290.h,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              context.push(Routes.recipeDetails, extra: index);
            },
            child: RecipeWidgets(
              img: breakfastList[index],
              title: breakfastTitle[index],
              text: breakfastText[index],
              price: breakfastPrice[index],
            ),
          );
        },
      ),
    );
  }
}