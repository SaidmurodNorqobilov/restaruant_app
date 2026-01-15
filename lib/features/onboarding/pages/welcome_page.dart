import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/onboarding_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> categoryImg = [
    'https://media.istockphoto.com/id/1371064975/ru/%D1%84%D0%BE%D1%82%D0%BE/%D1%82%D1%80%D0%B0%D0%B4%D0%B8%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B9-%D0%BF%D0%BE%D0%BB%D0%BD%D1%8B%D0%B9-%D0%B0%D0%BC%D0%B5%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9-%D0%B7%D0%B0%D0%B2%D1%82%D1%80%D0%B0%D0%BA-%D1%8F%D0%B9%D1%86%D0%B0-%D0%B1%D0%BB%D0%B8%D0%BD%D1%8B-%D1%81-%D0%B1%D0%B5%D0%BA%D0%BE%D0%BD%D0%BE%D0%BC-%D0%B8-%D1%82%D0%BE%D1%81%D1%82%D0%B0%D0%BC%D0%B8.jpg?s=170667a&w=0&k=20&c=ky_smVgMoW2g8v5ncgYONDeaJ2La-eMc39qvssLOBFg=',
    'https://www.shutterstock.com/image-photo/traditional-full-american-breakfast-eggs-600nw-2120331371.jpg',
    'https://d2yoo3qu6vrk5d.cloudfront.net/pulzo-lite/images-resized/PP3893296-h-o.jpg', // Vergul qo'shildi
    'https://i.pinimg.com/originals/a2/f8/98/a2f898641514481941eff885dd2dd5d8.webp',
    'https://www.morningadvertiser.co.uk/resizer/v2/POXGRG2TBFA6FN6JZLG64TWEEQ.jpg?auth=4635af297ddec44de8535360ea3ba256ce3e1937682e9501493fa7bad57405bb&smart=true', // Vergul qo'shildi
    'https://i.pinimg.com/736x/2d/d6/86/2dd68674f14b27b1fdb12a5bf842b0e5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: categoryImg.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                        12.r,
                      ),
                      child: Image.network(
                        categoryImg[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Xush kelibsiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Eng mazali taomlar bir joyda — buyurtma bering va lazzatdan bahramand bo\'ling.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.white.withOpacity(0.8)
                      : AppColors.black.withAlpha(179)
,
                ),
              ),
              SizedBox(height: 30.h),
              TextButtonApp(
                height: 50,
                onPressed: () {
                  context.go(Routes.preferences);
                },
                text: 'Ro\'yxatdan o\'tish',
                textColor: AppColors.white,
                buttonColor: AppColors.primary,
              ),
              SizedBox(height: 12.h),
              TextButtonApp(
                height: 50,
                onPressed: () async {
                  await OnboardingService.setOnboardingSeen();
                  if (mounted) {
                    context.go(Routes.home);
                  }
                },
                text: 'Keyinroq',
                textColor: AppColors.white,
                buttonColor: AppColors.primary,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
