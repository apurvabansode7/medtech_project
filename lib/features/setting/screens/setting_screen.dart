import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/comfirmation_dialog.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/core/theme/theme_cubit.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_state.dart';
import 'package:medtech_project/features/auth/presentation/screens/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
    if (state is LogoutSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
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
    
   return  Stack(
       children:[Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.grey,
              foregroundColor: AppColors.white,
                  expandedHeight: 180.h,
                  pinned: true,
              title: const Text(
                'Settings',
              ),
       
       
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
                flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.primary,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: 20.h,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Manage your preferences',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
       
            
             SliverToBoxAdapter(
              child: Padding(
                padding:  EdgeInsets.all(8.w),
                child: Column(
                  children: [
                
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      trailing: Switch(
                        value: notificationEnabled,
                        onChanged: (value) {
                          setState(() {
              notificationEnabled = value;
            });
                        },
                      ),
                    ),   const Divider(),
       
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Privacy'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),   const Divider(),
       
                  
                  
       
                    ListTile(
            leading: const Icon(
              Icons.calendar_month_outlined,
            ),
            title: const Text('Appointment Reminders'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ), const Divider(),
                       ListTile(
            leading: const Icon(
              Icons.chat_outlined,
            ),
            title: const Text('Message Notifications'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
         const Divider(),
       
          // Preferences
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Theme'),
             trailing: BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, themeMode) {
      return Switch(
        value: themeMode == ThemeMode.dark,

        onChanged: (value) {
          context.read<ThemeCubit>().toggleTheme();
        },
      );
    },
  ),
          ),   
            ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
       
        ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Font Size'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
                     ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Accessibility'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
           const Divider(),
       
          // Support
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
       
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),  ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
           ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Contact Us'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Report a Problem'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
             // Support
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
           ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
           ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Privacy Policy'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
           ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('App Version'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
       
          const Divider(),  ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
           onTap: () {
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
       
              context.read<AuthBloc>().add(
                const LogoutRequested(),
              );
            },
          );
        },
           );
         },
          ),
                  ],
                ),
              ),
             )
       
          
          ],
          
        ),
       ),
         if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
       ] 
       
     ); });
  }
}