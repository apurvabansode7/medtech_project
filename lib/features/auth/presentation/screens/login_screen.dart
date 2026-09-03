// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:medtech_project/components/app_buttons.dart';
// import 'package:medtech_project/components/apptextfield.dart';
// import 'package:medtech_project/constant/app_colors.dart';
// import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_bloc.dart';
// import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_event.dart';
// import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_state.dart';
// import 'package:medtech_project/features/auth/presentation/bloc/set_password_bloc/set_password_bloc.dart';
// import 'package:medtech_project/features/auth/presentation/screens/forgot_password_screen.dart';
// import 'package:medtech_project/features/auth/presentation/screens/set_password_screen.dart';
// import 'package:medtech_project/features/auth/presentation/widgets/password_rule_widget.dart';
// import 'package:medtech_project/features/home/screens/main_home_screen.dart';
// import 'package:medtech_project/utils/app_snack_bar.dart';
// import 'package:medtech_project/utils/validators.dart';

// @RoutePage()
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool isPasswordVisible = false;
//   String password = '';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is LoginFailure) {
//           AppSnackbar.error(state.message);
//           return;
//         }

//         if (state is LoginSucess) {
//           if (state.mustChangePassword) {
//             final token = state.passwordSetupToken;

//             debugPrint('Password Setup Token: $token');

//             if (token == null || token.isEmpty) {
//               AppSnackbar.error('Password setup token not received');
//               return;
//             }

//             final authRepository = context.read<AuthBloc>().authRepository;

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (_) => BlocProvider(
//                       create:
//                           (_) =>
//                               SetPasswordBloc(authRepository: authRepository),
//                       child: SetPasswordScreen(passwordSetupToken: token),
//                     ),
//               ),
//             );

//             return;
//           }

//           AppSnackbar.success(state.message);

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const MainHomeScreen()),
//           );
//         }
//       },
//       builder: (context, state) {
//         final isLoading = state is AuthLoading;

//         return Scaffold(
//           backgroundColor: AppColors.background,
//           body: SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: 450.w),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Logo
//                         Center(
//                           child: Container(
//                             width: 80.w,
//                             height: 80.w,
//                             decoration: BoxDecoration(
//                               color: AppColors.primary,
//                               borderRadius: BorderRadius.circular(22.r),
//                             ),
//                             child: Icon(
//                               Icons.medical_services,
//                               color: AppColors.white,
//                               size: 42.sp,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 24.h),

//                         // Title
//                         Center(
//                           child: Text(
//                             'Welcome Back 👋',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 26.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8.h),

//                         // Subtitle
//                         Center(
//                           child: Text(
//                             'Login to your account',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 32.h),

//                         // Email Field
//                         AppTextField(
//                           controller: _emailController,
//                           label: 'Email',
//                           hint: 'Enter your email',
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             return Validators.email(value);
//                           },
//                           onChanged: (value) {
//                             setState(() {});
//                           },
//                         ),
//                         SizedBox(height: 20.h),

//                         // Password Field
//                         AppTextField(
//                           controller: passwordController,
//                           label: 'Password',
//                           hint: 'Enter your password',
//                           obscureText: !isPasswordVisible,
//                           validator: Validators.password,
//                           onChanged: (value) {
//                             setState(() {
//                               password = value;
//                             });
//                           },
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 isPasswordVisible = !isPasswordVisible;
//                               });
//                             },
//                             icon: Icon(
//                               isPasswordVisible
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10.h),

//                         PasswordRulesWidget(password: password),

//                         // Forgot Password
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => const ForgotPasswordScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               'Forgot Password?',
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 12.h),

//                         // Login Button
//                         AppButton(
//                           isLoading: isLoading,
//                           title: 'Login',
//                           onPressed:
//                               isLoading
//                                   ? null
//                                   : () {
//                                     if (_formKey.currentState!.validate()) {
//                                       context.read<AuthBloc>().add(
//                                         LoginSubmited(
//                                           email: _emailController.text.trim(),
//                                           password: passwordController.text,
//                                         ),
//                                       );
//                                     }
//                                   },
//                         ),
//                         SizedBox(height: 24.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/app_buttons.dart';
import 'package:medtech_project/components/apptextfield.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_state.dart';
import 'package:medtech_project/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:medtech_project/features/home/presentation/screens/main_home_screen.dart';
import 'package:medtech_project/utils/app_snack_bar.dart';
import 'package:medtech_project/utils/validators.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          AppSnackbar.error(state.message);
          return;
        }

        // OTP successfully sent
        if (state is LoginOtpSent) {
          AppSnackbar.success(state.message);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<AuthBloc>(),
                    child: VerifyOtpScreen(
                      email: _emailController.text.trim(),
                    
                    ),
                  ),
            ),
          );

          return;
        }

        // Keep this if old LoginSuccess is used somewhere else
        if (state is LoginSucess) {
          AppSnackbar.success(state.message);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainHomeScreen()),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Center(
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(22.r),
                            ),
                            child: Icon(
                              Icons.medical_services,
                              color: AppColors.white,
                              size: 42.sp,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Title
                        Center(
                          child: Text(
                            'Welcome Back 👋',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Subtitle
                        Center(
                          child: Text(
                            'Login to your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Email Field
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),

                        SizedBox(height: 24.h),

                        // Send OTP Button
                        AppButton(
                          isLoading: isLoading,
                          title: 'Send OTP',
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState!.validate()) {
                                  

                                      if (!context.mounted) return;

                                      context.read<AuthBloc>().add(
                                        LoginOtpRequested(
                                          email: _emailController.text.trim(),
                                         
                                        ),
                                      );
                                    }
                                  },
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
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
