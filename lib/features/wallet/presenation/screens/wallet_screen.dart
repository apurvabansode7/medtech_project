import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/features/wallet/domain/repositories/wallet_repositories.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_bloc.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_event.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_state.dart';
import 'package:medtech_project/features/wallet/presenation/widgets/wallet_card.dart';
import 'package:shimmer/shimmer.dart';

import 'package:medtech_project/constant/app_colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => WalletBloc(
        repository: context.read<WalletRepository>(),
      ),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatefulWidget {
  const _WalletView();

  @override
  State<_WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<_WalletView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WalletBloc>().add(LoadWalletTransactions());
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    // Load next page when user is near the bottom.
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<WalletBloc>().add(LoadMoreWalletTransactions());
    }
  }

  Future<void> _onRefresh() async {
    context.read<WalletBloc>().add(RefreshWalletTransactions());

    await context.read<WalletBloc>().stream.firstWhere(
      (state) => state is WalletSuccess || state is WalletFailure,
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
    
         iconTheme: const IconThemeData(
    color: AppColors.white,
  ),
        surfaceTintColor: AppColors.transparent,
        title: Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoading) {
              return _buildShimmerList();
            }

            if (state is WalletFailure) {
              return _buildErrorState(state.message);
            }

            if (state is WalletSuccess) {
              if (state.transactions.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  itemCount:
                      state.transactions.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Bottom pagination loader
                    if (index == state.transactions.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                      );
                    }

                    final transaction = state.transactions[index];

                    return WalletTransactionCard(transaction: transaction);
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

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            height: 145.h,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
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
                        color: AppColors.white,
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
                            color: AppColors.white,
                          ),

                          SizedBox(height: 8.h),

                          Container(
                            height: 10.h,
                            width: 170.w,
                            color: AppColors.white,
                          ),

                          SizedBox(height: 6.h),

                          Container(
                            height: 10.h,
                            width: 130.w,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Container(
                      height: 16.h,
                      width: 45.w,
                      color: AppColors.white,
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.white,
                ),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Container(
                      height: 12.h,
                      width: 100.w,
                      color: AppColors.white,
                    ),

                    const Spacer(),

                    Container(
                      height: 12.h,
                      width: 90.w,
                      color: AppColors.white,
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

  // EMPTY STATE

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 60.sp,
              color: Colors.grey.shade400,
            ),

            SizedBox(height: 16.h),

            Text(
              'No Transactions Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Your wallet transactions will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // ERROR STATE

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
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 55.sp,
                    color: Colors.red.shade300,
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    'Unable to Load Wallet',
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
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  ElevatedButton(
                    onPressed: () {
                      context.read<WalletBloc>().add(
                        LoadWalletTransactions(page: 1, limit: 5),
                      );
                    },
                    child: const Text('Retry'),
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
