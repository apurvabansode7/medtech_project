import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

class AnimatedPointItem extends StatelessWidget {
  const AnimatedPointItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, animatedValue, child) {
        return Column(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 6.h),
            Text(
              '${animatedValue.toInt()}',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}