import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(),
              SizedBox(height: 14.h),
              _profileHeader(),
              SizedBox(height: 22.h),
              _section('Personal Information', 6),
              SizedBox(height: 22.h),
              _section('Account Information', 5),
              SizedBox(height: 22.h),
              _section('Wallet', 2),
              SizedBox(height: 22.h),
              _section('Medical Representative', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Bone(
        width: 90.w,
        height: 24.h,
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Bone.circle(size: 58.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 130.w,
                  height: 17.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 7.h),
                Bone(
                  width: 160.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                Bone(
                  width: 100.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
          Bone.circle(size: 38.w),
        ],
      ),
    );
  }

  Widget _section(String title, int rowCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Bone(
            width: 155.w,
            height: 20.h,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(rowCount, (_) => _infoRow()),
          ),
        ),
      ],
    );
  }

  Widget _infoRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Bone.circle(size: 42.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 90.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                Bone(
                  width: 150.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}