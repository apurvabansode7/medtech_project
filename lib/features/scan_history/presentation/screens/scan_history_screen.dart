import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/scan_history/domain/repositories/scan_history_repository.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_bloc.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_event.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_state.dart';
import 'package:medtech_project/features/scan_history/presentation/widgtes/scan_history_card.dart';
import 'package:shimmer/shimmer.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanHistoryBloc>(
      create: (context) => ScanHistoryBloc(
        repository: context.read<ScanHistoryRepository>(),
      ),
      child: const _ScanHistoryView(),
    );
  }
}

class _ScanHistoryView extends StatefulWidget {
  const _ScanHistoryView();

  @override
  State<_ScanHistoryView> createState() => _ScanHistoryViewState();
}

class _ScanHistoryViewState extends State<_ScanHistoryView> {
  late final ScrollController _scrollController;

  final int _limit = 10;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ScanHistoryBloc>().add(
            LoadScanHistory(page: 1, limit: _limit),
          );
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    final bloc = context.read<ScanHistoryBloc>();
    final state = bloc.state;

    if (state is! ScanHistorySuccess) return;

    if (state.isLoadingMore) return;

    if (state.currentPage >= state.totalPages) return;

    final nextPage = state.currentPage + 1;

    bloc.add(LoadScanHistory(page: nextPage, limit: _limit));
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<ScanHistoryBloc>();

    bloc.add(LoadScanHistory(page: 1, limit: _limit));

    try {
      await bloc.stream.firstWhere(
        (state) => state is ScanHistorySuccess || state is ScanHistoryFailure,
      );
    } catch (e) {
      debugPrint('Scan history refresh error: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: AppColors.transparent,
        title: Text(
          'Scan History',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<ScanHistoryBloc, ScanHistoryState>(
        builder: (context, state) {
          if (state is ScanHistoryLoading) {
            return _buildInitialLoading();
          }

          if (state is ScanHistoryFailure) {
            // return _buildErrorState(state.message);
          }

          if (state is ScanHistorySuccess) {
            if (state.scans.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                itemCount: state.scans.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.scans.length) {
                    return _buildLoadMoreIndicator();
                  }

                  final scan = state.scans[index];

                  return ScanHistoryCard(scan: scan);
                },
              ),
            );
          }

          return _buildInitialLoading();
        },
      ),
    );
  }

  Widget _buildInitialLoading() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildCardShimmer();
      },
    );
  }

  Widget _buildCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1200),
      child: Container(
        height: 220.h,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Circle icon
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: 12.w),

                // Product + outlet
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Container(
                        height: 11.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status
                Container(
                  height: 26.h,
                  width: 65.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            Container(height: 1, width: double.infinity, color: Colors.white),

            SizedBox(height: 16.h),

            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: 8.w),

                Container(
                  height: 11.h,
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: 8.w),

                Container(
                  height: 11.h,
                  width: 220.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Container(
              height: 38.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.primary,

                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history, size: 40.sp, color: AppColors.error),
            ),

            SizedBox(height: 18.h),

            Text(
              'No Scan History',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Your product scan history will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Center(
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
