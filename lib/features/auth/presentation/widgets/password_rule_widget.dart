import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

class PasswordRulesWidget extends StatelessWidget {
  final String password;

  const PasswordRulesWidget({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
  
    final hasMinLength = password.length >= 8;
    final hasCapital = RegExp(r'[A-Z]').hasMatch(password);
    final hasSmall = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
   return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Padding(
  padding: EdgeInsets.symmetric(horizontal: 10.w),
  child: RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 12.sp,
      ),
      children: [
        TextSpan(
          text: 'Password must have 8+ characters',
          style: TextStyle(
            color: hasMinLength
                ? AppColors.success
                : AppColors.error,
          ),
        ),
        TextSpan(
          text: ', ',
          style: TextStyle(color: AppColors.error),
        ),
        TextSpan(
          text: '1 uppercase',
          style: TextStyle(
            color: hasCapital
                ? AppColors.success
                : AppColors.error,
          ),
        ),
        TextSpan(
          text: ', ',
          style: TextStyle(color: AppColors.error),
        ),
        TextSpan(
          text: '1 lowercase',
          style: TextStyle(
            color: hasSmall
                ? AppColors.success
                : AppColors.error,
          ),
        ),
        TextSpan(
          text: ', ',
          style: TextStyle(color: AppColors.error),
        ),
        TextSpan(
          text: '1 number',
          style: TextStyle(
            color: hasNumber
                ? AppColors.success
                : AppColors.error,
          ),
        ),
        TextSpan(
          text: ' and ',
          style: TextStyle(color:  hasSpecial
                ? AppColors.success
                : AppColors.error,),
        ),
        TextSpan(
          text: '1 special character',
          style: TextStyle(
            color: hasSpecial
                ? AppColors.success
                : AppColors.error,
          ),
        ),
      ],
    ),
  ),
),
  ],
);
  }
}