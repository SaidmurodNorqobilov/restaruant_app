import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/colors.dart';
import '../../Reservations/widgets/text_and_text_field.dart';
import '../../common/widgets/secces_page.dart';
import '../widgets/card_field_data.dart';
import '../widgets/text_field_cvc.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardDataController = TextEditingController();
  final TextEditingController cardCvcController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    cardDataController.dispose();
    cardCvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'Payment Details'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 24.h,
                horizontal: 16.w,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkAppBar : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextAndTextField(
                    controller: nameController,
                    text: 'Name on the card',
                    hintText: 'Enter name',
                  ),
                  SizedBox(height: 16.h),
                  TextAndTextField(
                    controller: cardNumberController,
                    text: 'Card Number',
                    hintText: 'E.g 112232*******12',
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFieldCardData(
                          controller: cardDataController,
                          text: "Expiry Date",
                          hintText: 'MM/YY',
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextFieldCardCvc(
                          controller: cardCvcController,
                          text: "Security Code",
                          hintText: 'CVC',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  TextButtonApp(
                    width: 403,
                    height: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessPage(
                            message: "Your payment has been made successfully",
                            appbarTitle: 'Payment details',
                          ),
                        ),
                      );
                    },
                    text: 'Pay Now',
                    textColor: AppColors.white,
                    buttonColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}