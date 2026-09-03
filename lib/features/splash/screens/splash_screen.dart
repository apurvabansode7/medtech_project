import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/constant/app_images.dart';
import 'package:medtech_project/features/auth/presentation/screens/login_screen.dart';
import 'package:medtech_project/features/home/presentation/screens/main_home_screen.dart';
import 'package:medtech_project/utils/app_prefrences.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Show splash for 2 seconds
    await Future.delayed(
      const Duration(seconds: 2),
    );

    // Check SharedPreferences
    final isLoggedIn = await AppPreferences.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // User already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainHomeScreen(),
        ),
      );
    } else {
      // User is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(
          AppImages.medtechLogo,
             width: 180.w,
    height: 180.h,
           fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.medical_services,
            color: AppColors.primary,
            size: 60.sp,
          ),
        ),
      ),
    );
  }
}