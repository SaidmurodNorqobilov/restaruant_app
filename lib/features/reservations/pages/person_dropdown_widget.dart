import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/data/repositories/reservations_repository.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_bloc.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_state.dart';

import '../../../core/utils/status.dart';

class PersonDropDownWidget extends StatefulWidget {
  const PersonDropDownWidget({
    super.key,
  });

  @override
  State<PersonDropDownWidget> createState() => _PersonDropDownWidgetState();
}

class _PersonDropDownWidgetState extends State<PersonDropDownWidget> {


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      width: 160.w,
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: isDark ? Colors.blueGrey : AppColors.backgroundLightColor,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            size: 20,
            color: AppColors.white,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                dropdownColor: isDark
                    ? AppColors.darkAppBar
                    : AppColors.primary,
                value: currentPerson,
                onChanged: (value) => setState(() => currentPerson = value!),
                items: personList
                    .map(
                      (person) => DropdownMenuItem<int>(
                        value: person.value,
                        child: Text(
                          person.label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
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
