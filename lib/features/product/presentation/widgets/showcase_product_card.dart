
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:medtech_project/components/cached_network_image.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/product/data/models/showcase_product_model.dart';
import 'package:medtech_project/features/product/presentation/bloc/product_interest_bloc.dart';
import 'package:medtech_project/features/product/presentation/bloc/product_interest_event.dart';
import 'package:medtech_project/features/product/presentation/bloc/product_interest_state.dart';

class ShowcaseProductCard extends StatelessWidget {
  const ShowcaseProductCard({super.key, required this.product});

  final ShowcaseProduct product;

  String get imageUrl {
    if (product.images.isEmpty) {
      return '';
    }

    final primaryImage = product.images.where((image) => image.isPrimary);

    if (primaryImage.isNotEmpty) {
      return primaryImage.first.url;
    }

    return product.images.first.url;
  }

  void _showInterestDialog(BuildContext context) {
    final quantityController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            final quantity = int.tryParse(quantityController.text.trim());

            final isQuantityValid = quantity != null && quantity > 0;

            final noteLength = noteController.text.length;

            return BlocProvider.value(
              value: context.read<ProductInterestBloc>(),
              child: Dialog(
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Show Interest',
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Request this product',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            borderRadius: BorderRadius.circular(20.r),
                            onTap: () {
                              Navigator.pop(dialogContext);
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18.sp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h),

                      // QUANTITY
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 7.h),

                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter quantity',
                          counterText: '',
                          prefixIcon: Icon(
                            Icons.inventory_2_outlined,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 13.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // NOTE
                      Text(
                        'Note',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 7.h),

                      TextField(
                        controller: noteController,
                        maxLength: 50,
                        maxLines: 3,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Add a note (optional)',
                          counterText: '',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 42.h),
                            child: Icon(Icons.edit_note_rounded, size: 20.sp),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 13.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$noteLength/50',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                noteLength >= 50
                                    ? AppColors.error
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // BUTTONS
                      BlocConsumer<ProductInterestBloc, ProductInterestState>(
                        listener: (context, state) {
                          if (state is ProductInterestSuccess) {
                            Navigator.pop(dialogContext);

                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () {
                                Fluttertoast.showToast(
                                  msg: state.message,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: AppColors.success,
                                  textColor: Colors.white,
                                  fontSize: 14.sp,
                                );
                              },
                            );
                          }

                          if (state is ProductInterestFailure) {
                            Fluttertoast.showToast(
                              msg: state.message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: AppColors.error,
                              textColor: Colors.white,
                              fontSize: 14.sp,
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is ProductInterestLoading;

                          return Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 38.h,
                                  child: OutlinedButton(
                                    onPressed:
                                        isLoading
                                            ? null
                                            : () {
                                              Navigator.pop(dialogContext);
                                            },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10.w),

                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 38.h,
                                  child: ElevatedButton(
                                    onPressed:
                                        (isLoading || !isQuantityValid)
                                            ? null
                                            : () {
                                              context
                                                  .read<ProductInterestBloc>()
                                                  .add(
                                                    SubmitProductInterest(
                                                      productId: product.id,
                                                      quantityRequested:
                                                          quantity,
                                                      note:
                                                          noteController.text
                                                              .trim(),
                                                    ),
                                                  );
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      disabledBackgroundColor:
                                          Colors.grey.shade300,
                                      disabledForegroundColor:
                                          Colors.grey.shade600,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                    child:
                                        isLoading
                                            ? SizedBox(
                                              width: 18.w,
                                              height: 18.w,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                            )
                                            : Text(
                                              'Submit Interest',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      height: 265.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: double.infinity,
              height: 120.h,
              color: Colors.grey.shade50,
              child:
                  hasImage
                      ? CachedImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 120.h,
                        fit: BoxFit.contain,
                        backgroundColor: Colors.white,
                        initial: product.name,
                      )
                      : Center(
                        child: Text(
                          product.name.isNotEmpty
                              ? product.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
            ),
          ),

          SizedBox(height: 10.h),

          // CATEGORY
          if (product.category != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                product.category!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 6.h),
          ],

          // PRODUCT NAME
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 4.h),

          // PRODUCT CODE
          Text(
            product.productCode,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondary),
          ),

          // IMPORTANT:
          // This takes remaining available space.
          const Spacer(),

          // PRICE + BUTTON
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '₹${product.chemistPrice}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 6.w),

              SizedBox(
                width: 70.w,
                height: 32.h,
                child: ElevatedButton(
                  onPressed: () {
                    _showInterestDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Interested',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
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
}
