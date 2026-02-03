import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../onboarding/presentation/widgets/text_button_app.dart';
import '../../../reservations/presentation/widgets/text_and_text_field.dart';

class TipWaiterWidget extends StatefulWidget {

  const TipWaiterWidget({super.key});

  @override
  State<TipWaiterWidget> createState() => _TipWaiterWidgetState();
}

class _TipWaiterWidgetState extends State<TipWaiterWidget> {

  final TextEditingController tipController = TextEditingController();
  final TextEditingController controllerPromo = TextEditingController();
  final TextEditingController controllerSearch = TextEditingController();
  late AnimationController _animationController;

  final List<String> cartAddProducts = [
    'https://static.toiimg.com/photo/102941656.cms',
    'https://townsquare.media/site/385/files/2023/06/attachment-milkshake-.jpg?w=1200&q=75&format=natural',
    'https://i.pinimg.com/originals/32/07/8e/32078e4d3c1e9edb4d76dba9a419f71f.jpg',
  ];

  final List<String> cartAddTitle = [
    'Provencal Breakf',
    '2 Provencal Breakf',
    '2 Provencal Breakf',
  ];

  final List<double> cartAddPrice = [
    20.0,
    70.0,
    50.0,
  ];
  List<int> quantities = [];
  final List<String> tableList = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
    'Table 6',
    'Table 7',
    'Table 8',
  ];

  String selectedTable = 'Table 1';
  bool isCouponApplied = false;

  @override
  void initState() {
    super.initState();
    quantities = List.generate(cartAddProducts.length, (index) => 1);
    tipController.addListener(() {
      if (mounted) setState(() {});
    });
    // _animationController = AnimationController(
    //   vsync:  ,
    //   duration: const Duration(seconds: 3),
    // )..repeat();
  }

  @override
  void dispose() {
    tipController.removeListener(() {});
    tipController.dispose();
    _animationController.dispose();
    controllerPromo.dispose();
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          final color = Color.lerp(
            AppColors.primary,
            Colors.orange,
            _animationController.value,
          )!;
          return InkWell(
            onTap: () {
              final isDark =
                  Theme.of(
                    context,
                  ).brightness ==
                      Brightness.dark;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: isDark
                    ? AppColors.darkAppBar
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(
                    top: Radius.circular(
                      25.r,
                    ),
                  ),
                ),
                builder: (context) => Padding(
                  padding:
                  EdgeInsets.fromLTRB(
                    24.w,
                    16.h,
                    24.w,
                    MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                        24.h,
                  ),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[300],
                          borderRadius:
                          BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      DropdownButtonFormField<
                          String
                      >(
                        dropdownColor: isDark
                            ? AppColors
                            .darkAppBar
                            : Colors.white,
                        value: selectedTable,
                        decoration: InputDecoration(
                          labelText: context
                              .translate(
                            'selectTable',
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12.r,
                            ),
                          ),
                        ),
                        items: tableList
                            .map(
                              (e) =>
                              DropdownMenuItem(
                                value: e,
                                child:
                                Text(
                                  e,
                                ),
                              ),
                        )
                            .toList(),
                        onChanged: (val) {
                          if (mounted &&
                              val != null) {
                            setState(
                                  () =>
                              selectedTable =
                                  val,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextAndTextField(
                        controller:
                        tipController,
                        text: context
                            .translate(
                          'Pricing',
                        ),
                        hintText:
                        'SO\'M 10.00',
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width:
                        double.infinity,
                        child: TextButtonApp(
                          onPressed: () {
                            if (mounted) {
                              Navigator.pop(
                              context,
                            );
                            }
                          },
                          text: context
                              .translate(
                            'applyCoupon',
                          ),
                          buttonColor:
                          AppColors
                              .primary,
                          textColor:
                          AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            borderRadius:
            BorderRadius.circular(12.r),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: color.withOpacity(
                    0.6,
                  ),
                  width: 1.5,
                ),
                borderRadius:
                BorderRadius.circular(
                  12.r,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.volunteer_activism,
                    color: color,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    context.translate(
                      'tipWaiter',
                    ),
                    style: TextStyle(
                      color: color,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
