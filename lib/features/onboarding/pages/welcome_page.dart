import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  
  List categoryImg = [
    'assets/categoryImg/category1.png',
    'assets/categoryImg/category2.png',
    'assets/categoryImg/category3.png',
    'assets/categoryImg/category4.png',
    'assets/categoryImg/category5.png',
    'assets/categoryImg/category6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightColor,
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 38.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: categoryImg.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    categoryImg[index],
                    fit: BoxFit.cover,
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
              ),
            ),
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Text(
              'Find the best recipes that the world can provide you also with every step that you can learn to increase your cooking skills.',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Column(
              spacing: 10.h,
              children: [
                TextButtonApp(
                  height: 50,
                  onPressed: () {
                    context.go(Routes.preferences);
                  },
                  text: 'I’m New',
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
                TextButtonApp(
                  height: 50,
                  onPressed: () {
                    context.go(Routes.home);
                  },
                  text: 'I’ve been here',
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
