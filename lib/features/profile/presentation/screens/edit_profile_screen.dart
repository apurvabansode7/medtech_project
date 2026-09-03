import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:medtech_project/components/app_buttons.dart';
import 'package:medtech_project/components/apptextfield.dart';
import 'package:medtech_project/components/cached_network_image.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/profile/data/models/profile_response_model.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_event.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_state.dart';
import 'package:medtech_project/features/profile/presentation/widgets/business_card.dart';

// ============================================================
// BUSINESS CONTROLLERS
// ============================================================
class BusinessControllers {
  final Business? business;
  final String? businessId;

  late final TextEditingController outletNameController;
  late final TextEditingController usernameController;
  late final TextEditingController panController;
  late final TextEditingController drugLicenseController;
  late final TextEditingController drugLicenseExpiryController;
  late final TextEditingController addressTypeController;
  late final TextEditingController addressLine1Controller;
  late final TextEditingController addressLine2Controller;
  late final TextEditingController landmarkController;
  late final TextEditingController cityController;
  late final TextEditingController districtController;
  late final TextEditingController stateController;
  late final TextEditingController pincodeController;
  late final TextEditingController latitudeController;
  late final TextEditingController longitudeController;
  late final TextEditingController notesController;

  BusinessControllers(Business? business)
    : business = business,
      businessId = business?.id {
    outletNameController = TextEditingController(
      text: business?.outletName ?? '',
    );

    usernameController = TextEditingController(text: business?.userName ?? '');

    panController = TextEditingController(text: business?.panNumber ?? '');

    drugLicenseController = TextEditingController(
      text: business?.drugLicenseNumber ?? '',
    );

    drugLicenseExpiryController = TextEditingController(
      text:
          business?.drugLicenseExpiry != null
              ? _formatDate(business!.drugLicenseExpiry!)
              : '',
    );

    addressTypeController = TextEditingController(
      text: business?.addressType ?? 'SHOP',
    );

    addressLine1Controller = TextEditingController(
      text: business?.addressLine1 ?? '',
    );

    addressLine2Controller = TextEditingController(
      text: business?.addressLine2 ?? '',
    );

    landmarkController = TextEditingController(text: business?.landmark ?? '');

    cityController = TextEditingController(text: business?.city ?? '');

    districtController = TextEditingController(text: business?.district ?? '');

    stateController = TextEditingController(text: business?.state ?? '');

    pincodeController = TextEditingController(text: business?.pincode ?? '');

    latitudeController = TextEditingController(
      text: business?.latitude.toString() ?? '',
    );

    longitudeController = TextEditingController(
      text: business?.longitude.toString() ?? '',
    );

    notesController = TextEditingController(text: business?.notes ?? '');
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void dispose() {
    outletNameController.dispose();
    usernameController.dispose();
    panController.dispose();
    drugLicenseController.dispose();
    drugLicenseExpiryController.dispose();
    addressTypeController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    landmarkController.dispose();
    cityController.dispose();
    districtController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    notesController.dispose();
  }
}

// ============================================================
// EDIT PROFILE SCREEN
// ============================================================

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  final ProfileData profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

// ============================================================
// STATE
// ============================================================

class _EditProfileScreenState extends State<EditProfileScreen> {
  // late List<BusinessControllers> businessControllers = [];
  late final BusinessControllers businessController;
  final ImagePicker _imagePicker = ImagePicker();

  XFile? selectedProfileImage;

  bool isProfileImageRemoved = false;

  late final TextEditingController ownerNameController;
  late final TextEditingController businessNameController;
  late final TextEditingController gstNumberController;

  // ============================================================
  // INIT
  // ============================================================
  @override
  void initState() {
    super.initState();

    final ProfileData profile = widget.profile;

    ownerNameController = TextEditingController(text: profile.ownerName);

    businessNameController = TextEditingController(text: profile.businessName);

    gstNumberController = TextEditingController(text: profile.gstNumber);

    // Only ONE business
    businessController = BusinessControllers(
      profile.business.isNotEmpty ? profile.business.first : null,
    );
    //multiple business
    // businessControllers =
    //     profile.business
    //         .map((business) => BusinessControllers(business))
    //         .toList();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    ownerNameController.dispose();
    businessNameController.dispose();
    gstNumberController.dispose();

    businessController.dispose();
    // for (final controller in businessControllers) {
    //   controller.dispose();
    // }

    super.dispose();
  }

  // ============================================================
  // PROFILE IMAGE OPTIONS
  // ============================================================

