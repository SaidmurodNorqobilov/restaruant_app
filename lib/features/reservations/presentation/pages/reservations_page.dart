import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/network/client.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../../../core/utils/status.dart';
import '../../../../core/widgets/drawer_widgets.dart';
import '../../../account/presentation/bloc/userBloc/user_profile_bloc.dart';
import '../../../account/presentation/bloc/userBloc/user_profile_state.dart';
import '../../../menu/presentation/widgets/app_bar_home.dart';
import '../../data/repositories/reservations_repository.dart';
import '../bloc/reservation_bloc.dart';
import '../bloc/reservation_state.dart';
import '../widgets/reservation_submit_button.dart';
import '../widgets/validated_text_field_widget.dart';

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

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = '+998';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    reservationTimeController.dispose();
    specialController.dispose();
    super.dispose();
  }

  String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Ism kiriting';
    }
    if (name.length < 3) {
      return 'Ism kamida 3 ta belgidan iborat bo\'lishi kerak';
    }
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s]+$').hasMatch(name)) {
      return 'Ism faqat harflardan iborat bo\'lishi kerak';
    }
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email kiriting';
    }
    if (!email.contains('@')) {
      return 'Email @ belgisini o\'z ichiga olishi kerak';
    }
    String username = email.split('@')[0];
    if (username.length < 5) {
      return 'Email nomi kamida 5 ta belgidan iborat bo\'lishi kerak';
    }
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      return 'Faqat @gmail.com manzillar qabul qilinadi';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]{5,}@gmail\.com$');
    if (!emailRegex.hasMatch(email.toLowerCase())) {
      return 'Email formati noto\'g\'ri';
    }
    return null;
  }

  String? _validatePhoneNumber(String phone) {
    if (phone.isEmpty || phone == '+998') {
      return 'Telefon raqam kiriting';
    }
    if (!phone.startsWith('+998')) {
      return 'Telefon raqam +998 bilan boshlanishi kerak';
    }
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.length != 13) {
      return 'Telefon raqam to\'liq emas (+998XXXXXXXXX)';
    }
    String operatorCode = cleanPhone.substring(4, 6);
    List<String> validCodes = [
      '90',
      '91',
      '93',
      '94',
      '95',
      '97',
      '98',
      '99',
      '33',
      '88',
      '77',
    ];

    if (!validCodes.contains(operatorCode)) {
      return 'Noto\'g\'ri operator kodi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBarHome(title: Text(context.translate('reservation'))),
      drawer: const DrawerWidgets(),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userState) => SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
            child: BlocProvider(
              create: (context) => ReservationBloc(
                repository: ReservationRepository(
                  client: ApiClient(),
                ),
              ),
              child: BlocConsumer<ReservationBloc, ReservationState>(
                listener: (context, state) {
                  if (state.status == Status.success) {
                    nameController.clear();
                    emailController.clear();
                    phoneNumberController.text = '+998';
                    reservationTimeController.clear();
                    specialController.clear();
                    setState(() => currentPerson = 3);
                  } else if (state.status == Status.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ?? 'Xatolik yuz berdi',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            context.translate('reserveYourTable'),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            context.push(Routes.myReservations);
                          },
                          icon: Icon(
                            Icons.list_alt,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          label: Text(
                            'Mening\nbronlarim',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 24.h,
                        horizontal: 16.w,
                      ),
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
                          ValidatedTextField(
                            controller: nameController,
                            text: context.translate('name'),
                            hintText: context.translate('inputName'),
                            validator: _validateName,
                          ),
                          SizedBox(height: 15.h),
                          ValidatedTextField(
                            controller: emailController,
                            text: 'Email',
                            hintText: 'example@gmail.com',
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 15.h),
                          ValidatedTextField(
                            controller: phoneNumberController,
                            text: context.translate('phoneNumber'),
                            hintText: '+998901234567',
                            validator: _validatePhoneNumber,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d+]'),
                              ),
                              LengthLimitingTextInputFormatter(13),
                              TextInputFormatter.withFunction((
                                oldValue,
                                newValue,
                              ) {
                                if (newValue.text.isEmpty) {
                                  return const TextEditingValue(text: '+998');
                                }
                                if (!newValue.text.startsWith('+998')) {
                                  return oldValue;
                                }
                                return newValue;
                              }),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            context.translate('numberOfGuests'),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
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
                                  ? Colors.blueGrey
                                  : AppColors.lightDivider,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textColor,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      dropdownColor: isDark
                                          ? AppColors.darkAppBar
                                          : AppColors.lightDivider,
                                      value: currentPerson,
                                      onChanged: (value) => setState(
                                        () => currentPerson = value!,
                                      ),
                                      items: personList
                                          .map(
                                            (person) => DropdownMenuItem<int>(
                                              value: person.value,
                                              child: Text(
                                                person.label,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.textColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.h),
                          GestureDetector(
                            onTap: () {
                              picker.DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                onConfirm: (date) {
                                  setState(() {
                                    reservationTimeController.text = date
                                        .toIso8601String();
                                  });
                                },
                                locale: picker.LocaleType.en,
                                theme: picker.DatePickerTheme(
                                  backgroundColor: isDark
                                      ? AppColors.darkAppBar
                                      : Colors.white,
                                  itemStyle: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  doneStyle: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            child: AbsorbPointer(
                              child: ValidatedTextField(
                                controller: reservationTimeController,
                                text: context.translate('reservationTime'),
                                hintText: context.translate('enterTime'),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          ValidatedTextField(
                            controller: specialController,
                            text: context.translate('specialNote'),
                            hintText: context.translate('specialNote'),
                            maxLines: 3,
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ReservationSubmitButton(
                      nameController: nameController,
                      emailController: emailController,
                      phoneNumberController: phoneNumberController,
                      reservationTimeController: reservationTimeController,
                      specialController: specialController,
                      currentPerson: currentPerson,
                      isDark: isDark,
                      isTablet: isTablet,
                      userState: userState,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
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
