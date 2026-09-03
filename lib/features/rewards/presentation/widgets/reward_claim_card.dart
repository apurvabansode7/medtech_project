import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/rewards/data/models/reward_claim_response.dart';

class RewardClaimCard extends StatelessWidget {
  final RewardClaimItem claim;

  const RewardClaimCard({super.key, required this.claim});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = claim.rewardSnapshot?.name.isNotEmpty == true
        ? claim.rewardSnapshot!.name
        : 'Reward Claim';
    final brand = claim.rewardSnapshot?.brand ?? '';
    final images = claim.rewardSnapshot?.images ?? [];
  final claimStatus = claim.status.trim().toLowerCase();
final isRejected = claimStatus == 'rejected';
final isCancelled = claimStatus == 'cancelled';

final statusColor = _getStatusColor(claimStatus);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52.w,
                width: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.card_giftcard,
                            color: AppColors.primary,
                            size: 26.sp,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.card_giftcard,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    if (brand.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        'Brand: $brand',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    SizedBox(height: 6.h),
Row(
  children: [
    Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        claim.status.isNotEmpty
            ? claim.status.toUpperCase()
            : 'UNKNOWN',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    ),

    // Don't show delivery status for rejected/cancelled claims.
    if (!isRejected && !isCancelled) ...[
      SizedBox(width: 8.w),

      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          'Delivery: ${claim.deliveryStatus.isNotEmpty ? claim.deliveryStatus.toUpperCase() : 'PENDING'}',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    ],
  ],
),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: 16.sp,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${claim.pointsRequired} Points',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              if (claim.createdAt != null && claim.createdAt!.isNotEmpty)
                Text(
                  claim.createdAt!.length >= 10
                      ? claim.createdAt!.substring(0, 10)
                      : claim.createdAt!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),

          if (claim.reviewNote != null && claim.reviewNote!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'Admin Note: ${claim.reviewNote}',
              style: TextStyle(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

