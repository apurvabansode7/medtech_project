import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/app_buttons.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/utils/app_snack_bar.dart';
import 'package:medtech_project/utils/device_info_service.dart';
import 'package:medtech_project/features/auth/presentation/bloc/verify_otp_bloc/verify_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/verify_otp_bloc/verify_otp_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/verify_otp_bloc/verify_otp_state.dart';
import 'package:medtech_project/features/home/presentation/screens/main_home_screen.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  Timer? _otpTimer;
  int _remainingSeconds = 600;

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
  }

  Future<void> _submitOtp(String otp) async {
    final info = await DeviceInfoService.getDeviceAndAppInfo();
    final deviceId = info['deviceId']!;
    final appVersion = info['appVersion']!;
    final platform = info['platform']!;

    if (!mounted) return;

    context.read<VerifyOtpBloc>().add(
      VerifyOtpSubmitted(
        email: widget.email,
        otp: otp,
        deviceId: deviceId,
        appVersion: appVersion,
        platform: platform,
      ),
    );
  }

  Future<void> _resendOtp() async {
    final info = await DeviceInfoService.getDeviceAndAppInfo();
    final deviceId = info['deviceId']!;
    final appVersion = info['appVersion']!;

    if (!mounted) return;

    context.read<VerifyOtpBloc>().add(
      ResendOtpRequested(
        email: widget.email,
        deviceId: deviceId,
        appVersion: appVersion,
      ),
    );
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();

    setState(() {
      _remainingSeconds = 600;
    });

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();

        if (mounted) {
          setState(() {
            _remainingSeconds = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      }
    });
  }

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        // if (state is VerifyOtpSuccess) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('OTP verified successfully'),
        //       backgroundColor: Colors.green,
        //     ),
        //   );

        //   // Pass email + otpId to reset password screen
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder:
        //           (_) => ResetPasswordScreen(
        //             email: widget.email,
        //             otpId: state.otpId,
        //           ),
        //     ),
        //   );
        // }
        if (state is VerifyOtpSuccess) {
          AppSnackbar.success('Login successful');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainHomeScreen()),
            (route) => false,
          );
        }
        if (state is VerifyOtpFailure) {
          AppSnackbar.error(state.message);
        }

        // RESEND SUCCESS
        if (state is ResendOtpSuccess) {
          otpController.clear();
          _startOtpTimer();

          AppSnackbar.success("OTP sent successfully");
        }

        // RESEND FAILURE
        if (state is ResendOtpFailure) {
          AppSnackbar.error(state.message);
        }
      },

      builder: (context, state) {
        final isLoading = state is VerifyOtpLoading;
        final isResendLoading = state is ResendOtpLoading;

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
                            Icons.mark_email_read_outlined,
                            color: AppColors.white,
                            size: 42.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Center(
                        child: Text(
                          'Verify OTP',
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
                          'Enter the OTP sent to your registered email address.',
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

                      Pinput(
                        controller: otpController,
                        length: 6,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,

                        onCompleted: (otp) {
                          if (isLoading ||
                              isResendLoading ||
                              _remainingSeconds == 0) {
                            return;
                          }

                          _submitOtp(otp);
                        },

                        defaultPinTheme: PinTheme(
                          width: 48.w,
                          height: 52.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),

                        focusedPinTheme: PinTheme(
                          width: 48.w,
                          height: 52.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),

                        submittedPinTheme: PinTheme(
                          width: 48.w,
                          height: 52.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColors.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_remainingSeconds > 0)
                            Text(
                              'OTP expires in ${_formatTime()}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),

                          if (_remainingSeconds == 0)
                            TextButton(
                              onPressed:
                                  isLoading || isResendLoading
                                      ? null
                                      : () {
                                        _resendOtp();
                                      },
                              child:
                                  isResendLoading
                                      ? SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                            ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      AppButton(
                        title: 'Verify OTP',
                        isLoading: isLoading,
                        onPressed: () {
                          final otp = otpController.text.trim();

                          if (otp.isEmpty) {
                            AppSnackbar.error("Please enter OTP");
                            return;
                          }

                          if (otp.length != 6) {
                            AppSnackbar.error(
                              "Please enter a valid 6-digit OTP",
                            );
                            return;
                          }

                          _submitOtp(otp);
                        },
                      ),

                      SizedBox(height: 20.h),
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
