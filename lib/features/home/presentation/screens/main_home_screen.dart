import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medtech_project/components/comfirmation_dialog.dart';
import 'package:medtech_project/components/custom_app_bar.dart';
import 'package:medtech_project/components/custom_drawer.dart';
import 'package:medtech_project/components/exit_app_dialog.dart';
import 'package:medtech_project/constant/app_colors.dart';

import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_state.dart';
import 'package:medtech_project/features/auth/presentation/screens/login_screen.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';

import 'package:medtech_project/features/home/presentation/screens/home_screen.dart';

import 'package:medtech_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_event.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_state.dart';
import 'package:medtech_project/features/profile/presentation/screens/profile_screen.dart';

import 'package:medtech_project/features/interested_product/presentation/screens/interested_product_screen.dart';
import 'package:medtech_project/features/product/presentation/screens/product_screen.dart';
import 'package:medtech_project/features/rewards/domain/repositories/reward_repository.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_bloc.dart';

import 'package:medtech_project/features/rewards/presentation/screens/claim_reward_screen.dart';
import 'package:medtech_project/features/rewards/presentation/screens/reward_screen.dart';
import 'package:medtech_project/features/scanner/domain/repositories/product_scan_repository.dart';
import 'package:medtech_project/features/scanner/presentation/bloc/product_scan_bloc.dart';

import 'package:medtech_project/features/scanner/presentation/screens/product_scanner_screen.dart';

import 'package:medtech_project/features/setting/screens/setting_screen.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_subscribed_bloc.dart';

import 'package:medtech_project/features/subscribe/presentation/screens/subscribe_screen.dart';

import 'package:medtech_project/features/wallet/presenation/screens/wallet_screen.dart';

@RoutePage()
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create:
          (context) =>
              ProfileBloc(repository: context.read<ProfileRepository>())
                ..add(const LoadProfile()),
      child: const MainHomeView(),
    );
  }
}

class MainHomeView extends StatefulWidget {
  const MainHomeView({super.key});

  @override
  State<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends State<MainHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectDrawerTab(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pop(context);
  }

