import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

// Campaign
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_bloc.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_event.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_state.dart';
import 'package:medtech_project/features/home/presentation/bloc/campaign_bloc.dart';
import 'package:medtech_project/features/home/presentation/bloc/campaign_event.dart';
import 'package:medtech_project/features/home/presentation/bloc/campaign_state.dart';
import 'package:medtech_project/features/home/presentation/widgets/animated_points_summary.dart';
import 'package:medtech_project/features/home/presentation/widgets/campaign_card.dart';
import 'package:medtech_project/features/home/presentation/widgets/points_summary_card.dart';

// Profile
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_state.dart';

// Scan History
import 'package:medtech_project/features/scan_history/domain/repositories/scan_history_repository.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_bloc.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_event.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_state.dart';
import 'package:medtech_project/features/scan_history/presentation/screens/scan_history_screen.dart';
import 'package:medtech_project/features/scan_history/presentation/widgtes/scan_history_card.dart';

// Wallet
import 'package:medtech_project/features/wallet/domain/repositories/wallet_repositories.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_bloc.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_event.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_state.dart';
import 'package:medtech_project/features/wallet/presenation/screens/wallet_screen.dart';
import 'package:medtech_project/features/wallet/presenation/widgets/wallet_card.dart';
import 'package:medtech_project/utils/app_snack_bar.dart';

