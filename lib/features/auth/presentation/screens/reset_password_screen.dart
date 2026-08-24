import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medtech_project/components/app_buttons.dart';
import 'package:medtech_project/components/apptextfield.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/auth/presentation/bloc/reset_password_bloc/reset_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/reset_password_bloc/reset_password_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/reset_password_bloc/reset_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otpId;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otpId,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to Login
          Navigator.popUntil(context, (route) => route.isFirst);
        }

        if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },

      builder: (context, state) {
        final isLoading = state is ResetPasswordLoading;

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        Navigator.pop(context);
                      },
              icon: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),

                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450.w),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          child: Icon(
                            Icons.lock_reset,
                            color: AppColors.white,
                            size: 42.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Center(
                        child: Text(
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Center(
                        child: Text(
                          'Create a new password for your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Center(
                        child: Text(
                          widget.email,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      AppTextField(
                        controller: passwordController,
                        label: 'New Password',
                        hint: 'Enter new password',
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      AppTextField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Confirm new password',
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),

                      SizedBox(height: 28.h),

                      AppButton(
                        title: 'Reset Password',
                        isLoading: isLoading,

                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  final password =
                                      passwordController.text.trim();

                                  final confirmPassword =
                                      confirmPasswordController.text.trim();

                                  // Empty password
                                  if (password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your new password',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // Empty confirm password
                                  if (confirmPassword.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please confirm your password',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // Password mismatch
                                  if (password != confirmPassword) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Passwords do not match'),
                                      ),
                                    );
                                    return;
                                  }

                                  debugPrint('Email: ${widget.email}');
                                  debugPrint('OTP ID: ${widget.otpId}');
                                  debugPrint('Password: $password');
                                  debugPrint(
                                    'Confirm Password: $confirmPassword',
                                  );
                                  context.read<ResetBloc>().add(
                                    ResetPasswordSubmitted(
                                      otpId: widget.otpId,
                                      email: widget.email,
                                      password: password,
                                      confirmPassword: confirmPassword,
                                    ),
                                  );
                                },
                      ),

                      SizedBox(height: 20.h),

                      Center(
                        child: TextButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
