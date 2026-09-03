import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
     backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: AppColors.transparent,

      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 24.sp,
             color: AppColors.white,
            ),
          );
        },
      ),

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}