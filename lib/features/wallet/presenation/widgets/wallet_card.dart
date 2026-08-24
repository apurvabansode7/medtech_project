import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/wallet/data/models/wallet_transaction_model.dart';

class WalletTransactionCard extends StatelessWidget {
  final WalletTransactionModel transaction;

  const WalletTransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCredit =
        transaction.type.toLowerCase() == 'credit';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: isCredit
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isCredit
                      ? Colors.green
                      : Colors.red,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCredit ? 'Points Credited' : 'Points Debited',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      transaction.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              Text(
                '${isCredit ? '+' : '-'}${transaction.points}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isCredit
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 16.sp,
                color: Colors.grey.shade600,
              ),

              SizedBox(width: 6.w),

              Text(
                'Balance',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(width: 5.w),

              Text(
                '${transaction.balanceAfter} points',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const Spacer(),

              Icon(
                Icons.access_time,
                size: 15.sp,
                color: Colors.grey.shade600,
              ),

              SizedBox(width: 5.w),

              Text(
                _formatDate(transaction.createdAt),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsedDate =
          DateTime.parse(date).toLocal();

      return '${parsedDate.day.toString().padLeft(2, '0')}/'
          '${parsedDate.month.toString().padLeft(2, '0')}/'
          '${parsedDate.year} '
          '${parsedDate.hour.toString().padLeft(2, '0')}:'
          '${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }
}