import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShowcaseProductShimmer extends StatelessWidget {
  const ShowcaseProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 265.h,
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Bone(
              width: double.infinity,
              height: 120.h,
              borderRadius: BorderRadius.circular(8.r),
            ),

            SizedBox(height: 10.h),

            Bone(
              width: 60.w,
              height: 18.h,
              borderRadius: BorderRadius.circular(6.r),
            ),

            SizedBox(height: 6.h),

            Bone(
              width: double.infinity,
              height: 13.h,
              borderRadius: BorderRadius.circular(4.r),
            ),

            SizedBox(height: 4.h),

            Bone(
              width: 90.w,
              height: 10.h,
              borderRadius: BorderRadius.circular(4.r),
            ),

            const Spacer(),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone(
                        width: 35.w,
                        height: 9.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 2.h),
                      Bone(
                        width: 60.w,
                        height: 15.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 6.w),

                Bone(
                  width: 78.w,
                  height: 32.h,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
