import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/interested_product/domain/repositories/interested_product_repository.dart';
import 'package:medtech_project/features/interested_product/presentation/bloc/interested_product_bloc.dart';
import 'package:medtech_project/features/interested_product/presentation/bloc/interested_product_event.dart';
import 'package:medtech_project/features/interested_product/presentation/bloc/interested_product_state.dart';
import 'package:medtech_project/features/interested_product/presentation/widgets/interested_product_card.dart';
import 'package:medtech_project/features/interested_product/presentation/widgets/intereted_product_shimmer.dart';

class InterestedScreen extends StatelessWidget {
  const InterestedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InterestedProductBloc>(
      create: (context) => InterestedProductBloc(
        repository: context.read<InterestedProductRepository>(),
      ),
      child: const _InterestedView(),
    );
  }
}

class _InterestedView extends StatefulWidget {
  const _InterestedView();

  @override
  State<_InterestedView> createState() => _InterestedViewState();
}

class _InterestedViewState extends State<_InterestedView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<InterestedProductBloc>().add(LoadInterestedProducts());
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Load next page when user reaches near bottom
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<InterestedProductBloc>().add(LoadMoreInterestedProducts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    context.read<InterestedProductBloc>().add(
      LoadInterestedProducts(refresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
         iconTheme: const IconThemeData(
    color: AppColors.white,
  ),
        title: Text(
          'Interested',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.white
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<InterestedProductBloc, InterestedProductState>(
          builder: (context, state) {
            // Initial loading
            if (state is InterestedProductLoading) {
              return const InterestedProductShimmer();
            }

            // Error
            if (state is InterestedProductFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<InterestedProductBloc>().add(
                    LoadInterestedProducts(),
                  );
                },
              );
            }

            // Loaded
            if (state is InterestedProductSuccess) {
              if (state.products.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 300.h,
                        child: Center(
                          child: Text(
                            'No interested products',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  itemCount:
                      state.products.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Bottom loading indicator
                    if (index == state.products.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final product = state.products[index];

                    return InterestedProductCard(product: product);
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
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 45.sp, color: Colors.redAccent),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
