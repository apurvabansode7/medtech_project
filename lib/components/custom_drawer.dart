import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/cached_network_image.dart';
import 'package:medtech_project/constant/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.onHomeTap,
    required this.onMessagesTap,
    required this.onProfileTap,
    required this.onSettingsTap,

    required this.onInterestedTap,
    required this.onWalletTap,
    required this.onLogoutTap,
  });

  final String userName;
  final String profileImageUrl;
  final VoidCallback onHomeTap;

  final VoidCallback onMessagesTap;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;

  final VoidCallback onInterestedTap;
  final VoidCallback onWalletTap;
  final VoidCallback onLogoutTap;


 String _getInitial(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName.substring(0, 1).toUpperCase();
  }
  @override
 

  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: ClipOval(
                    child: CachedImage(
                      imageUrl: profileImageUrl,
                      width: 64.w,
                      height: 64.w,
                      fit: BoxFit.cover,
                      backgroundColor: AppColors.white,
                      initial: userName,
                      placeholder: Container(
                       color: AppColors.white,
                        alignment: Alignment.center,
                        child: Text(
                          _getInitial(userName),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      errorWidget: Container(
                       color: AppColors.white,
                        alignment: Alignment.center,
                        child: Text(
                          _getInitial(userName),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Text(
                  'Welcome',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  userName.isEmpty ? 'MedTech User' : userName,
                  style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),

          // Menu
          _DrawerItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: onHomeTap,
          ),
          _DrawerItem(
            icon: Icons.chat_bubble_outline,
            title: 'Profile',
            onTap: onProfileTap,
          ),

          _DrawerItem(
            icon: Icons.inventory_2_outlined,
            title: 'Products',
            onTap: onMessagesTap,
          ),
          _DrawerItem(
            icon: Icons.favorite_border,
            title: 'Interested',
            onTap: onInterestedTap,
          ),

          _DrawerItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Walllet',
            onTap: onWalletTap,
          ),
          _DrawerItem(icon: Icons.logout, title: 'log out', onTap: onLogoutTap),

          const Spacer(),

          const Divider(),

          _DrawerItem(icon: Icons.info_outline, title: 'version', onTap: () {}),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}
