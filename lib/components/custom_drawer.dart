import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/cached_network_image.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/core/utils/device_info_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.onHomeTap,
    required this.onMessagesTap,
    required this.onProfileTap,
    required this.onSettingsTap,
    required this.onsubscribeTap,
    required this.onInterestedTap,
    required this.onWalletTap,
    required this.onRewardTap,
    required this.onClaimRewardTap,
    required this.onLogoutTap,
  });

  final String userName;
  final String profileImageUrl;
  final VoidCallback onHomeTap;

  final VoidCallback onMessagesTap;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onsubscribeTap;
  final VoidCallback onInterestedTap;
  final VoidCallback onWalletTap;
  final VoidCallback onRewardTap;
  final VoidCallback onClaimRewardTap;
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
            title: ' Showcase Products',
            onTap: onMessagesTap,
          ),
          _DrawerItem(
            icon: Icons.favorite_border,
            title: 'Interested Products',
            onTap: onInterestedTap,
          ),

          _DrawerItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Walllet',
            onTap: onWalletTap,
          ),
          _DrawerItem(icon: Icons.gif_box, title: 'Rewards Products', onTap: onRewardTap),
          _DrawerItem(
            icon: Icons.subscriptions_outlined,
            title: 'subscribe campaign',
            onTap: onsubscribeTap,
          ),
          _DrawerItem(icon: Icons.wallet_giftcard, title: 'Claim Reward', onTap: onClaimRewardTap),
          _DrawerItem(icon: Icons.logout, title: 'log out', onTap: onLogoutTap),

          const Spacer(),

          const Divider(),

          FutureBuilder<String>(
            future: DeviceInfoService.getAppVersion(),
            builder: (context, snapshot) {
              final version = snapshot.data ?? '1.0.0';
              return _DrawerItem(
                icon: Icons.info_outline,
                title: 'Version $version',
                onTap: () {},
              );
            },
          ),

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
