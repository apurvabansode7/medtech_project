import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/cached_network_image.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/rewards/data/models/available_rewards_response.dart';

export 'reward_claim_card.dart';

class RewardCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? category;
  final double? price;
  final int availablePoints;
  final int availableQuantity;
  final int requiredPoints;
  final bool isClaimable;
  
  final VoidCallback? onRedeem;

  const RewardCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.category,
    this.price,
    required this.availablePoints,
     required this.availableQuantity,
    required this.requiredPoints,
    this.isClaimable = true,
    this.onRedeem,
  });

  factory RewardCard.fromAvailableReward({
    required AvailableRewardItem item,
    required int walletBalance,
    VoidCallback? onRedeem,
  }) {
    return RewardCard(
      name: item.name,
      imageUrl: item.primaryImageUrl,
      category: item.category?.name.isNotEmpty == true
          ? item.category!.name
          : item.brand,
      availablePoints: walletBalance,
      requiredPoints: item.pointsRequired,
      availableQuantity: item.availableQuantity,
      isClaimable: item.isClaimable,
      onRedeem: onRedeem,
    );
  }

  String formatPoints(int points) {
  if (points >= 1000000) {
    final value = points / 1000000;
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}M';
  }

  if (points >= 1000) {
    final value = points / 1000;
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}K';
  }

  return points.toString();
}

  @override
  Widget build(BuildContext context) {
    final bool canRedeem = isClaimable && availablePoints >= requiredPoints;

    

    return Container(
      width: double.infinity,
      height: 290.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: double.infinity,
              height: 115.h,
              color: Colors.grey.shade50,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedImage(
                      imageUrl: imageUrl!,
                      width: double.infinity,
                      height: 115.h,
                      fit: BoxFit.contain,
                      backgroundColor: Colors.white,
                      initial: name,
                    )
                  : Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'R',
                        style: TextStyle(
                          fontSize: 38.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
          ),

          SizedBox(height: 8.h),

          // CATEGORY
          if (category != null && category!.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                category!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),

          SizedBox(height: 5.h),

          // REWARD NAME
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 6.h),

          // PRICE & REQUIRED POINTS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (price != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '₹${price!.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

             
            ],
          ),

          SizedBox(height: 5.h),

          // AVAILABLE POINTS
          // Row(
          //   children: [
          //     Icon(
          //       Icons.stars_rounded,
          //       size: 15.sp,
          //       color: AppColors.primary,
          //     ),
          //     SizedBox(width: 4.w),
          //     Text(
          //       'Available: ',
          //       style: TextStyle(
          //         fontSize: 10.sp,
          //         color: AppColors.textSecondary,
          //       ),
          //     ),
          //     Text(
          //       '$availablePoints P',
          //       style: TextStyle(
          //         fontSize: 11.sp,
          //         fontWeight: FontWeight.w700,
          //         color: AppColors.primary,
          //       ),
          //     ),
          //   ],
          // ),
     
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: 15.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Required: ',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$requiredPoints P',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
             
            ],
          ),
          SizedBox(height: 5.h),
           Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    '$availableQuantity left',
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

          const Spacer(),

          // REDEEM BUTTON
          SizedBox(
            width: double.infinity,
            height: 32.h,
            child: ElevatedButton(
              onPressed: canRedeem ? onRedeem : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.r),
                ),
              ),
              child: Text(
                canRedeem ? 'Claim' : 'Not Enough Points',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: canRedeem
                      ? AppColors.white
                      : Colors.grey.shade600,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}