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
import 'package:medtech_project/features/auth/presentation/widgets/password_rule_widget.dart';
import 'package:medtech_project/utils/app_snack_bar.dart';

class SetPasswordScreen extends StatefulWidget {
  final String passwordSetupToken;

  const SetPasswordScreen({super.key, required this.passwordSetupToken});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String password = '';

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

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

    context.read<SetPasswordBloc>().add(
      SetPasswordSubmitted(
        password: password,
        confirmPassword: confirmPassword,
        passwordSetupToken: widget.passwordSetupToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetPasswordBloc, SetPasswordState>(
      listener: (context, state) {
        if (state is SetPasswordSuccess) {
          AppSnackbar.success(state.message);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }

        if (state is SetPasswordFailure) {
          AppSnackbar.error(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is SetPasswordLoading;

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.white,
                            size: 42.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Title
                      Center(
                        child: Text(
                          'Set Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Subtitle
                      Center(
                        child: Text(
                          'Create a password for your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // New Password
                      AppTextField(
                        controller: passwordController,
                        label: 'New Password',
                        hint: 'Enter new password',
                        obscureText: obscurePassword,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        suffixIcon: IconButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
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
                      SizedBox(height: 10.h),

                      PasswordRulesWidget(password: password),

                      SizedBox(height: 20.h),

                      // Confirm Password
                      AppTextField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Confirm new password',
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
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

                      SizedBox(height: 30.h),

                      AppButton(
                        title: 'Set Password',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submit,
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
