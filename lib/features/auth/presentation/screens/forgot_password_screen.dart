import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/app_buttons.dart';
import 'package:medtech_project/components/apptextfield.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/auth/presentation/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/forgot_password_bloc/forgot_password_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/forgot_password_bloc/forgot_password_state.dart';
import 'package:medtech_project/features/auth/presentation/screens/verify_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => VerifyOtpScreen(email: emailController.text.trim()),
            ),
          );
        }

        if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },

      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        final email = emailController.text.trim();
        final canSubmit = email.isNotEmpty && !isLoading && !_isSubmitting;

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
                          'Forgot Password?',
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
                          'Enter your registered email address and we will send you an OTP to reset your password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      AppTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      SizedBox(height: 30.h),

                      AppButton(
                        title: 'Send OTP',
                        isLoading: isLoading,
                        // onPressed:
                        //     isLoading
                        //         ? null
                        //         : () {
                        //           final email = emailController.text.trim();

                        //           if (email.isEmpty) {
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               const SnackBar(
                        //                 content: Text(
                        //                   'Please enter your email address',
                        //                 ),
                        //               ),
                        //             );
                        //             return;
                        //           }

                        //           context.read<ForgotPasswordBloc>().add(
                        //             ForgotPasswordSubmitted(email: email),
                        //           );
                        //         },
                        onPressed:
                            canSubmit
                                ? () {
                                  // Immediately block another tap.
                                  setState(() {
                                    _isSubmitting = true;
                                  });

                                  final email = emailController.text.trim();

                                  context.read<ForgotPasswordBloc>().add(
                                    ForgotPasswordSubmitted(email: email),
                                  );
                                }
                                : null,
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
