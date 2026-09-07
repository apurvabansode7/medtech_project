import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';

import 'package:medtech_project/features/home/data/models/partner_campaign_response.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';
import 'package:medtech_project/features/home/presentation/widgets/animated_points_summary.dart';

import 'package:medtech_project/features/home/presentation/widgets/campaign_card.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_earnings_bloc.dart.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_rewards_bloc.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_subscribed_bloc.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_subscribed_event.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_subscribed_state.dart';
import 'package:medtech_project/features/subscribe/presentation/screens/subscription_details_screen.dart';

import 'package:skeletonizer/skeletonizer.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  static const int pageSize = 10;

  final ScrollController _scrollController = ScrollController();

  final List<PartnerCampaign> _subscribedCampaigns = [];

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFirstPage();
    });
  }

  void _loadFirstPage() {
    if (!mounted) return;

    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;

    _subscribedCampaigns.clear();

    setState(() {});

    context.read<CampaignSubscribedBloc>().add(
      CampaignSubscribedRequested(page: 1, pageSize: pageSize),
    );
  }

  void _loadNextPage() {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    _isLoadingMore = true;

    setState(() {});

    final nextPage = _currentPage + 1;

    context.read<CampaignSubscribedBloc>().add(
      CampaignSubscribedRequested(page: nextPage, pageSize: pageSize),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  Future<void> _onRefresh() async {
    if (!mounted) return;

    final bloc = context.read<CampaignSubscribedBloc>();

    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;
    _subscribedCampaigns.clear();

    setState(() {});

    bloc.add(CampaignSubscribedRequested(page: 1, pageSize: pageSize));

    await bloc.stream.firstWhere(
      (state) =>
          state is CampaignSubscribedSuccess ||
          state is CampaignSubscribedFailure,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _processCampaignSuccess(CampaignSubscribedSuccess state) {
    final data = state.response.data;

    if (data.currentPage == 1) {
      _subscribedCampaigns.clear();
    }

    for (final campaign in data.items) {
      if (!_subscribedCampaigns.any(
        (c) => c.campaignId == campaign.campaignId,
      )) {
        _subscribedCampaigns.add(campaign);
      }
    }

    _currentPage = data.currentPage;

    _hasMore = data.currentPage < data.totalPages;

    _isLoadingMore = false;
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
          ' Subscribed Campaign',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ),
      body: BlocConsumer<CampaignSubscribedBloc, CampaignSubscribedState>(
        listener: (context, state) {
          if (state is CampaignSubscribedSuccess) {
            _processCampaignSuccess(state);

            if (mounted) {
              setState(() {});
            }
          }

          if (state is CampaignSubscribedFailure) {
            _isLoadingMore = false;

            if (mounted) {
              setState(() {});
            }
          }
        },

        builder: (context, state) {
          if (state is CampaignSubscribedSuccess) {
            _processCampaignSuccess(state);
          }

          if (state is CampaignSubscribedLoading &&
              _subscribedCampaigns.isEmpty) {
            return _buildShimmer();
          }

          if (state is CampaignSubscribedFailure &&
              _subscribedCampaigns.isEmpty) {
            return _buildError(state.message);
          }

          if (_subscribedCampaigns.isEmpty) {
            return _buildEmpty();
          }

          // return RefreshIndicator(
          //   onRefresh: _onRefresh,
          //   child: ListView.builder(
          //     controller: _scrollController,
          //     physics: const AlwaysScrollableScrollPhysics(),
          //     padding: EdgeInsets.all(16.w),
          //     itemCount: _subscribedCampaigns.length + (_isLoadingMore ? 1 : 0),
          //     itemBuilder: (context, index) {
          //       if (index >= _subscribedCampaigns.length) {
          //         return _buildLoadingMore();
          //       }

          //       final campaign = _subscribedCampaigns[index];

          //       return Padding(
          //         padding: EdgeInsets.only(bottom: 12.h),
          //         child: GestureDetector(

          //           onTap: () {
          //             final repository = context.read<CampaignRepository>();

          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder:
          //                     (_) => MultiBlocProvider(
          //                       providers: [
          //                         BlocProvider<CampaignEarningsBloc>(
          //                           create:
          //                               (_) => CampaignEarningsBloc(
          //                                 repository: repository,
          //                               ),
          //                         ),
          //                         BlocProvider<CampaignRewardsBloc>(
          //                           create:
          //                               (_) => CampaignRewardsBloc(
          //                                 repository: repository,
          //                               ),
          //                         ),
          //                       ],
          //                       child: SubscriptionDetailsScreen(
          //                         campaign: campaign,
          //                       ),
          //                     ),
          //               ),
          //             );
          //           },
          //           child: CampaignCard(
          //             title: campaign.name,
          //             description: campaign.description,
          //             pointsAvailable: campaign.pointsAvailable,
          //             icon: Icons.card_giftcard,
          //             isLoading: false,
          //             showSubscribeButton: false,
          //             onSubscribeTap: () {},
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // );

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),

              // +1 = AnimatedPointsSummary
              // +1 = loading indicator when loading more
              itemCount:
                  _subscribedCampaigns.length + 1 + (_isLoadingMore ? 1 : 0),

              itemBuilder: (context, index) {
                // POINTS SUMMARY AT TOP

                if (index == 0) {
                  return _buildPointsSummary();
                }

                // LOADING MORE

                if (index == _subscribedCampaigns.length + 1) {
                  return _buildLoadingMore();
                }

                // CAMPAIGN CARD

                final campaign = _subscribedCampaigns[index - 1];

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: GestureDetector(
                    onTap: () {
                      final repository = context.read<CampaignRepository>();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<CampaignEarningsBloc>(
                                    create:
                                        (_) => CampaignEarningsBloc(
                                          repository: repository,
                                        ),
                                  ),
                                  BlocProvider<CampaignRewardsBloc>(
                                    create:
                                        (_) => CampaignRewardsBloc(
                                          repository: repository,
                                        ),
                                  ),
                                ],
                                child: SubscriptionDetailsScreen(
                                  campaign: campaign,
                                ),
                              ),
                        ),
                      );
                    },
                    child: CampaignCard(
                      title: campaign.name,
                      description: campaign.description,
                      pointsAvailable: campaign.pointsAvailable,
                      icon: Icons.card_giftcard,
                      isLoading: false,
                      showSubscribeButton: false,
                      onSubscribeTap: () {},
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 60.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No subscribed campaigns',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your subscribed campaigns will '
                    'appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50.sp, color: Colors.red),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadFirstPage,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMore() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
Widget _buildShimmer() {
  return Skeletonizer(
    enabled: true,
    child: ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 150.h,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Bone.circle(size: 44.w),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone(
                          width: 150.w,
                          height: 15.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(height: 8.h),
                        Bone(
                          width: 110.w,
                          height: 11.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    ),
                  ),
                  Bone(
                    width: 60.w,
                    height: 24.h,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ],
              ),
              const Spacer(),
              Bone(
                width: double.infinity,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(height: 8.h),
              Bone(
                width: 190.w,
                height: 11.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  Widget _buildPointsSummary() {
    if (_subscribedCampaigns.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalEarned = _subscribedCampaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.pointsEarned,
    );

    final totalAvailable = _subscribedCampaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.pointsAvailable,
    );

    final pendingPoints = totalEarned - totalAvailable;

    return AnimatedPointsSummary(
      totalEarned: totalEarned,
      requiredPoints: totalAvailable,
      pendingPoints: pendingPoints,
       showSchemaPoints: false,
    );
  }
}