  void _showProfileImageOptions(BuildContext context) {
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
                  'Profile Photo',
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
                  subtitle: const Text('Take a new profile photo'),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    await _pickProfileImage(ImageSource.camera);
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
                  subtitle: const Text('Choose a profile photo'),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    await _pickProfileImage(ImageSource.gallery);
                  },
                ),

                // REMOVE
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Remove your profile photo'),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);

                    _removeProfileImage();
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
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedProfileImage = image;
        isProfileImageRemoved = false;
      });
    } catch (e) {
      debugPrint('Profile image picker error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to select image: $e')));
    }
  }

  // ============================================================
  // REMOVE PROFILE IMAGE
  // ============================================================

  void _removeProfileImage() {
    setState(() {
      selectedProfileImage = null;
      isProfileImageRemoved = true;
    });
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================
  void _updateProfile() {
    final BusinessControllers controller = businessController;

    final Map<String, dynamic> businessData = {
      // Existing business -> send ID
      // New business -> don't send ID
      if (controller.businessId != null && controller.businessId!.isNotEmpty)
        'businessId': controller.businessId,

      'outletName': controller.outletNameController.text.trim(),

      'userName': controller.usernameController.text.trim(),

      'panNumber': controller.panController.text.trim(),

      'drugLicenseNumber': controller.drugLicenseController.text.trim(),

      'drugLicenseExpiry': controller.drugLicenseExpiryController.text.trim(),

      'addressType': controller.addressTypeController.text.trim(),

      'addressLine1': controller.addressLine1Controller.text.trim(),

      'addressLine2': controller.addressLine2Controller.text.trim(),

      'landmark': controller.landmarkController.text.trim(),

      'city': controller.cityController.text.trim(),

      'district': controller.districtController.text.trim(),

      'state': controller.stateController.text.trim(),

      'pincode': controller.pincodeController.text.trim(),

      'latitude': double.tryParse(controller.latitudeController.text.trim()),

      'longitude': double.tryParse(controller.longitudeController.text.trim()),

      'notes': controller.notesController.text.trim(),

      'documents': _getExistingDocuments(controller.business),
    };

    final Map<String, dynamic> data = {
      'businessName': businessNameController.text.trim(),

      'ownerName': ownerNameController.text.trim(),

      'gstNumber': gstNumberController.text.trim(),

      // Only ONE business
      'businesses': [businessData],
    };

    debugPrint('UPDATE PROFILE REQUEST');
    debugPrint(data.toString());

    context.read<ProfileBloc>().add(UpdateProfile(data: data));
  }
  //for the multiple business

  //    void _updateProfile() {
  //   final List<Map<String, dynamic>> businesses =
  //       businessControllers.map((controller) {
  //     return {
  //       if (controller.businessId != null &&
  //           controller.businessId!.isNotEmpty)
  //         'businessId': controller.businessId,

  //       'outletName': controller.outletNameController.text.trim(),
  //       'userName': controller.usernameController.text.trim(),
  //       'panNumber': controller.panController.text.trim(),
  //       'drugLicenseNumber':
  //           controller.drugLicenseController.text.trim(),
  //       'drugLicenseExpiry':
  //           controller.drugLicenseExpiryController.text.trim(),
  //       'addressType': controller.addressTypeController.text.trim(),
  //       'addressLine1': controller.addressLine1Controller.text.trim(),
  //       'addressLine2': controller.addressLine2Controller.text.trim(),
  //       'landmark': controller.landmarkController.text.trim(),
  //       'city': controller.cityController.text.trim(),
  //       'district': controller.districtController.text.trim(),
  //       'state': controller.stateController.text.trim(),
  //       'pincode': controller.pincodeController.text.trim(),
  //       'latitude': double.tryParse(
  //         controller.latitudeController.text.trim(),
  //       ),
  //       'longitude': double.tryParse(
  //         controller.longitudeController.text.trim(),
  //       ),
  //       'notes': controller.notesController.text.trim(),
  //       'documents': _getExistingDocuments(controller.business),
  //     };
  //   }).toList();

  //   final Map<String, dynamic> data = {
  //     'businessName': businessNameController.text.trim(),
  //     'ownerName': ownerNameController.text.trim(),
  //     'gstNumber': gstNumberController.text.trim(),
  //     'businesses': businesses,
  //   };

  //   debugPrint('UPDATE PROFILE REQUEST');
  //   debugPrint(data.toString());

  //   context.read<ProfileBloc>().add(
  //     UpdateProfile(data: data),
  //   );
  // }
  // ============================================================
  // EXISTING DOCUMENTS
  // ============================================================

  List<dynamic> _getExistingDocuments(Business? business) {
    return business?.documents ?? [];
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ProfileData profile = widget.profile;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );

          Navigator.of(context).pop(true);
        }

        if (state is ProfileUpdateFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      builder: (context, state) {
        final bool isUpdating = state is ProfileUpdateLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),

          appBar: AppBar(
            backgroundColor: AppColors.primary,
            surfaceTintColor: AppColors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.white),

            title: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 18.h,
                bottom: 30.h,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // PROFILE IMAGE

                  _buildProfileImage(profile),

                  SizedBox(height: 28.h),

                  // PARTNER INFORMATION
                  _buildSectionTitle(title: 'Partner Information'),

                  SizedBox(height: 10.h),

                  _buildPartnerCard(),

                  SizedBox(height: 24.h),

                  // BUSINESS DETAILS
                  _buildSectionTitle(title: 'Business Details'),

                  SizedBox(height: 10.h),

                  BusinessCard(
                    business:
                        profile.business.isNotEmpty
                            ? profile.business.first
                            : null,
                    controllers: businessController,
                    index: 0,
                  ),
                  // Column(
                  //   children:
                  //       profile.business.asMap().entries.map((entry) {
                  //         final int index = entry.key;
                  //         final Business business = entry.value;

                  //         return Padding(
                  //           padding: EdgeInsets.only(bottom: 16.h),
                  //           child: BusinessCard(
                  //             business: business,
                  //             controllers: businessControllers[index],
                  //             index: index,
                  //           ),
                  //         );
                  //       }).toList(),
                  // ),
                  SizedBox(height: 10.h),

                  // UPDATE BUTTON
                  _buildSaveButton(isUpdating: isUpdating),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // PROFILE IMAGE

  Widget _buildProfileImage(ProfileData profile) {
    final String ownerName = profile.ownerName.trim();

    final String imageUrl = profile.profileImage ?? '';

    return Center(
      child: Stack(
        clipBehavior: Clip.none,

        children: [
          Container(
            width: 100.w,
            height: 100.w,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(color: AppColors.primary, width: 2),
            ),

            child: ClipOval(
              child:
                  isProfileImageRemoved
                      ? _buildInitialWidget(ownerName)
                      : selectedProfileImage != null
                      ? Image.file(
                        File(selectedProfileImage!.path),
                        width: 100.w,
                        height: 100.w,
                        fit: BoxFit.cover,
                      )
                      : CachedImage(
                        imageUrl: imageUrl,
                        width: 100.w,
                        height: 100.w,
                        fit: BoxFit.cover,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.08,
                        ),
                        initial: ownerName,
                        placeholder: _buildInitialWidget(ownerName),
                        errorWidget: _buildInitialWidget(ownerName),
                      ),
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,

            child: GestureDetector(
              onTap: () {
                _showProfileImageOptions(context);
              },

              child: Container(
                width: 34.w,
                height: 34.w,

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,

                  border: Border.all(color: Colors.white, width: 2),
                ),

                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 17.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INITIAL
  // ============================================================

  Widget _buildInitialWidget(String name) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),

      alignment: Alignment.center,

      child: Text(
        _getInitial(name),

        style: TextStyle(
          color: AppColors.primary,
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitial(String name) {
    final String trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName.substring(0, 1).toUpperCase();
  }

  // PARTNER CARD

  Widget _buildPartnerCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          AppTextField(
            controller: ownerNameController,
            label: 'Owner Name',
            hint: 'Enter owner name',
          ),

          SizedBox(height: 16.h),

          AppTextField(
            controller: businessNameController,
            label: 'Business Name',
            hint: 'Enter business name',
          ),

          SizedBox(height: 16.h),

          AppTextField(
            controller: gstNumberController,
            label: 'GST Number',
            hint: 'Enter GST number',
          ),
        ],
      ),
    );
  }

  // SAVE BUTTON

  Widget _buildSaveButton({required bool isUpdating}) {
    return SizedBox(
      width: double.infinity,

      child: AppButton(
        title: isUpdating ? 'Updating...' : 'Update',

        onPressed: isUpdating ? null : _updateProfile,
      ),
    );
  }

  // SECTION TITLE

  Widget _buildSectionTitle({required String title}) {
    return Text(
      title,

      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  // CARD

  Widget _buildCard({required Widget child}) {
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

      child: child,
    );
  }
}
