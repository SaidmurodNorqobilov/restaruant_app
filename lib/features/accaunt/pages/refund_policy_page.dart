import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';

class RefundPolicyPage extends StatefulWidget {
  const RefundPolicyPage({super.key});

  @override
  State<RefundPolicyPage> createState() => _RefundPolicyPageState();
}

class _RefundPolicyPageState extends State<RefundPolicyPage> {
  String text = """ RETURNS
Our policy lasts 7 days. If 7 days have gone by since your purchase, unfortunately, we can’t offer you a refund or exchange.
To be eligible for a return, your item must be unused and in the same condition that you received it. It must also be in the original packaging.
Several types of goods are exempt from being returned. Perishable goods such as food, flowers, newspapers, or magazines cannot be returned. We also do not accept products that are intimate or sanitary goods, hazardous materials, or flammable liquids or gases.
Refunds will be done only through the Original Mode of Payment.
Additional non-returnable items:
Gift cards
Downloadable software products
Some health and personal care items 
To complete your return, we require a receipt or proof of purchase.
Please do not send your purchase back to the manufacturer.
There are certain situations where only partial refunds are granted: (if applicable)
* Book with obvious signs of use
* CD, DVD, VHS tape, software, video game, cassette tape, or vinyl record that has been opened.
* Any item not in its original condition, is damaged or missing parts for reasons not due to our error.
* Any item that is returned more than 30 days after delivery
 
Refunds (if applicable)
Once your return is received and inspected, we will send you an email to notify you that we have received your returned item. We will also notify you of the approval or rejection of your refund.
If you are approved, then your refund will be processed, and a credit will automatically be applied to your credit card or original method of payment, within a certain amount of days.""";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'Refund policy'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 33.w,
              vertical: 42.h,
            ),
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
