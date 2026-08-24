import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class InterestedProductShimmer extends StatelessWidget {
  const InterestedProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _ShimmerCard();
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: double.infinity,
                        color: Colors.white,
                      ),

                      SizedBox(height: 8.h),

                      Container(
                        height: 10.h,
                        width: 120.w,
                        color: Colors.white,
                      ),

                      SizedBox(height: 8.h),

                      Container(
                        height: 9.h,
                        width: 90.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                Container(
                  width: 55.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white,
            ),

            SizedBox(height: 14.h),

            Row(
              children: [
                Container(
                  width: 18.w,
                  height: 18.w,
                  color: Colors.white,
                ),

                SizedBox(width: 8.w),

                Container(
                  width: 70.w,
                  height: 11.h,
                  color: Colors.white,
                ),

                const Spacer(),

                Container(
                  width: 30.w,
                  height: 13.h,
                  color: Colors.white,
                ),
              ],
            ),

            SizedBox(height: 14.h),

            Container(
              height: 11.h,
              width: 45.w,
              color: Colors.white,
            ),

            SizedBox(height: 7.h),

            Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            SizedBox(height: 14.h),

            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: 9.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 11.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        width: 130.w,
                        height: 9.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 65.w,
                  height: 9.h,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}