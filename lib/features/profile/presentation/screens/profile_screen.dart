import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/components/cached_network_image.dart';

import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_event.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_state.dart';
import 'package:medtech_project/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:medtech_project/features/profile/presentation/widgets/profile_shimmer.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const ProfileShimmer();
            }

            if (state is ProfileFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 50.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 12.h),
                      Text(state.message, textAlign: TextAlign.center),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(const LoadProfile());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileLoaded) {
              final profile = state.profile;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(const LoadProfile());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 14.h),

                      // Profile header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildProfileHeader(profile, context),
                      ),

                      SizedBox(height: 22.h),

                      _buildSectionTitle('Personal Information'),

                      SizedBox(height: 10.h),

                      _buildInfoCard(
                        children: [
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            title: 'Owner Name',
                            value: profile.ownerName,
                          ),
                          _buildInfoRow(
                            icon: Icons.business_outlined,
                            title: 'Business Name',
                            value: profile.businessName,
                          ),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: profile.email,
                          ),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: profile.phone,
                          ),
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            title: 'Reference ID',
                            value: profile.referenceId,
                          ),
                          _buildInfoRow(
                            icon: Icons.receipt_long_outlined,
                            title: 'GST Number',
                            value: profile.gstNumber,
                          ),
                        ],
                      ),

                      SizedBox(height: 22.h),

                      _buildSectionTitle('Account Information'),

                      SizedBox(height: 10.h),

                      _buildInfoCard(
                        children: [
                          _buildInfoRow(
                            icon: Icons.verified_outlined,
                            title: 'Approval Status',
                            value: profile.approvalStatus,
                          ),
                          _buildInfoRow(
                            icon: Icons.account_circle_outlined,
                            title: 'Account Status',
                            value: profile.status,
                          ),
                          _buildInfoRow(
                            icon: Icons.location_on_outlined,
                            title: 'Region',
                            value: profile.region?.name ?? '-',
                          ),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            title: 'Email Verified',
                            value:
                                profile.isEmailVerified
                                    ? 'Verified'
                                    : 'Not Verified',
                          ),
                          _buildInfoRow(
                            icon: Icons.phone_android_outlined,
                            title: 'Phone Verified',
                            value:
                                profile.isPhoneVerified
                                    ? 'Verified'
                                    : 'Not Verified',
                          ),
                        ],
                      ),

                      SizedBox(height: 22.h),

                      _buildSectionTitle('Wallet'),

                      SizedBox(height: 10.h),

                      _buildInfoCard(
                        children: [
                          _buildInfoRow(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Available Balance',
                            value:
                                '${profile.availableBalance.toStringAsFixed(0)} points',
                          ),
                          _buildInfoRow(
                            icon: Icons.stars_outlined,
                            title: 'Total Points Earned',
                            value:
                                '${profile.totalPointsEarned.toStringAsFixed(0)} points',
                          ),
                        ],
                      ),

                      if (profile.assignedMedicalRepresentative != null) ...[
                        SizedBox(height: 22.h),

                        _buildSectionTitle('Medical Representative'),

                        SizedBox(height: 10.h),

                        _buildInfoCard(
                          children: [
                            _buildInfoRow(
                              icon: Icons.person_outline,
                              title: 'Name',
                              value:
                                  profile
                                      .assignedMedicalRepresentative!
                                      .fullName,
                            ),
                            _buildInfoRow(
                              icon: Icons.badge_outlined,
                              title: 'Employee Code',
                              value:
                                  profile
                                      .assignedMedicalRepresentative!
                                      .employeeCode,
                            ),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              title: 'Email',
                              value:
                                  profile.assignedMedicalRepresentative!.email,
                            ),
                            _buildInfoRow(
                              icon: Icons.phone_outlined,
                              title: 'Phone',
                              value:
                                  profile.assignedMedicalRepresentative!.phone,
                            ),
                          ],
                        ),
                      ],

                      // if (profile.business.isNotEmpty) ...[
                      //   SizedBox(height: 22.h),

                      //   _buildSectionTitle('Business Details'),

                      //   SizedBox(height: 10.h),

                      //   _buildInfoCard(
                      //     children: [
                      //       _buildInfoRow(
                      //         icon: Icons.store_outlined,
                      //         title: 'Outlet',
                      //         value: profile.business.first.outletName,
                      //       ),
                      //       _buildInfoRow(
                      //         icon: Icons.person_outline,
                      //         title: 'Username',
                      //         value: profile.business.first.userName,
                      //       ),
                      //       _buildInfoRow(
                      //         icon: Icons.badge_outlined,
                      //         title: 'PAN Number',
                      //         value: profile.business.first.panNumber,
                      //       ),
                      //       _buildInfoRow(
                      //         icon: Icons.medical_information_outlined,
                      //         title: 'Drug License',
                      //         value: profile.business.first.drugLicenseNumber,
                      //       ),
                      //       _buildInfoRow(
                      //         icon: Icons.location_on_outlined,
                      //         title: 'Address',
                      //         value:
                      //             '${profile.business.first.addressLine1}, '
                      //             '${profile.business.first.city}, '
                      //             '${profile.business.first.state} - '
                      //             '${profile.business.first.pincode}',
                      //       ),
                      //       _buildInfoRow(
                      //         icon: Icons.verified_outlined,
                      //         title: 'Approval',
                      //         value: profile.business.first.approvalStatus,
                      //       ),
                      //     ],
                      //   ),
                      // ],
                      // for the testing only 
                      if (profile.business.isNotEmpty) ...[
  SizedBox(height: 22.h),

  _buildSectionTitle('Business Details'),

  SizedBox(height: 10.h),

  Column(
    children: profile.business.map((business) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: _buildInfoCard(
          children: [
            _buildInfoRow(
              icon: Icons.store_outlined,
              title: 'Outlet',
              value: business.outletName,
            ),

            _buildInfoRow(
              icon: Icons.person_outline,
              title: 'Username',
              value: business.userName,
            ),

            _buildInfoRow(
              icon: Icons.badge_outlined,
              title: 'PAN Number',
              value: business.panNumber,
            ),

            _buildInfoRow(
              icon: Icons.medical_information_outlined,
              title: 'Drug License',
              value: business.drugLicenseNumber,
            ),

            _buildInfoRow(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value:
                  '${business.addressLine1}, '
                  '${business.city}, '
                  '${business.state} - '
                  '${business.pincode}',
            ),

            _buildInfoRow(
              icon: Icons.verified_outlined,
              title: 'Approval',
              value: business.approvalStatus,
            ),
          ],
        ),
      );
    }).toList(),
  ),
],
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(profile, BuildContext context) {
    final String ownerName = profile.ownerName.trim();

    // Change profile.profileImage to your actual model field name
    final String imageUrl = profile.profileImage ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // =====================================================
          // PROFILE IMAGE / INITIAL
          // =====================================================

          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: CachedImage(
                imageUrl: imageUrl,
                width: 58.w,
                height: 58.w,
                fit: BoxFit.cover,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                initial: ownerName,
                placeholder: Container(
                  color: Colors.white.withValues(alpha: 0.15),
                  alignment: Alignment.center,
                  child: Text(
                    _getInitial(ownerName),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                errorWidget: Container(
                  color: Colors.white.withValues(alpha: 0.15),
                  alignment: Alignment.center,
                  child: Text(
                    _getInitial(ownerName),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // =====================================================
          // PROFILE DETAILS
          // =====================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ownerName.isEmpty ? 'MedTech User' : ownerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  profile.businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12.sp,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  profile.referenceId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(profile: profile),
                  ),
                );

                if (result == true && context.mounted) {
                  context.read<ProfileBloc>().add(const LoadProfile());
                }
              },
              icon: Icon(Icons.edit_outlined, color: Colors.white, size: 20.sp),
              tooltip: 'Edit Profile',
            ),
          ),
        ],
      ),
    );
  }

  String _getInitial(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName.substring(0, 1).toUpperCase();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21.sp),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  value.isEmpty ? '-' : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
