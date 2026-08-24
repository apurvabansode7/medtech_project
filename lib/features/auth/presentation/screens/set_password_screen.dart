import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medtech_project/components/app_buttons.dart';
import 'package:medtech_project/components/apptextfield.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/auth/presentation/bloc/set_password_bloc/set_password_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/set_password_bloc/set_password_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/set_password_bloc/set_password_state.dart';
import 'package:medtech_project/features/auth/presentation/screens/login_screen.dart';
import 'package:medtech_project/utils/app_snack_bar.dart';

class SetPasswordScreen extends StatefulWidget {
  final String otpId;

  const SetPasswordScreen({
    super.key,
    required this.otpId,
  });

  @override
  State<SetPasswordScreen> createState() =>
      _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController passwordController =
      TextEditingController();

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

  void _submit() {
    final password = passwordController.text.trim();
    final confirmPassword =
        confirmPasswordController.text.trim();

    if (password.isEmpty) {
      AppSnackbar.error('Please enter your new password');
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackbar.error('Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.error('Passwords do not match');
      return;
    }

    debugPrint('========== SET PASSWORD ==========');
    debugPrint('OTP ID: ${widget.otpId}');
    debugPrint('Password: $password');
    debugPrint('Confirm Password: $confirmPassword');
    debugPrint('==================================');

    context.read<SetPasswordBloc>().add(
          SetPasswordSubmitted(
            otpId: widget.otpId,
            password: password,
            confirmPassword: confirmPassword,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetPasswordBloc, SetPasswordState>(
      listener: (context, state) {
        if (state is SetPasswordSuccess) {
          AppSnackbar.success(state.message);

          // Password successfully created.
          // Now user can login with email + new password.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
            (route) => false,
          );
        }

        if (state is SetPasswordFailure) {
          AppSnackbar.error(state.message);
        }
      },
      builder: (context, state) {
        final isLoading =
            state is SetPasswordLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: isLoading
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
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 24.h,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 450.w,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(22.r),
                          ),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.white,
                            size: 42.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Center(
                        child: Text(
                          'Set Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Center(
                        child: Text(
                          'Create a password for your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                AppColors.textSecondary,
                            height: 1.5,
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
                              obscurePassword =
                                  !obscurePassword;
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
                        controller:
                            confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Confirm new password',
                        obscureText:
                            obscureConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
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
                        title: 'Set Password',
                        isLoading: isLoading,
                        onPressed:
                            isLoading ? null : _submit,
                      ),

                      SizedBox(height: 20.h),

                      Center(
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  AppColors.primary,
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