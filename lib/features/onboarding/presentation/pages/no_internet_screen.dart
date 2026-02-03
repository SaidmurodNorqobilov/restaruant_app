import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  bool _isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = _isTablet(context);
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ]
                : [
              const Color(0xFFF8F9FA),
              const Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: SafeArea(
          child: isLandscape && isTablet
              ? _buildLandscapeLayout(context, isDark, isTablet)
              : _buildPortraitLayout(context, isDark, isTablet),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, bool isDark, bool isTablet) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(isDark, isTablet),
            SizedBox(height: isTablet ? 20.h : 40.h),
            _buildTitle(isDark, isTablet),
            SizedBox(height: isTablet ? 10.h : 16.h),
            _buildDescription(isDark, isTablet),
            SizedBox(height: isTablet ? 20.h : 50.h),
            _RetryButton(isTablet: isTablet),
            SizedBox(height: isTablet ? 40.h : 30.h),
            _buildInfoCard(isDark, isTablet),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, bool isDark, bool isTablet) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAnimatedIcon(isDark, isTablet),
                    SizedBox(height: 40.h),
                    _RetryButton(isTablet: isTablet),
                  ],
                ),
              ),
              SizedBox(width: 60.w),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(isDark, isTablet, textAlign: TextAlign.left),
                    SizedBox(height: 20.h),
                    _buildDescription(isDark, isTablet, textAlign: TextAlign.left),
                    SizedBox(height: 40.h),
                    _buildInfoCard(isDark, isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(bool isDark, bool isTablet) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: EdgeInsets.all(isTablet ? 30.w : 40.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.white.withAlpha(21)
 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(21)
,
                  blurRadius: isTablet ? 30 : 20,
                  offset: Offset(0, isTablet ? 15 : 10),
                ),
              ],
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              size: isTablet ? 70.sp : 80.sp,
              color: isDark
                  ? Colors.white.withAlpha(204)
                  : const Color(0xFF6C757D),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(bool isDark, bool isTablet, {TextAlign? textAlign}) {
    return Text(
      'Internet aloqasi yo\'q',
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontSize: isTablet ? 22.sp : 24.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF212529),
      ),
    );
  }

  Widget _buildDescription(bool isDark, bool isTablet, {TextAlign? textAlign}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 80.w : 50.w),
      child: Text(
        'Iltimos, internet aloqangizni tekshiring va qaytadan urinib ko\'ring',
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(
          fontSize: isTablet ? 10.sp : 16.sp,
          color: isDark
              ? Colors.white.withAlpha(179)

              : const Color(0xFF6C757D),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 60.w : 40.w),
      padding: EdgeInsets.all(isTablet ? 20.w : 20.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withAlpha(13)
            : Colors.white.withAlpha(128)
,
        borderRadius: BorderRadius.circular(isTablet ? 20.r : 16.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(21)

              : Colors.black.withAlpha(13),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.settings_rounded,
            text: 'Wi-Fi yoki mobil internetni yoqing',
            isDark: isDark,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 16.h : 12.h),
          _InfoRow(
            icon: Icons.signal_cellular_alt_rounded,
            text: 'Signal quvvatini tekshiring',
            isDark: isDark,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 16.h : 12.h),
          _InfoRow(
            icon: Icons.router_rounded,
            text: 'Routerni qayta ishga tushiring',
            isDark: isDark,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }
}

class _RetryButton extends StatefulWidget {
  final bool isTablet;

  const _RetryButton({this.isTablet = false});

  @override
  State<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<_RetryButton> {
  bool _isChecking = false;

  Future<void> _checkConnection() async {
    setState(() => _isChecking = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isChecking ? null : _checkConnection,
        borderRadius: BorderRadius.circular(widget.isTablet ? 40.r : 30.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 50.w : 40.w,
            vertical: widget.isTablet ? 20.h : 16.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isChecking
                  ? [
                Colors.grey.withAlpha(128)
,
                Colors.grey.withAlpha(77)
,
              ]
                  : [
                const Color(0xFF4CAF50),
                const Color(0xFF45A049),
              ],
            ),
            borderRadius: BorderRadius.circular(widget.isTablet ? 40.r : 30.r),
            boxShadow: _isChecking
                ? []
                : [
              BoxShadow(
                color: const Color(0xFF4CAF50).withAlpha(77)
,
                blurRadius: widget.isTablet ? 20 : 15,
                offset: Offset(0, widget.isTablet ? 10 : 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isChecking)
                SizedBox(
                  width: widget.isTablet ? 24.w : 20.w,
                  height: widget.isTablet ? 24.w : 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: widget.isTablet ? 24.sp : 24.sp,
                ),
              SizedBox(width: widget.isTablet ? 14.w : 12.w),
              Text(
                _isChecking ? 'Tekshirilmoqda...' : 'Qayta urinish',
                style: TextStyle(
                  fontSize: widget.isTablet ? 14.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  final bool isTablet;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.isDark,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 20.sp : 20.sp,
          color: isDark
              ? Colors.white.withAlpha(153)
              : const Color(0xFF6C757D),
        ),
        SizedBox(width: isTablet ? 12.w : 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 14.sp : 14.sp,
              color: isDark
                  ? Colors.white.withAlpha(179)

                  : const Color(0xFF6C757D),
            ),
          ),
        ),
      ],
    );
  }
}