import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/home/data/models/partner_campaign_response.dart';
import 'package:medtech_project/features/subscribe/data/models/campaign_rewards_response.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_earnings_bloc.dart.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_earnings_event.dart.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_earnings_state.dart.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_rewards_bloc.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_rewards_event.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_rewards_state.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  const SubscriptionDetailsScreen({super.key, required this.campaign});

  final PartnerCampaign campaign;

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CampaignEarningsBloc>().add(
        CampaignEarningsRequested(
          campaignId: widget.campaign.campaignId,
          page: 1,
          pageSize: 20,
        ),
      );

      context.read<CampaignRewardsBloc>().add(
        CampaignRewardsRequested(campaignId: widget.campaign.campaignId),
      );
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final state = context.read<CampaignEarningsBloc>().state;

    if (state is! CampaignEarningsSuccess) return;
    if (state.isLoadingMore) return;

    final data = state.response.data;

    if (data.currentPage >= data.totalPages) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CampaignEarningsBloc>().add(
        CampaignEarningsRequested(
          campaignId: widget.campaign.campaignId,
          page: data.currentPage + 1,
          pageSize: 20,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final earningsBloc = context.read<CampaignEarningsBloc>();
    final rewardsBloc = context.read<CampaignRewardsBloc>();

    earningsBloc.add(
      CampaignEarningsRequested(campaignId: widget.campaign.campaignId),
    );
    rewardsBloc.add(
      CampaignRewardsRequested(campaignId: widget.campaign.campaignId),
    );

    await Future.wait([
      earningsBloc.stream.firstWhere(
        (state) =>
            state is CampaignEarningsSuccess ||
            state is CampaignEarningsFailure,
      ),
      rewardsBloc.stream.firstWhere(
        (state) =>
            state is CampaignRewardsSuccess || state is CampaignRewardsFailure,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        iconTheme: const IconThemeData(color: AppColors.white),

        title: Text(
          'Schema Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CampaignEarningsBloc, CampaignEarningsState>(
            listener: (context, state) {
              if (state is CampaignEarningsFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<CampaignRewardsBloc, CampaignRewardsState>(
            listener: (context, state) {
              if (state is CampaignRewardsFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is ClaimCampaignRewardSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                // Refresh rewards & earnings dynamically after claim
                context.read<CampaignRewardsBloc>().add(
                  CampaignRewardsRequested(
                    campaignId: widget.campaign.campaignId,
                  ),
                );
                context.read<CampaignEarningsBloc>().add(
                  CampaignEarningsRequested(
                    campaignId: widget.campaign.campaignId,
                    page: 1,
                    pageSize: 20,
                  ),
                );
              }
              if (state is ClaimCampaignRewardFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            children: [
              // Earnings / Stats Section
              BlocBuilder<CampaignEarningsBloc, CampaignEarningsState>(
                builder: (context, earningsState) {
                  if (earningsState is CampaignEarningsLoading) {
                    return _buildEarningsShimmer();
                  }

                  if (earningsState is CampaignEarningsFailure) {
                    return _buildEarningsError(earningsState.message);
                  }

                  final earnedPoints =
                      earningsState is CampaignEarningsSuccess
                          ? earningsState.response.data.pointsAvailable
                          : 0;

                  return BlocBuilder<CampaignRewardsBloc, CampaignRewardsState>(
                    builder: (context, rewardsState) {
                      // final claimableRewards =
                      //     rewardsState is CampaignRewardsSuccess
                      //         ? rewardsState.response.data.rewards.length
                      //         : 0;

                      // debugPrint('CLAIMABLE REWARDS: $claimableRewards');

                      int claimableRewards = 0;

                      if (rewardsState is CampaignRewardsSuccess) {
                        claimableRewards =
                            rewardsState.response.data.rewards.length;
                      } else if (rewardsState is ClaimCampaignRewardLoading) {
                        claimableRewards =
                            rewardsState.response.data.rewards.length;
                      } else if (rewardsState is ClaimCampaignRewardSuccess) {
                        claimableRewards =
                            rewardsState.response.data.rewards.length;
                      } else if (rewardsState is ClaimCampaignRewardFailure) {
                        claimableRewards =
                            rewardsState.response.data.rewards.length;
                      }

                      return _buildSubscriptionCard(
                        earnedPoints: earnedPoints,
                        claimableRewards: claimableRewards,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),

              // Section Title
              Text(
                'Claimable Rewards',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 12.h),
              BlocBuilder<CampaignEarningsBloc, CampaignEarningsState>(
                builder: (context, earningsState) {
                  final earnedPoints =
                      earningsState is CampaignEarningsSuccess
                          ? earningsState.response.data.pointsAvailable
                          : 0;

                  return BlocBuilder<CampaignRewardsBloc, CampaignRewardsState>(
                    builder: (context, rewardsState) {
                      if (rewardsState is CampaignRewardsLoading) {
                        return _buildRewardsShimmer();
                      }

                      if (rewardsState is CampaignRewardsFailure) {
                        return _buildRewardsError(rewardsState.message);
                      }

                      CampaignRewardsResponse? response;

                      if (rewardsState is CampaignRewardsSuccess) {
                        response = rewardsState.response;
                      } else if (rewardsState is ClaimCampaignRewardLoading) {
                        response = rewardsState.response;
                      } else if (rewardsState is ClaimCampaignRewardSuccess) {
                        response = rewardsState.response;
                      } else if (rewardsState is ClaimCampaignRewardFailure) {
                        response = rewardsState.response;
                      }

                      if (response == null) {
                        return const SizedBox.shrink();
                      }

                      final rewards = response.data.rewards;

                      debugPrint('TOTAL REWARDS: ${rewards.length}');

                      for (int i = 0; i < rewards.length; i++) {
                        debugPrint(
                          'REWARD $i: ${rewards[i].name} | '
                          'rewardId: ${rewards[i].rewardId}',
                        );
                      }

                      if (rewards.isEmpty) {
                        return _buildEmptyRewards();
                      }

                      return Column(
                        children:
                            rewards
                                .map(
                                  (item) => _buildRewardCard(
                                    item,
                                    earnedPoints: earnedPoints,
                                  ),
                                )
                                .toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required int earnedPoints,
    required int claimableRewards,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campaign Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52.w,
                width: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.card_giftcard,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.campaign.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      widget.campaign.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.3,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          SizedBox(height: 20.h),

          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.card_giftcard_outlined,
                  value: '$claimableRewards',
                  title: 'Claimable Rewards',
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _buildStatItem(
                  icon: Icons.stars_rounded,
                  value: '$earnedPoints',
                  title: 'Earned Points',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 21.sp, color: AppColors.primary),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(
    CampaignRewardItem rewardItem, {
    required int earnedPoints,
  }) {
    final name =
        rewardItem.name.isNotEmpty
            ? rewardItem.name
            : (rewardItem.rewardProduct?.name ?? '');
    final description =
        rewardItem.description.isNotEmpty
            ? rewardItem.description
            : (rewardItem.rewardProduct?.description ?? '');
    final brand =
        rewardItem.brand.isNotEmpty
            ? rewardItem.brand
            : (rewardItem.rewardProduct?.brand ?? '');
    final images =
        rewardItem.images.isNotEmpty
            ? rewardItem.images
            : (rewardItem.rewardProduct?.images ?? []);
    final pointsRequired = rewardItem.pointsRequired;

    final canClaim = earnedPoints >= pointsRequired;

    final rewardsState = context.watch<CampaignRewardsBloc>().state;
    final rewardId =
        rewardItem.rewardId.isNotEmpty
            ? rewardItem.rewardId
            : rewardItem.rewardProduct?.rewardProductId ?? '';
    final isClaimingThis =
        rewardsState is ClaimCampaignRewardLoading &&
        rewardsState.rewardId == rewardId;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Icon
              Container(
                height: 52.w,
                width: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child:
                    images.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            images.first,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Icon(
                                  Icons.card_giftcard,
                                  color: AppColors.primary,
                                  size: 26.sp,
                                ),
                          ),
                        )
                        : Icon(
                          Icons.card_giftcard,
                          color: AppColors.primary,
                          size: 26.sp,
                        ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    if (brand.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        'Brand: $brand',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    if (description.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.3,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          SizedBox(height: 12.h),

          Row(
            children: [
              // Required Points Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: 16.sp,
                      color: Colors.orange,
                    ),

                    SizedBox(width: 4.w),

                    Text(
                      '$pointsRequired Points',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Claim Button
              SizedBox(
                width: 80.w,
                height: 35.h,
                child: ElevatedButton(
                  onPressed:
                      (canClaim && !isClaimingThis)
                          ? () {
                            context.read<CampaignRewardsBloc>().add(
                              ClaimCampaignRewardRequested(
                                campaignId: widget.campaign.campaignId,
                                rewardId: rewardId,
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: AppColors.white,
                    disabledForegroundColor: Colors.grey.shade600,
                    elevation: canClaim ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                  ),
                  child:
                      isClaimingThis
                          ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                          : Text(
                            'Claim',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRewards() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(Icons.card_giftcard_outlined, size: 44.sp, color: Colors.grey),
          SizedBox(height: 8.h),
          Text(
            'No rewards available',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'There are currently no claimable rewards for this campaign.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 160.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
    );
  }

  Widget _buildRewardsShimmer() {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsError(String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: Colors.red.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsError(String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: Colors.red.shade800),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CampaignRewardsBloc>().add(
                CampaignRewardsRequested(
                  campaignId: widget.campaign.campaignId,
                ),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
