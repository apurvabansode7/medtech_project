import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AvailableRewardShimmer extends StatelessWidget {
  const AvailableRewardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        width: double.infinity,
        height: 290.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: double.infinity,
              height: 115.h,
              borderRadius: BorderRadius.circular(8.r),
            ),
            SizedBox(height: 8.h),
            Bone(
              width: 60.w,
              height: 14.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            SizedBox(height: 6.h),
            Bone(
              width: double.infinity,
              height: 14.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            SizedBox(height: 6.h),
            Bone(
              width: 80.w,
              height: 12.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            const Spacer(),
            Bone(
              width: double.infinity,
              height: 32.h,
              borderRadius: BorderRadius.circular(7.r),
            ),
          ],
        ),
      ),
    );
  }
}
