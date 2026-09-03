import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_bloc.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_event.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_state.dart';
import 'package:medtech_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:medtech_project/features/home/presentation/bloc/home_event.dart';
import 'package:medtech_project/features/home/presentation/bloc/home_state.dart';
import 'package:medtech_project/features/home/presentation/widgets/campaign_card.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_state.dart';

import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_bloc.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_event.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_state.dart';
import 'package:medtech_project/features/scan_history/presentation/screens/scan_history_screen.dart';
import 'package:medtech_project/features/scan_history/presentation/widgtes/scan_history_card.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_bloc.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_event.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_state.dart';
import 'package:medtech_project/features/wallet/presenation/screens/wallet_screen.dart';
import 'package:medtech_project/features/wallet/presenation/widgets/wallet_card.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _subscribedCampaignIds = {};
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<ScanHistoryBloc>().add(LoadScanHistory(page: 1, limit: 5));

  //     context.read<WalletBloc>().add(LoadWalletTransactions(page: 1, limit: 5));
  //   });
  // }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanHistoryBloc>().add(LoadScanHistory(page: 1, limit: 5));

      context.read<WalletBloc>().add(LoadWalletTransactions(page: 1, limit: 5));
      context.read<HomeBloc>().add(CampaignRequested(page: 1, pageSize: 10));
    });
  }

  Future<void> _onRefresh() async {
    if (!mounted) return;

    final scanHistoryBloc = context.read<ScanHistoryBloc>();
    final walletBloc = context.read<WalletBloc>();
    final homeBloc = context.read<HomeBloc>();

    scanHistoryBloc.add(LoadScanHistory(page: 1, limit: 5));

    walletBloc.add(LoadWalletTransactions(page: 1, limit: 5));

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

                BlocConsumer<CampaignEnrollBloc, CampaignEnrollState>(
                  listener: (context, enrollState) {
                    if (enrollState is CampaignEnrollSuccess) {
                      setState(() {
                        _subscribedCampaignIds.add(enrollState.campaignId);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(enrollState.message),
                          backgroundColor: Colors.green,
                        ),
                      );

                      context.read<HomeBloc>().add(
                        CampaignRequested(page: 1, pageSize: 10),
                      );
                    }

                    if (enrollState is CampaignEnrollFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(enrollState.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, enrollState) {
                    final loadingCampaignId =
                        enrollState is CampaignEnrollLoading
                            ? enrollState.campaignId
                            : null;

                    return BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, homeState) {
                        if (homeState is CampaignLoading ||
                            homeState is HomeInitial) {
                          return _buildBannerShimmer();
                        }

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

                        // if (homeState is CampaignSuccess) {
                        //   final campaigns = homeState.response.data.items;

                        //   if (campaigns.isEmpty) {
                        //     return const SizedBox.shrink();
                        //   }

                        //   return SizedBox(
                        //     height: 160.h,
                        //     child: ListView.builder(
                        //       padding: EdgeInsets.symmetric(
                        //         horizontal: 16.w,
                        //       ),
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: campaigns.length,
                        //       itemBuilder: (context, index) {
                        //         final campaign = campaigns[index];
                        //         final isSubscribed =
                        //             campaign.isSubscribed ||
                        //             _subscribedCampaignIds.contains(
                        //               campaign.id,
                        //             );

                        //         return CampaignCard(
                        //           title: campaign.name,
                        //           description: campaign.description,
                        //           icon: Icons.card_giftcard,
                        //           isLoading:
                        //               loadingCampaignId == campaign.id,
                        //           showSubscribeButton: !isSubscribed,
                        //           onSubscribeTap: () {
                        //             final profileState =
                        //                 context.read<ProfileBloc>().state;
                        //             if (profileState is ProfileLoaded) {
                        //               final profile = profileState.profile;
                        //               context.read<CampaignEnrollBloc>().add(
                        //                 EnrollCampaignRequested(
                        //                   campaignId: campaign.id,
                        //                   partnerId: profile.id,
                        //                   partnerType: profile.type,
                        //                   regionId: profile.regionId ?? '',
                        //                 ),
                        //               );
                        //             } else {
                        //               ScaffoldMessenger.of(context).showSnackBar(
                        //                 const SnackBar(
                        //                   content: Text(
                        //                     'Profile loading, please try again',
                        //                   ),
                        //                 ),
                        //               );
                        //             }
                        //           },
                        //         );
                        //       },
                        //     ),
                        //   );
                        // }

                        if (homeState is CampaignSuccess) {
                          final allCampaigns = homeState.response.data.items;

                          // Only show campaigns that are NOT subscribed.
                          final campaigns =
                              allCampaigns.where((campaign) {
                                final isSubscribed =
                                    campaign.isSubscribed ||
                                    _subscribedCampaignIds.contains(
                                      campaign.id,
                                    );

                                return !isSubscribed;
                              }).toList();

                          // No campaigns available to subscribe.
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

                                  // Since we already filtered subscribed campaigns,
                                  // every displayed card gets Subscribe Now.
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
                              builder: (_) => const ScanHistoryScreen(),
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

                      // Home screen should show only latest 5 scans.
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
                            MaterialPageRoute(
                              builder: (_) => const WalletScreen(),
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

                      // Home screen shows only latest 5 transactions.
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

  Widget buildCard({required String description}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Icon(Icons.medical_services, size: 35.sp),

            SizedBox(width: 16.w),

            Expanded(
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerShimmer() {
    return SizedBox(
      height: 160.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: 300.w,
              height: 150.h,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Row(
                  children: [
                    // Left content
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),

                          SizedBox(height: 10.h),

                          Container(
                            height: 10.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),

                          SizedBox(height: 6.h),

                          Container(
                            height: 10.h,
                            width: 110.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),

                          SizedBox(height: 14.h),

                          Container(
                            height: 28.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Icon placeholder
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWalletTransactionShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 145.h,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14.h,
                            width: 120.w,
                            color: Colors.white,
                          ),

                          SizedBox(height: 8.h),

                          Container(
                            height: 10.h,
                            width: 180.w,
                            color: Colors.white,
                          ),

                          SizedBox(height: 6.h),

                          Container(
                            height: 10.h,
                            width: 130.w,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Container(height: 16.h, width: 45.w, color: Colors.white),
                  ],
                ),

                SizedBox(height: 18.h),

                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.white,
                ),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Container(height: 12.h, width: 100.w, color: Colors.white),

                    const Spacer(),

                    Container(height: 12.h, width: 90.w, color: Colors.white),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanHistoryShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            height: 220.h,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Container(
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),

                SizedBox(height: 10.h),

                Container(
                  height: 12.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),

                SizedBox(height: 10.h),

                Container(
                  height: 12.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),

                const Spacer(),

                Container(
                  height: 35.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