import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Home Bloc
        BlocProvider<CampaignBloc>(
          create:
              (context) =>
                  CampaignBloc(repository: context.read<CampaignRepository>())
                    ..add(CampaignRequested(page: 1, pageSize: 10)),
        ),

        // Campaign Enroll Bloc
        BlocProvider<CampaignEnrollBloc>(
          create:
              (context) => CampaignEnrollBloc(
                repository: context.read<CampaignRepository>(),
              ),
        ),

        // Scan History Bloc
        BlocProvider<ScanHistoryBloc>(
          create:
              (context) => ScanHistoryBloc(
                repository: context.read<ScanHistoryRepository>(),
              )..add(LoadScanHistory(page: 1, limit: 5)),
        ),

        // Wallet Bloc
        BlocProvider<WalletBloc>(
          create:
              (context) =>
                  WalletBloc(repository: context.read<WalletRepository>())
                    ..add(LoadWalletTransactions(page: 1, limit: 5)),
        ),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  final Set<String> _subscribedCampaignIds = {};

  Future<void> _onRefresh() async {
    if (!mounted) return;

    final scanHistoryBloc = context.read<ScanHistoryBloc>();
    final walletBloc = context.read<WalletBloc>();
    final homeBloc = context.read<CampaignBloc>();

    // Reload scan history
    scanHistoryBloc.add(LoadScanHistory(page: 1, limit: 5));

    // Reload wallet transactions
    walletBloc.add(LoadWalletTransactions(page: 1, limit: 5));

    // Reload campaigns
    homeBloc.add(CampaignRequested(page: 1, pageSize: 10));

    try {
      await Future.wait([
        scanHistoryBloc.stream.firstWhere(
          (state) => state is ScanHistorySuccess || state is ScanHistoryFailure,
        ),
        walletBloc.stream.firstWhere(
          (state) => state is WalletSuccess || state is WalletFailure,
        ),
        homeBloc.stream.firstWhere(
          (state) => state is CampaignSuccess || state is CampaignFailure,
        ),
      ]);
    } catch (e) {
      debugPrint('Home refresh error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'How can we help you today?',
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const PointsSummaryCard(
                    totalEarnedPoints: 1250,
                    earnedPoints: 1000,
                    pendingPoints: 250,
                    schemaTotalPoints: 500,
                    schemaEarnedPoints: 400,
                    schemaPendingPoints: 100,
                  ),
                ),
                // CAMPAIGNS
                BlocConsumer<CampaignEnrollBloc, CampaignEnrollState>(
                  listener: (context, enrollState) {
                    if (enrollState is CampaignEnrollSuccess) {
                      setState(() {
                        _subscribedCampaignIds.add(enrollState.campaignId);
                      });
                      AppSnackbar.success(enrollState.message);

                      // Reload campaigns after successful enrollment
                      context.read<CampaignBloc>().add(
                        CampaignRequested(page: 1, pageSize: 10),
                      );
                    }

                    if (enrollState is CampaignEnrollFailure) {
                      AppSnackbar.error(enrollState.message);
                    }
                  },
                  builder: (context, enrollState) {
                    final loadingCampaignId =
                        enrollState is CampaignEnrollLoading
                            ? enrollState.campaignId
                            : null;

                    return BlocBuilder<CampaignBloc, CampaignState>(
                      builder: (context, homeState) {
                        // Campaign loading
                        if (homeState is CampaignLoading ||
                            homeState is CampaignInitial) {
                          return _buildBannerShimmer();
                        }

                        // Campaign error
                        if (homeState is CampaignFailure) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              homeState.message,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        // Campaign success
                        if (homeState is CampaignSuccess) {
                          final allCampaigns = homeState.response.data.items;

                          // Only show campaigns that are NOT subscribed
                          final campaigns =
                              allCampaigns.where((campaign) {
                                final isSubscribed =
                                    campaign.isSubscribed ||
                                    _subscribedCampaignIds.contains(
                                      campaign.id,
                                    );

                                return !isSubscribed;
                              }).toList();

                          // No campaigns available
                          if (campaigns.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return SizedBox(
                            height: 160.h,

                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: campaigns.length,
                              itemBuilder: (context, index) {
                                final campaign = campaigns[index];

                                return CampaignCard(
                                  title: campaign.name,
                                  description: campaign.description,
                                  icon: Icons.card_giftcard,
                                  isLoading: loadingCampaignId == campaign.id,

                                  // Already filtered subscribed campaigns
                                  showSubscribeButton: true,

                                  onSubscribeTap: () {
                                    final profileState =
                                        context.read<ProfileBloc>().state;

                                    if (profileState is ProfileLoaded) {
                                      final profile = profileState.profile;

                                      context.read<CampaignEnrollBloc>().add(
                                        EnrollCampaignRequested(
                                          campaignId: campaign.id,
                                          partnerId: profile.id,
                                          partnerType: profile.type,
                                          regionId: profile.regionId ?? '',
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Profile loading, please try again',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // SCAN HISTORY HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Text(
                        'Scan History',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScanHistoryScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // SCAN HISTORY
                BlocBuilder<ScanHistoryBloc, ScanHistoryState>(
                  builder: (context, state) {
                    if (state is ScanHistoryLoading) {
                      return _buildScanHistoryShimmer();
                    }

                    if (state is ScanHistoryFailure) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Center(
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is ScanHistorySuccess) {
                      if (state.scans.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Center(
                            child: Text(
                              'No scan history found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      // Show latest 5 scans
                      final scans = state.scans.take(5).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: scans.length,
                        itemBuilder: (context, index) {
                          return ScanHistoryCard(scan: scans[index]);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                SizedBox(height: 24.h),

                // WALLET HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Text(
                        'Wallet Transactions',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => WalletScreen()),
                          );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // WALLET TRANSACTIONS
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    if (state is WalletLoading) {
                      return _buildWalletTransactionShimmer();
                    }

                    if (state is WalletFailure) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is WalletSuccess) {
                      if (state.transactions.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Center(
                            child: Text(
                              'No wallet transactions found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      // Show latest 5 transactions
                      final transactions = state.transactions.take(5).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          return WalletTransactionCard(
                            transaction: transactions[index],
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CAMPAIGN SHIMMER
  Widget _buildBannerShimmer() {
    return SizedBox(
      height: 180.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Skeletonizer(
            child: Container(
              width: 300.w,
              height: 170.h,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Bone(width: 150.w, height: 18.h),

                        SizedBox(height: 10.h),

                        Bone(width: double.infinity, height: 10.h),

                        SizedBox(height: 6.h),

                        Bone(width: 110.w, height: 10.h),

                        SizedBox(height: 14.h),

                        Bone(
                          width: 70.w,
                          height: 28.h,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Bone.circle(size: 72.w),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // WALLET SHIMMER

  Widget _buildWalletTransactionShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Bone.circle(size: 46.w),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Bone(width: 120.w, height: 14.h),
                          SizedBox(height: 8.h),
                          Bone(width: 180.w, height: 10.h),
                          SizedBox(height: 6.h),
                          Bone(width: 130.w, height: 10.h),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Bone(width: 45.w, height: 16.h),
                  ],
                ),

                SizedBox(height: 18.h),

                Bone(width: double.infinity, height: 1.h),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Bone(width: 100.w, height: 12.h),
                    const Spacer(),
                    Bone(width: 90.w, height: 12.h),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // SCAN HISTORY SHIMMER
  Widget _buildScanHistoryShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Bone.circle(size: 44.w),

                    SizedBox(width: 12.w),

                    Expanded(child: Bone(height: 16.h)),
                  ],
                ),

                SizedBox(height: 20.h),

                Bone(width: double.infinity, height: 12.h),

                SizedBox(height: 10.h),

                Bone(width: 250.w, height: 12.h),

                SizedBox(height: 10.h),

                Bone(width: 200.w, height: 12.h),

                SizedBox(height: 16.h),

                Bone(
                  width: double.infinity,
                  height: 35.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
