import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InterestedProductShimmer extends StatelessWidget {
  const InterestedProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, __) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Bone(
                width: 52.w,
                height: 52.w,
                borderRadius: BorderRadius.circular(12.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone(
                      width: double.infinity,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 8.h),
                    Bone(
                      width: 120.w,
                      height: 10.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 8.h),
                    Bone(
                      width: 90.w,
                      height: 9.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Bone(
                width: 55.w,
                height: 24.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Bone(width: double.infinity, height: 1.h),
          SizedBox(height: 14.h),
          Row(
            children: [
              Bone.square(size: 18.w),
              SizedBox(width: 8.w),
              Bone(
                width: 70.w,
                height: 11.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              const Spacer(),
              Bone(
                width: 30.w,
                height: 13.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Bone(
            width: 45.w,
            height: 11.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 7.h),
          Bone(
            width: double.infinity,
            height: 45.h,
            borderRadius: BorderRadius.circular(10.r),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Bone.circle(size: 36.w),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone(
                      width: 100.w,
                      height: 11.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 5.h),
                    Bone(
                      width: 130.w,
                      height: 9.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
              Bone(
                width: 65.w,
                height: 9.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}