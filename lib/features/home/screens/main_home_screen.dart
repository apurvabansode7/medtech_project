import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/comfirmation_dialog.dart';
import 'package:medtech_project/components/custom_app_bar.dart';
import 'package:medtech_project/components/custom_drawer.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_state.dart';
import 'package:medtech_project/features/auth/presentation/screens/login_screen.dart';
import 'package:medtech_project/features/home/screens/home_screen.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_event.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_state.dart';
import 'package:medtech_project/features/profile/presentation/screens/profile_screen.dart';
import 'package:medtech_project/features/interested_product/presentation/screens/interested_product_screen.dart';
import 'package:medtech_project/features/product/presentation/screens/product_screen.dart';
import 'package:medtech_project/features/scanner/presentation/screens/product_scanner_screen.dart';
import 'package:medtech_project/features/setting/screens/setting_screen.dart';
import 'package:medtech_project/features/wallet/presenation/screens/wallet_screen.dart';

@RoutePage()
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(const LoadProfile());
  }

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
      MaterialPageRoute(builder: (_) => const ProductScannerScreen()),
    );

    if (!mounted) return;

    if (scannedCode != null && scannedCode.isNotEmpty) {
      debugPrint('Scanned Product Code: $scannedCode');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Scanned: $scannedCode')));
    }
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
            Scaffold(
              appBar: CustomAppBar(title: ''),

              // Custom Drawer
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
                        MaterialPageRoute(
                          builder: (_) => const InterestedScreen(),
                        ),
                      );
                    },

                    onWalletTap: () {
                      Navigator.pop(drawerContext);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WalletScreen()),
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
              // Current tab
              body: IndexedStack(index: _selectedIndex, children: _screens),

              floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 10.w),
                child: FloatingActionButton(
                  onPressed: () {
                    // Open Scanner Screen

                    _openScanner();
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.qr_code_scanner, size: 28),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,

              // Bottom navigation
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onTabSelected,
                type: BottomNavigationBarType.fixed,

                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today),
                    label: 'Products',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
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
}
