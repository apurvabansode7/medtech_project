import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/scan_history/data/models/scan_history_model.dart';

class ScanHistoryCard extends StatelessWidget {
  final ScanHistoryModel scan;

  const ScanHistoryCard({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = scan.scanStatus.toUpperCase() == 'SUCCESS';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color:
                      isSuccess
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.productCode,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      scan.businessDetails.outletName,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              /// STATUS
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color:
                      isSuccess
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isSuccess ? 'Success' : 'Failed',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Divider(height: 1, color: Colors.grey.shade200),

          SizedBox(height: 12.h),

      

          /// PARTNER
          _infoRow(
            icon: Icons.person_outline,
            title: 'Partner',
            value: scan.businessDetails.partnerName,
          ),

          SizedBox(height: 8.h),

          /// DATE
          _infoRow(
            icon: Icons.access_time,
            title: 'Scanned At',
            value: _formatDate(scan.scannedAt),
          ),

          SizedBox(height: 12.h),

          /// RESULT
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color:
                  isSuccess
                      ? Colors.green.withValues(alpha: 0.06)
                      : Colors.red.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    scan.scanResult,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          isSuccess
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                  ),
                ),

                if (scan.rewardPointsEarned > 0)
                  Text(
                    '+${scan.rewardPointsEarned} Points',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17.sp, color: Colors.grey.shade600),
        SizedBox(width: 8.w),
        Text(
          '$title: ',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date).toLocal();

    return '${parsedDate.day.toString().padLeft(2, '0')}/'
        '${parsedDate.month.toString().padLeft(2, '0')}/'
        '${parsedDate.year} '
        '${parsedDate.hour.toString().padLeft(2, '0')}:'
        '${parsedDate.minute.toString().padLeft(2, '0')}';
  }
}
