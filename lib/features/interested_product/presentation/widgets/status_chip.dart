import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({ super.key ,required this.status});

  @override
  Widget build(BuildContext context) {
    String label = status
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');

    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'followed_up':
        backgroundColor = Colors.orange.withValues(alpha: 0.10);
        textColor = Colors.orange.shade800;
        break;

      case 'closed':
        backgroundColor = Colors.green.withValues(alpha: 0.10);
        textColor = Colors.green.shade700;
        break;

      case 'pending':
        backgroundColor = Colors.blue.withValues(alpha: 0.10);
        textColor = Colors.blue.shade700;
        break;

      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.10);
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
