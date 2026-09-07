import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medtech_project/features/product/domain/repositories/showcase_product_repository.dart';
import 'package:medtech_project/features/product/presentation/bloc/product_interest_bloc.dart';
import 'package:medtech_project/features/product/presentation/bloc/showcase_product_bloc.dart';
import 'package:medtech_project/features/product/presentation/bloc/showcase_product_event.dart';
import 'package:medtech_project/features/product/presentation/bloc/showcase_product_state.dart';
import 'package:medtech_project/features/product/presentation/widgets/showcase_product_card.dart';
import 'package:medtech_project/features/product/presentation/widgets/showcase_product_shimmer.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShowcaseProductBloc>(
          create: (context) => ShowcaseProductBloc(
            repository: context.read<ShowcaseProductRepository>(),
          ),
        ),
        BlocProvider<ProductInterestBloc>(
          create: (context) => ProductInterestBloc(
            repository: context.read<ShowcaseProductRepository>(),
          ),
        ),
      ],
      child: const _ProductView(),
    );
  }
}

class _ProductView extends StatefulWidget {
  const _ProductView();

  @override
  State<_ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<_ProductView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ShowcaseProductBloc>().add(const LoadShowcaseProducts());
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<ShowcaseProductBloc>().add(const LoadMoreShowcaseProducts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<ShowcaseProductBloc>().add(const LoadShowcaseProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ShowcaseProductBloc, ShowcaseProductState>(
          builder: (context, state) {
            // Initial loading
            if (state is ShowcaseProductLoading) {
              return GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.68,
                  mainAxisExtent: 265.h
                ),
                itemCount: 6,
                itemBuilder: (_, index) {
                  return const ShowcaseProductShimmer();
                },
              );
            }
        
            // Error
            if (state is ShowcaseProductFailure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 45, color: Colors.grey),
                    SizedBox(height: 12.h),
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ShowcaseProductBloc>().add(
                          const LoadShowcaseProducts(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
        
            // Loaded
            if (state is ShowcaseProductLoaded) {
              if (state.products.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    children: [
                      SizedBox(height: 250.h),
                      const Center(child: Text('No products found')),
                    ],
                  ),
                );
              }
        
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: GridView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.68,
                    mainAxisExtent: 265.h,
                  ),
                  itemCount:
                      state.products.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.products.length) {
                      return const ShowcaseProductShimmer();
                    }
        
                    final product = state.products[index];
        
                    return ShowcaseProductCard(product: product);
                  },
                ),
              );
            }
        
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
