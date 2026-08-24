import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/interested_product/data/models/interested_product_response.dart';
import 'package:medtech_project/features/interested_product/presentation/widgets/status_chip.dart';

class InterestedProductCard extends StatelessWidget {
  final InterestedProduct product;

  const InterestedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  color: AppColors.primary,
                  size: 27.sp,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productSnapshot.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      'Product ID: ${product.showcaseProductId.substring(0, 8)}...',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              StatusChip(status: product.status),
            ],
          ),

          SizedBox(height: 14.h),

          Divider(height: 1, color: Colors.grey.shade200),

          SizedBox(height: 14.h),

          // Quantity
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 18.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${product.quantityRequested}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Note
          if (product.note.isNotEmpty) ...[
            Text(
              'Note',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 5.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                product.note,
                style: TextStyle(
                  fontSize: 11.sp,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            SizedBox(height: 12.h),
          ],

          // Partner
          Row(
            children: [
              // CircleAvatar(
              //   radius: 18.r,
              //   backgroundColor: AppColors.primary
              //       .withValues(alpha: 0.08),
              //   child: Icon(
              //     Icons.person_outline,
              //     size: 19.sp,
              //     color: AppColors.primary,
              //   ),
              // ),
              SizedBox(width: 9.w),

              // Expanded(
              //   child: Column(
              //     crossAxisAlignment:
              //         CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         product
              //             .partnerSnapshot.name,
              //         style: TextStyle(
              //           fontSize: 12.sp,
              //           fontWeight:
              //               FontWeight.w600,
              //           color:
              //               AppColors.textPrimary,
              //         ),
              //       ),
              //       SizedBox(height: 2.h),
              //       Text(
              //         product
              //             .partnerSnapshot.businessName,
              //         style: TextStyle(
              //           fontSize: 10.sp,
              //           color:
              //               AppColors.textSecondary,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if (product.createdAt != null)
                Text(
                  _formatDate(product.createdAt!),
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
