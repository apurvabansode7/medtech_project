import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


import 'package:medtech_project/core/app_theme.dart';
import 'package:medtech_project/core/navigation/app_navigator.dart';
import 'package:medtech_project/core/network/internet_checker.dart';
import 'package:medtech_project/core/services/api_services.dart';
import 'package:medtech_project/core/theme/theme_cubit.dart';

import 'package:medtech_project/features/auth/data/api/auth_api.dart';
import 'package:medtech_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medtech_project/features/auth/presentation/bloc/forgot_password_bloc/forgot_password_bloc.dart';

// Login
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/reset_password_bloc/reset_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/verify_otp_bloc/verify_bloc.dart';
import 'package:medtech_project/features/home/data/api/campaign_api.dart';
import 'package:medtech_project/features/home/data/repositories/campaign_repository_impl.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';



import 'package:medtech_project/features/product/data/api/showcase_product_api.dart';
import 'package:medtech_project/features/product/data/repositories/showcase_product_repository_impl.dart';
import 'package:medtech_project/features/product/domain/repositories/showcase_product_repository.dart';
import 'package:medtech_project/features/profile/data/api/profile_api.dart';
import 'package:medtech_project/features/profile/data/repositories/profile_repository_impl.dart';

import 'package:medtech_project/features/rewards/data/api/reward_api.dart';
import 'package:medtech_project/features/rewards/data/repositories/reward_repository_impl.dart';


import 'package:medtech_project/features/scan_history/data/api/scan_history_api.dart';
import 'package:medtech_project/features/scan_history/data/repositories/scan_history_repository_impl.dart';
import 'package:medtech_project/features/scan_history/domain/repositories/scan_history_repository.dart';
import 'package:medtech_project/features/scanner/data/api/product_scan_api.dart';
import 'package:medtech_project/features/scanner/data/repositories/product_scan_repository_impl.dart';
import 'package:medtech_project/features/scanner/domain/repositories/product_scan_repository.dart';

import 'package:medtech_project/features/wallet/data/api/wallet_api.dart';
import 'package:medtech_project/features/wallet/data/repositories/wallet_repositories_impl.dart';
import 'package:medtech_project/features/wallet/domain/repositories/wallet_repositories.dart';

import 'package:medtech_project/utils/app_snack_bar.dart';

import 'features/splash/screens/splash_screen.dart';

import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:medtech_project/features/interested_product/data/api/interested_product_api.dart';
import 'package:medtech_project/features/interested_product/data/repositories/interested_product_repository_impl.dart';
import 'package:medtech_project/features/interested_product/domain/repositories/interested_product_repository.dart';
import 'package:medtech_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:medtech_project/features/rewards/domain/repositories/reward_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  runApp(
    //DevicePreview(enabled: true, builder: (context) =>
     const MedTechApp()
     //),
  );
}

class InternetStatusListener extends StatefulWidget {
  final Widget child;

  const InternetStatusListener({super.key, required this.child});

  @override
  State<InternetStatusListener> createState() => _InternetStatusListenerState();
}

class _InternetStatusListenerState extends State<InternetStatusListener> {
  StreamSubscription<InternetStatus>? _subscription;

  InternetStatus? _previousStatus;

  @override
  void initState() {
    super.initState();

    _subscription = InternetChecker.instance.statusStream.listen((status) {
      if (!mounted) return;

      if (status == InternetStatus.disconnected) {
        AppSnackbar.error("No internet connection");
      }

      if (status == InternetStatus.connected &&
          _previousStatus == InternetStatus.disconnected) {
        AppSnackbar.success("Internet Reconnected");
      }

      _previousStatus = status;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MedTechApp extends StatelessWidget {
  const MedTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CREATE SHARED API DEPENDENCIES ONCE
    final apiService = ApiService();

    final authApi = AuthApi(apiService: apiService);
    final authRepository = AuthRepositoryImpl(authApi: authApi);

    final campaignApi = CampaignApi(apiService: apiService);
    final campaignRepository = CampaignRepositoryImpl(api: campaignApi);

    final walletApi = WalletApi(apiService: apiService);
    final walletRepository = WalletRepositoryImpl(walletApi: walletApi);

    final scanHistoryApi = ScanHistoryApi(apiService: apiService);
    final scanHistoryRepository = ScanHistoryRepositoryImpl(
      scanHistoryApi: scanHistoryApi,
    );

    final profileApi = ProfileApi(apiService: apiService);
    final profileRepository = ProfileRepositoryImpl(api: profileApi);

    final showcaseProductApi = ShowcaseProductApi(apiService: apiService);
    final showcaseProductRepository = ShowcaseProductRepositoryImpl(
      api: showcaseProductApi,
    );

    final productScanApi = ProductScanApi(apiService: apiService);
    final productScanRepository = ProductScanRepositoryImpl(
      productScanApi: productScanApi,
    );

    final rewardApi = RewardApi(apiService: apiService);
    final rewardRepository = RewardRepositoryImpl(rewardApi: rewardApi);

    final interestedProductApi = InterestedProductApi(apiService: apiService);
    final interestedProductRepository = InterestedProductRepositoryImpl(
      api: interestedProductApi,
    );

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,

      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>.value(value: authRepository),
            RepositoryProvider<ProfileRepository>.value(value: profileRepository),
            RepositoryProvider<CampaignRepository>.value(value: campaignRepository),
            RepositoryProvider<WalletRepository>.value(value: walletRepository),
            RepositoryProvider<ScanHistoryRepository>.value(value: scanHistoryRepository),
            RepositoryProvider<ShowcaseProductRepository>.value(value: showcaseProductRepository),
            RepositoryProvider<ProductScanRepository>.value(value: productScanRepository),
            RepositoryProvider<RewardRepository>.value(value: rewardRepository),
            RepositoryProvider<InterestedProductRepository>.value(value: interestedProductRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create:
                    (_) => AuthBloc(authRepository: authRepository),
              ),

              BlocProvider<ForgotPasswordBloc>(
                create:
                    (_) => ForgotPasswordBloc(
                      authRepository: authRepository,
                    ),
              ),

              BlocProvider<VerifyOtpBloc>(
                create:
                    (_) =>
                        VerifyOtpBloc(authRepository: authRepository),
              ),

              BlocProvider<ResetBloc>(
                create:
                    (_) => ResetBloc(authRepository: authRepository),
              ),

              BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
            ],

            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MedTech',

                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,

                  scaffoldMessengerKey: scaffoldMessengerKey,

                  builder: (context, widget) {
                    final mediaQuery = MediaQuery.of(context);

                    return MediaQuery(
                      data: mediaQuery.copyWith(
                        textScaler: mediaQuery.textScaler.clamp(
                          minScaleFactor: 0.8,
                          maxScaleFactor: 1.2,
                        ),
                      ),
                      child: InternetStatusListener(
                        child: widget ?? const SizedBox(),
                      ),
                    );
                  },
                  navigatorKey: navigatorKey,
                  home: const SplashScreen(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
