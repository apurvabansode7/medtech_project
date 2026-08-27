import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medtech_project/constant/app_colors.dart';

class AddressTypeField extends StatelessWidget {
  final TextEditingController controller;

  const AddressTypeField({
    super.key,
    required this.controller,
  });

  static const List<String> options = [
    'SHOP',
    'GODOWN',
  ];

  @override
  Widget build(BuildContext context) {
    final String currentValue =
        options.contains(controller.text)
            ? controller.text
            : 'SHOP';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Type',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 6.h),

        DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),

            prefixIcon: Icon(
              Icons.location_city_outlined,
              size: 19.sp,
              color: AppColors.primary,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
          ),

          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),

          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value != null) {
              controller.text = value;
            }
          },
        ),
      ],
    );
  }
}