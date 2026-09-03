import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medtech_project/constant/app_colors.dart';
import 'package:medtech_project/features/scanner/presentation/bloc/product_scan_bloc.dart';
import 'package:medtech_project/features/scanner/presentation/bloc/product_scan_event.dart';
import 'package:medtech_project/features/scanner/presentation/bloc/product_scan_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ProductScannerScreen extends StatefulWidget {
  const ProductScannerScreen({super.key});

  @override
  State<ProductScannerScreen> createState() => _ProductScannerScreenState();
}

class _ProductScannerScreenState extends State<ProductScannerScreen>
    with SingleTickerProviderStateMixin {
  // Scanner Controller

  final MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 500,
    torchEnabled: false,
  );

  late AnimationController _scanAnimationController;

  late Animation<double> _scanAnimation;

  // State

  bool _cameraPermissionGranted = false;

  bool _isCheckingPermission = true;

  bool _isScanned = false;

  String? _scannedCode;

  // Init State

  @override
  void initState() {
    super.initState();

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermission();
    });
  }

  // Camera Permission

  Future<void> _requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();

    if (!mounted) return;

    if (status.isGranted) {
      setState(() {
        _cameraPermissionGranted = true;
        _isCheckingPermission = false;
      });

      await _scannerController.start();

      return;
    }

    setState(() {
      _cameraPermissionGranted = false;
      _isCheckingPermission = false;
    });

    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Camera Permission Required'),
          content: const Text(
            'Camera permission was denied permanently. '
            'Please enable camera permission from '
            'the app settings to scan products.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final String? value = barcode.rawValue;

      if (value != null && value.trim().isNotEmpty) {
        if (!_isScanned) {
          _handleScannedCode(value.trim());
        }

        break;
      }
    }
  }

  Future<void> _closeScannerScreen() async {
    if (!mounted) return;

    await _scannerController.stop();

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  Future<void> _handleScannedCode(String value) async {
    if (_isScanned) {
      return;
    }

    setState(() {
      _isScanned = true;
      _scannedCode = value;
    });

    // Stop camera
    await _scannerController.stop();

    if (!mounted) return;

    // Show scanned result dialog
    _showScannedDialog();
  }

  void _showScannedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 65.w,
                  height: 65.w,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 45.sp,
                  ),
                ),

                SizedBox(height: 14.h),

                // Title
                Text(
                  'Code Scanned',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Product code detected successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 16.h),

                // Scanned code
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _scannedCode ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _startAnotherScan();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _useScannedCode();
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleFlash() async {
    await _scannerController.toggleTorch();
  }

  // void _useScannedCode() {
  //   if (_scannedCode == null || _scannedCode!.isEmpty) {
  //     return;
  //   }

  //   context.read<ProductScanBloc>().add(
  //     ProductScanSubmitted(
  //       code: _scannedCode!,
  //       latitude: 19.214294,
  //       longitude: 73.2053,
  //       deviceUuid: '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
  //       deviceInfo: 'iOS 18 / Safari 18',
  //       appVersion: '4.2.1',
  //     ),
  //   );
  // }

  Future<void> _useScannedCode() async {
    if (_scannedCode == null || _scannedCode!.isEmpty) {
      return;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please turn on location services.')),
        );

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required.')),
        );

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is permanently denied. Please enable it from settings.',
            ),
          ),
        );

        return;
      }

      // Get current live location
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      context.read<ProductScanBloc>().add(
        ProductScanSubmitted(
          code: _scannedCode!,
          latitude: position.latitude,
          longitude: position.longitude,
          deviceUuid: '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          deviceInfo: 'iOS 18 / Safari 18',
          appVersion: '4.2.1',
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to get current location: $e')),
      );
    }
  }

  void _showRewardDialog(ProductScanSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 65.w,
                  height: 65.w,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 45.sp,
                  ),
                ),

                SizedBox(height: 14.h),

                // Title
                Text(
                  'Product Scanned!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 8.h),

                // Message
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (state.productName != null &&
                    state.productName!.trim().isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Product',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          state.productName!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 16.h),

                // Reward Points
                if (state.isAwarded && state.rewardPoints != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Reward Points',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        SizedBox(height: 5.h),

                        Text(
                          '+${state.rewardPoints}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                // No Reward
                if (!state.isAwarded)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'No reward points awarded.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
                    ),
                  ),

                SizedBox(height: 20.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _startAnotherScan();
                        },
                        child: Text(
                          'Scan Another',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();

                          await _closeScannerScreen();
                        },
                        child: Text('Close', style: TextStyle(fontSize: 13.sp)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFailureDialog(ProductScanFailure state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon
                Container(
                  width: 65.w,
                  height: 65.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 45.sp,
                  ),
                ),

                SizedBox(height: 14.h),

                // Title
                Text(
                  'Product Verification Failed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 8.h),

                // API error message
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 20.h),

                // Scan Again
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    _startAnotherScan();
                  },
                  child: const Text('Scan Again'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startAnotherScan() async {
    if (!mounted) return;

    setState(() {
      _isScanned = false;
      _scannedCode = null;
    });

    // Make sure scanner is stopped before starting again
    await _scannerController.stop();

    if (!mounted) return;

    await _scannerController.start();
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();

    _scannerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (!_cameraPermissionGranted) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.white,
                  size: 55.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Camera access is required\nto scan products.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _requestCameraPermission,
                  child: const Text('Allow Camera'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Scanner

    return BlocConsumer<ProductScanBloc, ProductScanState>(
      listener: (context, state) {
        if (state is ProductScanSuccess) {
          _showRewardDialog(state);
        }

        if (state is ProductScanFailure) {
          _showFailureDialog(state);

          // Allow user to scan again
          setState(() {
            _isScanned = false;
            _scannedCode = null;
          });

          _scannerController.start();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            _buildScannerScreen(),

            if (state is ProductScanLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 28.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 42.w,
                            height: 42.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.primary,
                            ),
                          ),

                          SizedBox(height: 18.h),

                          Text(
                            'Verifying Product...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: 7.h),

                          Text(
                            'Please wait while we verify your product.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Scanner Screen

  Widget _buildScannerScreen() {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 0,

        toolbarHeight: 56.h,

        title: Text(
          'Product Scanner',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),

        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _scannerController,
            builder: (context, state, child) {
              final bool isTorchOn = state.torchState == TorchState.on;

              final bool isTorchUnavailable =
                  state.torchState == TorchState.unavailable;

              return IconButton(
                tooltip:
                    isTorchUnavailable
                        ? 'Flash unavailable'
                        : isTorchOn
                        ? 'Turn flash off'
                        : 'Turn flash on',

                onPressed:
                    isTorchUnavailable || _isScanned ? null : _toggleFlash,

                icon: Icon(
                  isTorchOn ? Icons.flash_on : Icons.flash_off,

                  size: 24.sp,

                  color:
                      isTorchUnavailable
                          ? AppColors.grey
                          : isTorchOn
                          ? Colors.amber
                          : AppColors.white,
                ),
              );
            },
          ),
        ],
      ),

      // Body
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;

          // Responsive scanner size
          final double frameWidth =
              screenWidth < 400
                  ? screenWidth * 0.78
                  : screenWidth < 600
                  ? screenWidth * 0.70
                  : screenWidth * 0.55;

          final double frameHeight = frameWidth * 0.68;

          return Stack(
            children: [
              // CAMERA
              Positioned.fill(
                child: MobileScanner(
                  controller: _scannerController,
                  onDetect: _onDetect,
                ),
              ),

              // DARK OVERLAY
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: AppColors.black.withValues(alpha: 0.18),
                  ),
                ),
              ),

              Positioned(
                top: 25.h,
                left: 20.w,
                right: 20.w,
                child: Text(
                  _isScanned
                      ? 'Product code detected'
                      : 'Scan QR code or barcode',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isScanned ? Colors.greenAccent : AppColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // BLUE SCANNER FRAME
              Center(
                child: _buildScannerFrame(
                  width: frameWidth,
                  height: frameHeight,
                ),
              ),

              // BOTTOM INSTRUCTION
              if (!_isScanned)
                Positioned(
                  left: 30.w,
                  right: 30.w,
                  bottom: 60.h,
                  child: Text(
                    'Position the QR code or barcode\n'
                    'inside the frame',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

              // FLASH STATUS
              Positioned(
                top: 58.h,
                left: 20.w,
                right: 20.w,
                child: ValueListenableBuilder<MobileScannerState>(
                  valueListenable: _scannerController,
                  builder: (context, state, child) {
                    if (state.torchState == TorchState.on && !_isScanned) {
                      return Text(
                        'Flash is ON',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // BLUE SCANNER FRAME

  Widget _buildScannerFrame({required double width, required double height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Transparent scanner area
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),

          // Top Left
          Positioned(
            top: 0,
            left: 0,
            child: _scannerCorner(top: true, left: true),
          ),

          // Top Right
          Positioned(
            top: 0,
            right: 0,
            child: _scannerCorner(top: true, left: false),
          ),

          // Bottom Left
          Positioned(
            bottom: 0,
            left: 0,
            child: _scannerCorner(top: false, left: true),
          ),

          // Bottom Right
          Positioned(
            bottom: 0,
            right: 0,
            child: _scannerCorner(top: false, left: false),
          ),

          // Animated Blue Scan Line
          if (!_isScanned)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Positioned(
                  left: 15.w,
                  right: 15.w,
                  top: height * _scanAnimation.value,
                  child: Container(
                    height: 2.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.transparent,
                          Color(0xFF2196F3),
                          Color(0xFF42A5F5),
                          AppColors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2196F3).withValues(alpha: 0.9),
                          blurRadius: 10.r,
                          spreadRadius: 2.r,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Scanner Corner

  Widget _scannerCorner({required bool top, required bool left}) {
    const Color blue = Color(0xFF2196F3);

    return SizedBox(
      width: 34.w,
      height: 34.h,
      child: Stack(
        children: [
          // Horizontal blue line
          Positioned(
            top: top ? 0 : null,
            bottom: top ? null : 0,
            left: left ? 0 : null,
            right: left ? null : 0,
            child: Container(
              width: 34.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),

          // Vertical blue line
          Positioned(
            top: top ? 0 : null,
            bottom: top ? null : 0,
            left: left ? 0 : null,
            right: left ? null : 0,
            child: Container(
              width: 4.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
