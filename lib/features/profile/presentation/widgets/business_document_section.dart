import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:medtech_project/constant/app_colors.dart';

class BusinessDocumentSection extends StatelessWidget {
  final dynamic business;

  final List<XFile> selectedDocuments;

  final VoidCallback? onUploadTap;
  final void Function(int index)? onRemoveDocument;

  const BusinessDocumentSection({
    super.key,
    required this.business,
    required this.selectedDocuments,
    this.onRemoveDocument,
    this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    final existingDocuments = business?.documents ?? [];

    final bool hasDocuments =
        existingDocuments.isNotEmpty || selectedDocuments.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documents',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 10.h),

        SizedBox(
          height: 120.h,
          child:
              !hasDocuments
                  ? _buildNoDocuments()
                  : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        existingDocuments.length + selectedDocuments.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      // Existing API document
                      if (index < existingDocuments.length) {
                        final document = existingDocuments[index];

                        final String fileName =
                            document is Map<String, dynamic>
                                ? (document['name'] ??
                                        document['fileName'] ??
                                        document['documentName'] ??
                                        'Document')
                                    .toString()
                                : 'Document';

                        return _buildExistingDocumentItem(fileName: fileName);
                      }

                      // Newly selected document
                      final int localIndex =
                          (index - existingDocuments.length).toInt();

                      final XFile file = selectedDocuments[localIndex];

                      return _buildSelectedDocumentItem(file, localIndex);
                    },
                  ),
        ),

        SizedBox(height: 12.h),

        InkWell(
          onTap: onUploadTap,
          borderRadius: BorderRadius.circular(9.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 13.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(9.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),

                SizedBox(width: 8.w),

                Text(
                  'Upload Document',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // NEW CAMERA / GALLERY IMAGE
  // ------------------------------------------------------------
  Widget _buildSelectedDocumentItem(XFile file, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 115.w,
          height: 120.h,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(file.path),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

      
        Positioned(
          top: -6.h,
          right: -6.w,
          child: GestureDetector(
            onTap: () {
              onRemoveDocument?.call(index);
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.close, color: Colors.white, size: 14.sp),
            ),
          ),
        ),
      ],
    );
  }
  // ------------------------------------------------------------
  // EXISTING API DOCUMENT
  // ------------------------------------------------------------

  Widget _buildExistingDocumentItem({required String fileName}) {
    return Container(
      width: 115.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),

          SizedBox(height: 7.h),

          Text(
            fileName,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDocuments() {
    return InkWell(
              onTap: onUploadTap,

      child: Container(
        width: 115.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 28.sp,
              color: AppColors.textSecondary,
            ),
      
            SizedBox(height: 5.h),
      
            Text(
              'No documents',
              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
