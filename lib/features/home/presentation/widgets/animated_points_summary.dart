import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/home/presentation/widgets/animated_point_item.dart';

class AnimatedPointsSummary extends StatelessWidget {
  const AnimatedPointsSummary({
    super.key,
    required this.totalEarned,
    required this.requiredPoints,
    required this.pendingPoints,
    required this.showSchemaPoints,
  });

  final int totalEarned;
  final int requiredPoints;
  final int pendingPoints;
  final bool showSchemaPoints;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Points',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: AnimatedPointItem(
                          icon: Icons.trending_up_rounded,
                          title: 'Total Earned',
                          value: totalEarned,
                        ),
                      ),

                      Expanded(
                        child: AnimatedPointItem(
                          icon: Icons.access_time_rounded,
                          title: 'Pending',
                          value: pendingPoints,
                        ),
                      ),

                      Expanded(
                        child: AnimatedPointItem(
                          icon: Icons.stars_rounded,
                          title: 'Available',
                          value: requiredPoints,
                        ),
                      ),
                       if (showSchemaPoints)
                        Expanded(
                          child: AnimatedPointItem(
                            icon: Icons.card_giftcard_rounded,
                            title: 'Schema',
                            value: 100,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}