import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

class PointsSummaryCard extends StatelessWidget {
  const PointsSummaryCard({
    super.key,
    required this.totalEarnedPoints,
    required this.earnedPoints,
    required this.pendingPoints,
    required this.schemaTotalPoints,
    required this.schemaEarnedPoints,
    required this.schemaPendingPoints,
  });

  final int totalEarnedPoints;
  final int earnedPoints;
  final int pendingPoints;

  final int schemaTotalPoints;
  final int schemaEarnedPoints;
  final int schemaPendingPoints;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child:
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            _SectionHeader(
              title: 'Points',
            ),

         
            _AnimatedPointRow(
              title: 'Total Earned',
              value: totalEarnedPoints,
              duration: const Duration(milliseconds: 800),
             
            ),

            _AnimatedPointRow(
              title: 'Available',
              value: earnedPoints,
              duration: const Duration(milliseconds: 900),
            ),

            _AnimatedPointRow(
              title: 'Pending',
              value: pendingPoints,
              duration: const Duration(milliseconds: 1000),
             
            ),

            const _SectionHeader(
              title: 'Schema',
            ),

          

            _AnimatedPointRow(
              title: 'Schema Total',
              value: schemaTotalPoints,
              duration: const Duration(milliseconds: 1100),
            ),

            _AnimatedPointRow(
              title: 'Schema Earned',
              value: schemaEarnedPoints,
              duration: const Duration(milliseconds: 1200),
            
            ),

            _AnimatedPointRow(
              title: 'Schema Pending ',
              value: schemaPendingPoints,
              duration: const Duration(milliseconds: 1300),
              
            ),
          ],
        ),
      ),
    );
  }
}



class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),

        SizedBox(width: 8.w),

        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}


class _AnimatedPointRow extends StatelessWidget {
  const _AnimatedPointRow({
    required this.title,
    required this.value,
    required this.duration,
    this.valueColor,
  });

  final String title;
  final int value;
  final Duration duration;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          SizedBox(
            width: 70.w,
            child: Align(
              alignment: Alignment.centerRight,
              child: TweenAnimationBuilder<int>(
                key: ValueKey(value),
                tween: IntTween(
                  begin: 0,
                  end: value,
                ),
                duration: duration,
                curve: Curves.easeOut,
                builder: (
                  context,
                  animatedValue,
                  child,
                ) {
                  return Text(
                    animatedValue.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}