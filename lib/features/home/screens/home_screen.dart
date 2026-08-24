import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/home/data/home_banner_dummy_data.dart';
import 'package:medtech_project/features/home/widgets/home_banner.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanHistoryBloc>().add(LoadScanHistory(page: 1, limit: 5));

      context.read<WalletBloc>().add(LoadWalletTransactions(page: 1, limit: 5));
    });
  }

  Future<void> loadData() async {
    // Simulate API loading
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    final scanHistoryBloc = context.read<ScanHistoryBloc>();
    final walletBloc = context.read<WalletBloc>();

    scanHistoryBloc.add(LoadScanHistory(page: 1, limit: 5));

    walletBloc.add(LoadWalletTransactions(page: 1, limit: 5));

    try {
      await Future.wait([
        scanHistoryBloc.stream.firstWhere(
          (state) => state is ScanHistorySuccess || state is ScanHistoryFailure,
        ),
        walletBloc.stream.firstWhere(
          (state) => state is WalletSuccess || state is WalletFailure,
        ),
      ]);
    } catch (e) {
      debugPrint('Home refresh error: $e');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'How can we help you today?',
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                  ),
                ),

                SizedBox(height: 24.h),

                if (isLoading)
                  _buildBannerShimmer()
                else
                  SizedBox(
                    height: 160.h,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: HomeBannerDummyData.banners.length,
                      itemBuilder: (context, index) {
                        final banner = HomeBannerDummyData.banners[index];

                        return HomeBanner(
                          title: banner.title,
                          description: banner.description,
                          icon: banner.icon,
                        );
                      },
                    ),
                  ),

                //SizedBox(height: 24.h),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                //   child: Text(
                //     'Product Rewards',
                //     style: TextStyle(
                //       fontSize: 19.sp,
                //       fontWeight: FontWeight.bold,
                //       color: AppColors.textPrimary,
                //     ),
                //   ),
                // ),
                // SizedBox(height: 12.h),
                // if (isLoading)
                //   _buildProductRewardShimmer()
                // else
                //   ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: ProductRewardDummyData.rewards.length,
                //     itemBuilder: (context, index) {
                //       final reward = ProductRewardDummyData.rewards[index];

                //       return Padding(
                //         padding: EdgeInsets.only(bottom: 12.h),
                //         child: ProductReward(
                //           productName: reward.productName,
                //           rewardPoints: reward.rewardPoints,
                //           description: reward.description,
                //           onTap: () {
                //             // Open product/reward details
                //           },
                //         ),
                //       );
                //     },
                //   ),
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

  Widget _buildProductRewardShimmer() {
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
            width: double.infinity,
            height: 175.h,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Container(
                      height: 16.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Product name
                Container(
                  height: 14.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),

                SizedBox(height: 8.h),

                // Description
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
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),

                const Spacer(),

                // Reward + button
                Row(
                  children: [
                    Container(
                      width: 110.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),

                    const Spacer(),

                    Container(
                      width: 90.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
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
