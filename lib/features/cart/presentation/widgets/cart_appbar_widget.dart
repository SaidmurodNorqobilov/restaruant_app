import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';

class AnimatedSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isDark;
  final String title;
  final TextEditingController searchController;
  final VoidCallback? onSearchToggle;

  const AnimatedSearchAppBar({
    Key? key,
    required this.isDark,
    required this.title,
    required this.searchController,
    this.onSearchToggle,
  }) : super(key: key);

  @override
  State<AnimatedSearchAppBar> createState() => _AnimatedSearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AnimatedSearchAppBarState extends State<AnimatedSearchAppBar> {
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        widget.searchController.clear();
      }
    });
    widget.onSearchToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: widget.isDark ? AppColors.darkAppBar : AppColors.primary,
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
                widget.title,
                key: const ValueKey('TitleText'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
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
                key: const ValueKey('SearchField'),
                height: 40.h,
                margin: EdgeInsets.only(right: 15.w),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? Colors.blueGrey.shade700
                      : AppColors.orangeSearch,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.searchController,
                        autofocus: _isSearching,
                        style: const TextStyle(color: Colors.white),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: context.translate('search'),
                          hintStyle: TextStyle(
                            color: AppColors.white.withAlpha(179),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
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
        InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: _toggleSearch,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: SvgPicture.asset(
                AppIcons.search,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              secondChild: const Icon(Icons.close, color: Colors.white),
              crossFadeState: _isSearching
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ],
    );
  }
}