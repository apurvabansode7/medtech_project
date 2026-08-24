import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.initial,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final String? initial;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) {
                return placeholder ??
                    Container(
                      color: backgroundColor ?? Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
              },
              errorWidget: (context, url, error) {
                return errorWidget ??
                    _DefaultErrorWidget(
                      initial: initial,
                      backgroundColor: backgroundColor,
                    );
              },
            )
          : _DefaultErrorWidget(
              initial: initial,
              backgroundColor: backgroundColor,
            ),
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({
    this.initial,
    this.backgroundColor,
  });

  final String? initial;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final name = initial?.trim() ?? '';

    final firstLetter = name.isNotEmpty
        ? name.substring(0, 1).toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor ?? Colors.grey.shade100,
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }
}