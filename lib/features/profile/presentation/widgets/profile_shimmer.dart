import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:medtech_project/constant/app_colors.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _box(
                width: 72.w,
                height: 24.h,
                radius: 4.r,
              ),
            ),

            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _profileHeaderShimmer(),
            ),

            SizedBox(height: 22.h),

   
            _sectionTitle(width: 170.w),

            SizedBox(height: 10.h),

            _infoCard(
              rows: const [
                _RowSize(
                  icon: Icons.person_outline,
                  titleWidth: 82,
                  valueWidth: 145,
                ),
                _RowSize(
                  icon: Icons.business_outlined,
                  titleWidth: 90,
                  valueWidth: 155,
                ),
                _RowSize(
                  icon: Icons.email_outlined,
                  titleWidth: 45,
                  valueWidth: 175,
                ),
                _RowSize(
                  icon: Icons.phone_outlined,
                  titleWidth: 50,
                  valueWidth: 120,
                ),
                _RowSize(
                  icon: Icons.badge_outlined,
                  titleWidth: 85,
                  valueWidth: 150,
                ),
                _RowSize(
                  icon: Icons.receipt_long_outlined,
                  titleWidth: 75,
                  valueWidth: 130,
                ),
              ],
            ),

            SizedBox(height: 22.h),

        

            _sectionTitle(width: 175.w),

            SizedBox(height: 10.h),

            _infoCard(
              rows: const [
                _RowSize(
                  icon: Icons.verified_outlined,
                  titleWidth: 105,
                  valueWidth: 95,
                ),
                _RowSize(
                  icon: Icons.account_circle_outlined,
                  titleWidth: 95,
                  valueWidth: 110,
                ),
                _RowSize(
                  icon: Icons.location_on_outlined,
                  titleWidth: 50,
                  valueWidth: 120,
                ),
                _RowSize(
                  icon: Icons.email_outlined,
                  titleWidth: 100,
                  valueWidth: 75,
                ),
                _RowSize(
                  icon: Icons.phone_android_outlined,
                  titleWidth: 100,
                  valueWidth: 95,
                ),
              ],
            ),
            SizedBox(height: 22.h),
            _sectionTitle(width: 65.w),
            SizedBox(height: 10.h),
            _infoCard(
              rows: const [
                _RowSize(
                  icon: Icons.account_balance_wallet_outlined,
                  titleWidth: 115,
                  valueWidth: 105,
                ),
                _RowSize(
                  icon: Icons.stars_outlined,
                  titleWidth: 125,
                  valueWidth: 120,
                ),
              ],
            ),

            SizedBox(height: 22.h),
           _sectionTitle(width: 185.w),

            SizedBox(height: 10.h),

            _infoCard(
              rows: const [
                _RowSize(
                  icon: Icons.person_outline,
                  titleWidth: 40,
                  valueWidth: 120,
                ),
                _RowSize(
                  icon: Icons.badge_outlined,
                  titleWidth: 100,
                  valueWidth: 110,
                ),
                _RowSize(
                  icon: Icons.email_outlined,
                  titleWidth: 45,
                  valueWidth: 165,
                ),
                _RowSize(
                  icon: Icons.phone_outlined,
                  titleWidth: 50,
                  valueWidth: 125,
                ),
              ],
            ),

            SizedBox(height: 22.h),

        
            _sectionTitle(width: 140.w),

            SizedBox(height: 10.h),

            _infoCard(
              rows: const [
                _RowSize(
                  icon: Icons.store_outlined,
                  titleWidth: 45,
                  valueWidth: 145,
                ),
                _RowSize(
                  icon: Icons.person_outline,
                  titleWidth: 65,
                  valueWidth: 125,
                ),
                _RowSize(
                  icon: Icons.badge_outlined,
                  titleWidth: 75,
                  valueWidth: 115,
                ),
                _RowSize(
                  icon: Icons.medical_information_outlined,
                  titleWidth: 80,
                  valueWidth: 140,
                ),
                _RowSize(
                  icon: Icons.location_on_outlined,
                  titleWidth: 55,
                  valueWidth: 190,
                ),
                _RowSize(
                  icon: Icons.verified_outlined,
                  titleWidth: 65,
                  valueWidth: 100,
                ),
              ],
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }


  Widget _profileHeaderShimmer() {
    return Container(
      width: double.infinity,
      height: 94.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 58.w,
            height: 58.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              Icons.person,
              size: 32.sp,
              color: Colors.grey,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(
                  width: 145.w,
                  height: 17.h,
                  radius: 3.r,
                ),

                SizedBox(height: 7.h),

                _box(
                  width: 115.w,
                  height: 12.h,
                  radius: 3.r,
                ),

                SizedBox(height: 7.h),

                _box(
                  width: 90.w,
                  height: 10.h,
                  radius: 3.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _sectionTitle({
    required double width,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: _box(
        width: width,
        height: 20.h,
        radius: 4.r,
      ),
    );
  }



  Widget _infoCard({
    required List<_RowSize> rows,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: rows.map(_infoRow).toList(),
      ),
    );
  }



  Widget _infoRow(_RowSize row) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 11.h,
      ),
      child: Row(
        children: [
       

          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(
                alpha: 0.08,
              ),
            ),
            child: Icon(
              row.icon,
              color: AppColors.primary,
              size: 21.sp,
            ),
          ),

          SizedBox(width: 12.w),

       

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                _box(
                  width: row.titleWidth.w,
                  height: 11.h,
                  radius: 3.r,
                ),

                SizedBox(height: 5.h),

                // Value
                _box(
                  width: row.valueWidth.w,
                  height: 14.h,
                  radius: 3.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _box({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}


class _RowSize {
  final IconData icon;
  final double titleWidth;
  final double valueWidth;

  const _RowSize({
    required this.icon,
    required this.titleWidth,
    required this.valueWidth,
  });
}