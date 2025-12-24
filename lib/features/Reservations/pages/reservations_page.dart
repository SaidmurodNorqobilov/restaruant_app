import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/Reservations/widgets/text_and_text_field.dart';
import 'package:restaurantapp/features/common/widgets/secces_page.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController reservationTimeController =
      TextEditingController();
  final TextEditingController specialController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    reservationTimeController.dispose();
    specialController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarHome(
        title: Text(context.translate('reservation')),
      ),
      drawer: const DrawerWidgets(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reserve your table',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'View my reservations',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkAppBar : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextAndTextField(
                      controller: nameController,
                      text: 'Name',
                      hintText: 'Enter your name',
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: emailController,
                      text: 'Email',
                      hintText: 'Enter email',
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: phoneNumberController,
                      text: 'Phone Number',
                      hintText: 'Enter phone number',
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Number of guests',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      width: 160.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        color: isDark
                            ? AppColors.black
                            : AppColors.backgroundLightColor,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 20),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                dropdownColor: isDark
                                    ? AppColors.darkAppBar
                                    : AppColors.white,
                                value: currentPerson,
                                onChanged: (value) =>
                                    setState(() => currentPerson = value!),
                                items: personList.map((person) {
                                  return DropdownMenuItem<int>(
                                    value: person.value,
                                    child: Text(
                                      person.label,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: reservationTimeController,
                      text: 'Reservation time',
                      hintText: 'Enter time',
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: specialController,
                      text: 'Special note',
                      hintText: 'Special note',
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: dateController,
                      text: 'Date',
                      hintText: 'Select date',
                      prefixIcon: InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: isDark
                                      ? const ColorScheme.dark(
                                          primary: AppColors.primary,
                                          onPrimary: Colors.white,
                                          surface: AppColors.darkAppBar,
                                          onSurface: Colors.white,
                                        )
                                      : const ColorScheme.light(
                                          primary: AppColors.primary,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: AppColors.textColor,
                                        ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}/"
                                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                                  "${pickedDate.year}";
                            });
                          }
                        },
                        child: const Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: TextButtonApp(
                  width: 272,
                  height: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessPage(
                          onBackPressed: () => Navigator.pop(context),
                          message:
                              "Your reservation has been made successfully",
                          appbarTitle: 'Reservation',
                        ),
                      ),
                    );
                  },
                  text: 'Submit',
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonOption {
  final int value;
  final String label;

  PersonOption(this.value, this.label);
}

List<PersonOption> personList = [
  PersonOption(1, '1 person'),
  PersonOption(2, '2 persons'),
  PersonOption(3, '3 (max)'),
];

int currentPerson = 3;
