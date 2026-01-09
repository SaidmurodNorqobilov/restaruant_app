import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';
import '../../common/manager/langBloc/language_bloc.dart';
import '../../common/manager/langBloc/language_event.dart';
import '../../common/manager/langBloc/language_state.dart';

class HomePageAppbar extends StatefulWidget implements PreferredSizeWidget {
  const HomePageAppbar({super.key});

  @override
  State<HomePageAppbar> createState() => _HomePageAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomePageAppbarState extends State<HomePageAppbar> {
  final TextEditingController controllerSearch = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.white),
      backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
      titleSpacing: 0,
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedSlide(
            offset: _isSearching ? const Offset(-1.2, 0) : Offset.zero,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              opacity: _isSearching ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                "ATS",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          AnimatedSlide(
            offset: _isSearching ? Offset.zero : const Offset(1.2, 0),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              opacity: _isSearching ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                height: 40.h,
                margin: EdgeInsets.only(right: 15.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.blueGrey.shade700
                      : AppColors.orangeSearch,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controllerSearch,
                        autofocus: _isSearching,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (!_isSearching)
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, langState) {
              return DropdownButton<String>(
                dropdownColor: isDark
                    ? AppColors.darkAppBar
                    : AppColors.primary,
                value: langState.languageCode,
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  if (value != null) {
                    context.read<LanguageBloc>().add(LanguageChanged(value));
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'ru',
                    child: Text('Русский '),
                  ),
                  DropdownMenuItem(
                    value: 'uz',
                    child: Text('O\'zbek'),
                  ),
                ],
              );
            },
          ),
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                controllerSearch.clear();
              }
            });
          },
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
