// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:medtech_project/constant/app_colors.dart';
// import 'package:medtech_project/features/rewards/presentation/bloc/reward_bloc.dart';
// import 'package:medtech_project/features/rewards/presentation/bloc/reward_event.dart';
// import 'package:medtech_project/features/rewards/presentation/bloc/reward_state.dart';
// import 'package:medtech_project/features/rewards/presentation/widgets/reward_claim_card.dart';
// import 'package:medtech_project/features/rewards/presentation/widgets/reward_claim_shimmer.dart';

// class ClaimRewardScreen extends StatefulWidget {
//   const ClaimRewardScreen({super.key});

//   @override
//   State<ClaimRewardScreen> createState() => _ClaimRewardScreenState();
// }

// class _ClaimRewardScreenState extends State<ClaimRewardScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchClaims();
//     _scrollController.addListener(_onScroll);
//   }

//   void _fetchClaims() {
//     context.read<RewardBloc>().add(
//           const RewardClaimsRequested(page: 1, limit: 10),
//         );
//   }

//   void _onScroll() {
//     if (!_scrollController.hasClients) return;

//     final position = _scrollController.position;
//     if (position.pixels >= position.maxScrollExtent - 200) {
//       context.read<RewardBloc>().add(const LoadMoreRewardClaims());
//     }
//   }

//   Future<void> _onRefresh() async {
//     context.read<RewardBloc>().add(
//           const RewardClaimsRequested(page: 1, limit: 10, isRefresh: true),
//         );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         surfaceTintColor: AppColors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: AppColors.white),
//         title: Text(
//           'My Reward Claims',
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w500,
//             color: AppColors.white,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: BlocBuilder<RewardBloc, RewardState>(
//           builder: (context, state) {
//             // Initial loading state with shimmer
//             if (state is RewardClaimsLoading || state is RewardInitial) {
//               return ListView.builder(
//                 padding: EdgeInsets.all(16.w),
//                 itemCount: 6,
//                 itemBuilder: (_, __) => const RewardClaimShimmer(),
//               );
//             }

//             // Failure state
//             if (state is RewardClaimsFailure) {
//               return Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(24.w),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline_rounded,
//                         size: 48.sp,
//                         color: Colors.red.shade400,
//                       ),
//                       SizedBox(height: 12.h),
//                       Text(
//                         state.message,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       ElevatedButton(
//                         onPressed: _fetchClaims,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                         ),
//                         child: Text(
//                           'Retry',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             // Loaded state
//             if (state is RewardClaimsSuccess) {
//               final claims = state.claims;

//               if (claims.isEmpty) {
//                 return RefreshIndicator(
//                   onRefresh: _onRefresh,
//                   child: ListView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     children: [
//                       SizedBox(height: 180.h),
//                       Center(
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(20.w),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary.withOpacity(0.08),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.card_giftcard_outlined,
//                                 size: 54.sp,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             SizedBox(height: 16.h),
//                             Text(
//                               'No Reward Claims Yet',
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textPrimary,
//                               ),
//                             ),
//                             SizedBox(height: 6.h),
//                             Text(
//                               'You have not submitted any reward claims.',
//                               style: TextStyle(
//                                 fontSize: 13.sp,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: _onRefresh,
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 16.h,
//                   ),
//                   itemCount: claims.length + (state.isLoadingMore ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     if (index >= claims.length) {
//                       return const RewardClaimShimmer();
//                     }

//                     final claim = claims[index];
//                     return RewardClaimCard(claim: claim);
//                   },
//                 ),
//               );
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_bloc.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_event.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_state.dart';
import 'package:medtech_project/features/rewards/presentation/widgets/reward_claim_card.dart';
import 'package:medtech_project/features/rewards/presentation/widgets/reward_claim_shimmer.dart';

class ClaimRewardScreen extends StatefulWidget {
  const ClaimRewardScreen({super.key});

  @override
  State<ClaimRewardScreen> createState() => _ClaimRewardScreenState();
}

class _ClaimRewardScreenState extends State<ClaimRewardScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchClaims();
    });
  }

  void _fetchClaims() {
    context.read<RewardBloc>().add(
          const RewardClaimsRequested(
            page: 1,
            limit: 10,
          ),
        );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    // Load next page when user is near bottom.
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<RewardBloc>().add(
            const LoadMoreRewardClaims(),
          );
    }
  }

  Future<void> _onRefresh() async {
    context.read<RewardBloc>().add(
          const RewardClaimsRequested(
            page: 1,
            limit: 10,
            isRefresh: true,
          ),
        );

    // Wait until refresh API call finishes.
    await context.read<RewardBloc>().stream.firstWhere(
          (state) =>
              state is RewardClaimsSuccess ||
              state is RewardClaimsFailure,
        );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.transparent,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: Text(
          'Claims Rewards',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<RewardBloc, RewardState>(
          builder: (context, state) {
            // --------------------------------
            // INITIAL / REFRESH LOADING
            // --------------------------------
            if (state is RewardClaimsLoading ||
                state is RewardInitial) {
              return _buildShimmerList();
            }

            // --------------------------------
            // FAILURE
            // --------------------------------
            if (state is RewardClaimsFailure) {
              return _buildErrorState(state.message);
            }

            // --------------------------------
            // SUCCESS
            // --------------------------------
            if (state is RewardClaimsSuccess) {
              final claims = state.claims;

              // Empty state
              if (claims.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.primary,
                  child: ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 180.h),
                      _buildEmptyState(),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: ListView.builder(
                  controller: _scrollController,
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: claims.length +
                      (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // --------------------------------
                    // PAGINATION LOADER
                    // --------------------------------
                    if (index == claims.length) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child:
                                const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    final claim = claims[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.h,
                      ),
                      child: RewardClaimCard(
                        claim: claim,
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ============================================
  // SHIMMER
  // ============================================

  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: const RewardClaimShimmer(),
        );
      },
    );
  }

  // ============================================
  // EMPTY STATE
  // ============================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color:
                    AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.card_giftcard_outlined,
                size: 54.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Reward Claims Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your reward claims will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // ERROR STATE
  // ============================================

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 180.h),
          Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 55.sp,
                    color: Colors.red.shade300,
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Unable to Load Reward Claims',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  ElevatedButton(
                    onPressed: _fetchClaims,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                      ),
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
}