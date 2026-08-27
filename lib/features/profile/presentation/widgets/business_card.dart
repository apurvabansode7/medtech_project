import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:medtech_project/components/apptextfield.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/core/location/location_helper.dart';
import 'package:medtech_project/features/profile/presentation/widgets/address_type_field.dart';

import 'package:medtech_project/features/profile/presentation/widgets/business_date_field.dart';
import 'package:medtech_project/features/profile/presentation/widgets/business_document_section.dart';

// ============================================================
// BUSINESS CARD
// ============================================================

class BusinessCard extends StatefulWidget {
  final dynamic business;
  final dynamic controllers;
  final int index;

  const BusinessCard({
    super.key,
    required this.business,
    required this.controllers,
    required this.index,
  });

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

// ============================================================
// STATE
// ============================================================

class _BusinessCardState extends State<BusinessCard> {
  final List<XFile> selectedDocuments = [];

  bool isGettingLocation = false;

  // ============================================================
  // DOCUMENT OPTIONS
  // ============================================================

  void _showDocumentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),

      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 40.w,
                  height: 4.h,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,

                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  'Upload Document',

                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 20.h),

                // CAMERA
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.w),

                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.camera_alt_outlined,

                      color: AppColors.primary,
                    ),
                  ),

                  title: const Text('Camera'),

                  subtitle: const Text('Take a photo of the document'),

                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    await _pickFromCamera();
                  },
                ),

                // GALLERY
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.w),

                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.photo_library_outlined,

                      color: AppColors.primary,
                    ),
                  ),

                  title: const Text('Gallery'),

                  subtitle: const Text('Choose an image from gallery'),

                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    await _pickFromGallery();
                  },
                ),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // REMOVE DOCUMENT
  // ============================================================

  void _removeSelectedDocument(int index) {
    if (index < 0 || index >= selectedDocuments.length) {
      return;
    }

    setState(() {
      selectedDocuments.removeAt(index);
    });
  }

  // ============================================================
  // GET CURRENT LOCATION
  // ============================================================

  Future<void> _getCurrentLocation() async {
    if (isGettingLocation) {
      return;
    }

    setState(() {
      isGettingLocation = true;
    });

    try {
      final position = await LocationHelper.getCurrentLocation();

      if (!mounted) {
        return;
      }

      setState(() {
        widget.controllers.latitudeController.text = position.latitude
            .toStringAsFixed(6);

        widget.controllers.longitudeController.text = position.longitude
            .toStringAsFixed(6);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current location updated successfully')),
      );
    } catch (e) {
      debugPrint('Location error: $e');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // CAMERA DOCUMENT
  // ============================================================

  Future<void> _pickFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        selectedDocuments.add(image);
      });

      debugPrint('Camera file: ${image.path}');
    } catch (e) {
      debugPrint('Camera error: $e');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to capture document: $e')));
    }
  }

  // ============================================================
  // GALLERY DOCUMENT
  // ============================================================

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        selectedDocuments.add(image);
      });

      debugPrint('Gallery file: ${image.path}');
    } catch (e) {
      debugPrint('Gallery error: $e');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to select document: $e')));
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 8,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _buildHeader(),

          SizedBox(height: 20.h),

          // OUTLET NAME
          AppTextField(
            controller: widget.controllers.outletNameController,

            label: 'Outlet Name',

            hint: 'Enter outlet name',
          ),

          SizedBox(height: 16.h),

          // USERNAME
          AppTextField(
            controller: widget.controllers.usernameController,

            label: 'Username',

            hint: 'Enter username',
          ),

          SizedBox(height: 16.h),

          // PAN
          AppTextField(
            controller: widget.controllers.panController,

            label: 'PAN Number',

            hint: 'Enter PAN number',

            maxLength: 10,

            textCapitalization: TextCapitalization.characters,
          ),

          SizedBox(height: 16.h),

          // DRUG LICENSE
          AppTextField(
            controller: widget.controllers.drugLicenseController,

            label: 'Drug License Number',

            hint: 'Enter drug license number',

            textCapitalization: TextCapitalization.characters,
          ),

          SizedBox(height: 16.h),

          // DRUG LICENSE EXPIRY
          BusinessDateField(
            controller: widget.controllers.drugLicenseExpiryController,

            label: 'Drug License Expiry',
          ),

          SizedBox(height: 16.h),

          // ADDRESS TYPE
          AddressTypeField(
            controller: widget.controllers.addressTypeController,
          ),

          SizedBox(height: 16.h),

          // ADDRESS LINE 1
          AppTextField(
            controller: widget.controllers.addressLine1Controller,

            label: 'Address Line 1',

            hint: 'Enter address',
          ),

          SizedBox(height: 16.h),

          // ADDRESS LINE 2
          AppTextField(
            controller: widget.controllers.addressLine2Controller,

            label: 'Address Line 2',

            hint: 'Enter address line 2',
          ),

          SizedBox(height: 16.h),

          // LANDMARK
          AppTextField(
            controller: widget.controllers.landmarkController,

            label: 'Landmark',

            hint: 'Enter landmark',
          ),

          SizedBox(height: 16.h),

          // CITY
          AppTextField(
            controller: widget.controllers.cityController,

            label: 'City',

            hint: 'Enter city',
          ),

          SizedBox(height: 16.h),

          // DISTRICT
          AppTextField(
            controller: widget.controllers.districtController,

            label: 'District',

            hint: 'Enter district',
          ),

          SizedBox(height: 16.h),

          // STATE
          AppTextField(
            controller: widget.controllers.stateController,

            label: 'State',

            hint: 'Enter state',
          ),

          SizedBox(height: 16.h),

          // PINCODE
          AppTextField(
            controller: widget.controllers.pincodeController,

            label: 'Pincode',

            hint: 'Enter pincode',

            keyboardType: TextInputType.number,

            maxLength: 6,
          ),

          SizedBox(height: 16.h),

          // LATITUDE / LONGITUDE
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: widget.controllers.latitudeController,
                  readOnly:true,

                  label: 'Latitude',

                  hint: 'Latitude',

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: AppTextField(
                  controller: widget.controllers.longitudeController,
                    readOnly: true,

                  label: 'Longitude',

                  hint: 'Longitude',

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // CURRENT LOCATION
          SizedBox(
            width: double.infinity,

            child: OutlinedButton.icon(
              onPressed: isGettingLocation ? null : _getCurrentLocation,

              icon:
                  isGettingLocation
                      ? SizedBox(
                        width: 18.w,
                        height: 18.w,

                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Icon(
                        Icons.my_location,
                        color: AppColors.primary,
                        size: 19.sp,
                      ),

              label: Text(
                isGettingLocation
                    ? 'Getting Location...'
                    : 'Use Current Location',

                style: TextStyle(
                  color: AppColors.primary,

                  fontSize: 13.sp,

                  fontWeight: FontWeight.w600,
                ),
              ),

              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),

                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.r),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // NOTES
          AppTextField(
            controller: widget.controllers.notesController,

            label: 'Notes',

            hint: 'Enter notes',
          ),

          SizedBox(height: 20.h),

          // DOCUMENTS
          BusinessDocumentSection(
            business: widget.business,

            selectedDocuments: selectedDocuments,

            onUploadTap: () {
              _showDocumentOptions(context);
            },

            onRemoveDocument: _removeSelectedDocument,
          ),
        ],
      ),
    );
  }

  // HEADER
 

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 38.w,
          height: 38.w,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),

            shape: BoxShape.circle,
          ),

          child: Icon(
            Icons.store_outlined,

            color: AppColors.primary,

            size: 20.sp,
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Text(
            'Business ${widget.index + 1}',

            style: TextStyle(
              fontSize: 15.sp,

              fontWeight: FontWeight.w700,

              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
