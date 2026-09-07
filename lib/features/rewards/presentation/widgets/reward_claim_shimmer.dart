import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RewardClaimShimmer extends StatelessWidget {
  const RewardClaimShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Bone(
                  width: 58.w,
                  height: 58.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone(
                        width: double.infinity,
                        height: 15.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 8.h),
                      Bone(
                        width: 130.w,
                        height: 11.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Bone(width: double.infinity, height: 1.h),
            SizedBox(height: 14.h),
            Row(
              children: [
                Bone.circle(size: 20.w),
                SizedBox(width: 8.w),
                Bone(
                  width: 120.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                const Spacer(),
                Bone(
                  width: 70.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Bone(
              width: double.infinity,
              height: 38.h,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ],
        ),
      ),
    );
  }
}