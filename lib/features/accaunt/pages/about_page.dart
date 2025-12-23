import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';

import '../../../core/utils/colors.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String text = """ATS is a new place in town!!!
We understand how people interact in the digital space. The ATS team is a diverse medley of right-and left-brain thinkers; we are strategists, designers, sociologists, programmers, digital engineers and above all, innovators. This combination of talent fosters a rare level of insight, enabling us to build exceptional experiences for effective brand communication.  
Founder of eMENU""";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'About Us'),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: 33.w,
          vertical: 42.h,
        ),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
