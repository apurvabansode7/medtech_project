import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isLoading = false,
    required this.onSubscribeTap,
    this.showSubscribeButton = false,
    this.pointsAvailable,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onSubscribeTap;
  final bool isLoading;

  final bool showSubscribeButton;
  final int? pointsAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 150.h,
      margin: EdgeInsets.only(right: 12.w),
      //  clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.textSecondary, AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Row(
              children: [
                // Left Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      
                      // Small label
                      Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: 6.w),

                          Text(
                            'SPECIAL OFFER',
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: 0.75),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 7.h),

                      // Title
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      // Description
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.78),
                          fontSize: 11.sp,
                          height: 1.3,
                        ),
                      ),
                      if (pointsAvailable != null) ...[
                        SizedBox(height: 6.h),

                        Text(
                          'Points Available: $pointsAvailable',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],

                      SizedBox(height: 10.h),

                      if (showSubscribeButton) ...[
                        SizedBox(height: 10.h),

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isLoading ? null : onSubscribeTap,
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 13.w,
                                vertical: 7.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isLoading)
                                    SizedBox(
                                      width: 13.w,
                                      height: 13.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  else ...[
                                    Text(
                                      'Subscribe Now',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 13.sp,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // Product / Reward Icon
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.13),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(icon, size: 38.sp, color: AppColors.white),

                      // Small badge
                      Positioned(
                        right: 2.w,
                        top: 2.h,
                        child: Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.textSecondary,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            size: 13.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
