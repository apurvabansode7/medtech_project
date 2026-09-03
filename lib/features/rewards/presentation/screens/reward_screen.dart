import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/rewards/data/models/available_rewards_response.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/available_rewards_bloc.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/available_rewards_event.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/available_rewards_state.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_bloc.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_event.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_state.dart';
import 'package:medtech_project/features/rewards/presentation/widgets/available_reward_shimmer.dart';
import 'package:medtech_project/features/rewards/presentation/widgets/reward_card.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAvailableRewards();
    _scrollController.addListener(_onScroll);
  }

  void _fetchAvailableRewards() {
    context.read<AvailableRewardsBloc>().add(
          const LoadAvailableRewards(page: 1, limit: 10),
        );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<AvailableRewardsBloc>().add(const LoadMoreAvailableRewards());
    }
  }

  Future<void> _onRefresh() async {
    context.read<AvailableRewardsBloc>().add(
          const LoadAvailableRewards(page: 1, limit: 10, isRefresh: true),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onRedeem(AvailableRewardItem reward) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text('Claim Reward'),
          content: Text(
            'Do you want to claim ${reward.name} for ${reward.pointsRequired} points?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<RewardBloc>().add(
                      SubmitRewardClaim(rewardId: reward.id),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Claim',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: Text(
          'Rewards Product',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        // actions: [
        //   TextButton.icon(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => const ClaimRewardScreen(),
        //         ),
        //       );
        //     },
        //     icon: const Icon(
        //       Icons.history_rounded,
        //       color: AppColors.white,
        //       size: 20,
        //     ),
        //     label: Text(
        //       'My Claims',
        //       style: TextStyle(
        //         color: AppColors.white,
        //         fontSize: 13.sp,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ),
        //   SizedBox(width: 8.w),
        // ],
      ),
      body: BlocListener<RewardBloc, RewardState>(
        listener: (context, state) {
          if (state is ClaimRewardSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _fetchAvailableRewards();
          }

          if (state is ClaimRewardFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: BlocBuilder<AvailableRewardsBloc, AvailableRewardsState>(
            builder: (context, state) {
              // Initial Loading state with Shimmer Grid
              if (state is AvailableRewardsLoading || state is AvailableRewardsInitial) {
                return GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    mainAxisExtent: 290.h,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, __) => const AvailableRewardShimmer(),
                );
              }

              // Failure State
              if (state is AvailableRewardsFailure) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48.sp,
                          color: Colors.red.shade400,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _fetchAvailableRewards,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Loaded State
              if (state is AvailableRewardsLoaded) {
                final rewards = state.rewards;
                final walletBalance = state.walletBalance;

                if (rewards.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 200.h),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.card_giftcard_outlined,
                                size: 54.sp,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No rewards available',
                                style: TextStyle(
                                  fontSize: 15.sp,
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

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Column(
                    children: [
                      // Wallet Balance Header Bar
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        color: AppColors.primary.withValues(alpha: 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Wallet Balance',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.stars_rounded,
                                  size: 18.sp,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '$walletBalance Points',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            12.h,
                            16.w,
                            16.h,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            mainAxisExtent: 290.h,
                          ),
                          itemCount:
                              rewards.length + (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= rewards.length) {
                              return const AvailableRewardShimmer();
                            }

                            final reward = rewards[index];

                            return RewardCard.fromAvailableReward(
                              item: reward,
                              walletBalance: walletBalance,
                              onRedeem: () => _onRedeem(reward),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}