  Future<void> _openScanner() async {
    final String? scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider<ProductScanBloc>(
              create:
                  (_) => ProductScanBloc(
                    repository: context.read<ProductScanRepository>(),
                  ),
              child: const ProductScannerScreen(),
            ),
      ),
    );

    if (!mounted) return;

    if (scannedCode != null && scannedCode.isNotEmpty) {
      debugPrint('Scanned Product Code: $scannedCode');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Scanned: $scannedCode')));
    }
  }

  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ExitAppDialog(
          onExit: () {
            Navigator.pop(dialogContext, true);
          },
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is LogoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Stack(
          children: [
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) return;

                // 1. Close drawer if open
                if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                  _scaffoldKey.currentState?.closeDrawer();
                  return;
                }

                // 2. Switch back to Home tab (index 0) if on tab 1 or 2
                if (_selectedIndex != 0) {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  return;
                }

                // 3. Show ExitAppDialog if on Home tab (index 0)
                final shouldClose = await _showExitDialog();

                if (shouldClose && mounted) {
                  SystemNavigator.pop();
                }
              },
              child: Scaffold(
                key: _scaffoldKey,
          
                appBar: CustomAppBar(title: ''),

                drawer: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (drawerContext, profileState) {
                    String userName = 'MedTech User';
                    String profileImageUrl = '';

                    if (profileState is ProfileLoaded) {
                      userName = profileState.profile.ownerName;
                      profileImageUrl = profileState.profile.profileImage ?? '';
                    }

                    return CustomDrawer(
                      userName: userName,
                      profileImageUrl: profileImageUrl,

                      onHomeTap: () {
                        _selectDrawerTab(0);
                      },

                      onMessagesTap: () {
                        _selectDrawerTab(1);
                      },

                      onProfileTap: () {
                        _selectDrawerTab(2);
                      },

                      onSettingsTap: () {
                        Navigator.pop(drawerContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingScreen(),
                          ),
                        );
                      },

                      onInterestedTap: () {
                        Navigator.pop(drawerContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => InterestedScreen()),
                        );
                      },

                      onsubscribeTap: () {
                        Navigator.pop(drawerContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider<CampaignSubscribedBloc>(
                                  create:
                                      (context) => CampaignSubscribedBloc(
                                        repository:
                                            context.read<CampaignRepository>(),
                                      ),
                                  child: const SubscriptionScreen(),
                                ),
                          ),
                        );
                      },

                      onWalletTap: () {
                        Navigator.pop(drawerContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WalletScreen(),
                          ),
                        );
                      },

                      onRewardTap: () {
                        Navigator.pop(drawerContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RewardScreen(),
                          ),
                        );
                      },

                      // onClaimRewardTap: () {
                      //   Navigator.pop(drawerContext);

                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => const ClaimRewardScreen(),
                      //     ),
                      //   );
                      // },
                      onClaimRewardTap: () {
                        Navigator.pop(drawerContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider<RewardBloc>(
                                  create:
                                      (_) => RewardBloc(
                                        repository:
                                            context.read<RewardRepository>(),
                                      ),
                                  child: const ClaimRewardScreen(),
                                ),
                          ),
                        );
                      },

                      onLogoutTap: () {
                        final authBloc = drawerContext.read<AuthBloc>();

                        Navigator.pop(drawerContext);

                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return ConfirmationDialog(
                              title: 'Logout',
                              message: 'Are you sure you want to logout?',
                              cancelText: 'Cancel',
                              confirmText: 'Logout',
                              onConfirm: () {
                                Navigator.pop(dialogContext);

                                authBloc.add(const LogoutRequested());
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),

                body: IndexedStack(index: _selectedIndex, children: _screens),

                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: FloatingActionButton(
                    onPressed: _openScanner,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.qr_code_scanner, size: 28),
                  ),
                ),

                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,

                // bottomNavigationBar: BottomNavigationBar(
                //   currentIndex: _selectedIndex,
                //   onTap: _onTabSelected,
                //   type: BottomNavigationBarType.fixed,
                //   items: const [
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.home_outlined),
                //       activeIcon: Icon(Icons.home),
                //       label: 'Home',
                //     ),
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.calendar_today_outlined),
                //       activeIcon: Icon(Icons.calendar_today),
                //       label: 'Products',
                //     ),
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.person_outline),
                //       activeIcon: Icon(Icons.person),
                //       label: 'Profile',
                //     ),
                //   ],
                // ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildAnimatedNavItem(
                            index: 0,
                            icon: Icons.home_outlined,
                            activeIcon: Icons.home,
                            label: 'Home',
                          ),
                          _buildAnimatedNavItem(
                            index: 1,
                            icon: Icons.calendar_today_outlined,
                            activeIcon: Icons.calendar_today,
                            label: 'Products',
                          ),
                          _buildAnimatedNavItem(
                            index: 2,
                            icon: Icons.person_outline,
                            activeIcon: Icons.person,
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  //
  //   Widget _buildAnimatedNavItem({
  //   required int index,
  //   required IconData icon,
  //   required IconData activeIcon,
  //   required String label,
  // }) {
  //   final bool isSelected = _selectedIndex == index;

  //   return GestureDetector(
  //     onTap: () => _onTabSelected(index),
  //     behavior: HitTestBehavior.opaque,
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOutCubic,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: isSelected ? 18.w : 14.w,
  //         vertical: 10.h,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? AppColors.primary.withValues(alpha: 0.10)
  //             : Colors.transparent,
  //         borderRadius: BorderRadius.circular(16.r),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           AnimatedScale(
  //             scale: isSelected ? 1.15 : 1.0,
  //             duration: const Duration(milliseconds: 250),
  //             curve: Curves.easeOutBack,
  //             child: Icon(
  //               isSelected ? activeIcon : icon,
  //               color: isSelected
  //                   ? AppColors.primary
  //                   : Colors.grey.shade600,
  //               size: 22.sp,
  //             ),
  //           ),

  //           AnimatedSize(
  //             duration: const Duration(milliseconds: 250),
  //             curve: Curves.easeOutCubic,
  //             child: isSelected
  //                 ? Padding(
  //                     padding: EdgeInsets.only(left: 7.w),
  //                     child: Text(
  //                       label,
  //                       style: TextStyle(
  //                         color: AppColors.primary,
  //                         fontSize: 13.sp,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   )
  //                 : const SizedBox.shrink(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAnimatedNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,

        // Always use a finite width.
        width: isSelected ? 115.w : 50.w,
        height: 50.w,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withValues(alpha: 0.10)
                  : Colors.grey.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(23.r),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
                size: 22.sp,
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child:
                  isSelected
                      ? Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
