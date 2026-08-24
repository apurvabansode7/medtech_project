import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

class CustomToggleChoice extends StatelessWidget {
  final String firstLabel;
  final String secondLabel;
  final bool isFirstSelected;
  final ValueChanged<bool> onChanged;

  const CustomToggleChoice({
    super.key,
    required this.firstLabel,
    required this.secondLabel,
    required this.isFirstSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChoiceChip(
          showCheckmark: false,
          label: Text(
            firstLabel,
            style: TextStyle(
              fontSize: 14.sp,
              color: isFirstSelected
                  ? AppColors.white
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isFirstSelected,
          onSelected: (selected) {
            if (!isFirstSelected) {
              onChanged(true);
            }
          },
          backgroundColor: AppColors.white,
          selectedColor: AppColors.primary,
          side: BorderSide(
            color: isFirstSelected
                ? AppColors.primary
                : AppColors.grey,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),

        SizedBox(width: 8.w),

        ChoiceChip(
          showCheckmark: false,
          label: Text(
            secondLabel,
            style: TextStyle(
              fontSize: 14.sp,
              color: !isFirstSelected
                  ? AppColors.white
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: !isFirstSelected,
          onSelected: (selected) {
            if (isFirstSelected) {
              onChanged(false);
            }
          },
          backgroundColor: AppColors.white,
          selectedColor: AppColors.primary,
          side: BorderSide(
            color: !isFirstSelected
                ? AppColors.primary
                : AppColors.grey,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ],
    );
  }
}