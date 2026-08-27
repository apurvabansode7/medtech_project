import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:medtech_project/constant/app_colors.dart';

import 'package:medtech_project/core/app_theme.dart';
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
import 'package:medtech_project/features/interested_product/data/api/interested_product_api.dart';
import 'package:medtech_project/features/interested_product/data/repositories/interested_product_repository_impl.dart';
import 'package:medtech_project/features/interested_product/presentation/bloc/interested_product_bloc.dart';
import 'package:medtech_project/features/product/data/api/showcase_product_api.dart';
import 'package:medtech_project/features/product/data/repositories/showcase_product_repository_impl.dart';
import 'package:medtech_project/features/product/presentation/bloc/product_interest_bloc.dart';
import 'package:medtech_project/features/product/presentation/bloc/showcase_product_bloc.dart';
import 'package:medtech_project/features/profile/data/api/profile_api.dart';
import 'package:medtech_project/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile.bloc.dart';
import 'package:medtech_project/features/profile/presentation/bloc/profile_event.dart';
import 'package:medtech_project/features/scan_history/data/api/scan_history_api.dart';
import 'package:medtech_project/features/scan_history/data/repositories/scan_history_repository_impl.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_bloc.dart';
import 'package:medtech_project/features/scan_history/presentation/bloc/scan_history_event.dart';
import 'package:medtech_project/features/scanner/data/api/product_scan_api.dart';
import 'package:medtech_project/features/scanner/data/repositories/product_scan_repository_impl.dart';
import 'package:medtech_project/features/scanner/presentation/bloc/product_scan_bloc.dart';
import 'package:medtech_project/features/wallet/data/api/wallet_api.dart';
import 'package:medtech_project/features/wallet/data/repositories/wallet_repositories_impl.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_bloc.dart';
import 'package:medtech_project/features/wallet/presenation/bloc/wallet_event.dart';
import 'package:medtech_project/utils/app_snack_bar.dart';

import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  runApp(const MedTechApp());
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
        scaffoldMessengerKey.currentState
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('No Internet Connection'),
              backgroundColor: AppColors.error,
              duration: Duration(seconds: 3),
            ),
          );
      }

      if (status == InternetStatus.connected &&
          _previousStatus == InternetStatus.disconnected) {
        scaffoldMessengerKey.currentState
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Internet Reconnected'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 3),
            ),
          );
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
    final productScanApi = ProductScanApi(apiService: apiService);

    final productScanRepository = ProductScanRepositoryImpl(
      productScanApi: productScanApi,
    );

    final walletApi = WalletApi(apiService: apiService);

    final walletRepository = WalletRepositoryImpl(walletApi: walletApi);
    final scanHistoryApi = ScanHistoryApi(apiService: apiService);

    final scanHistoryRepository = ScanHistoryRepositoryImpl(
      scanHistoryApi: scanHistoryApi,
    );
    final profileApi = ProfileApi(apiService: apiService);

    final profileRepository = ProfileRepositoryImpl(api: profileApi);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,

      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(authRepository: authRepository),
            ),

            BlocProvider<ForgotPasswordBloc>(
              create: (_) => ForgotPasswordBloc(authRepository: authRepository),
            ),

            BlocProvider<VerifyOtpBloc>(
              create: (_) => VerifyOtpBloc(authRepository: authRepository),
            ),

            BlocProvider<ResetBloc>(
              create: (_) => ResetBloc(authRepository: authRepository),
            ),
            BlocProvider<ProductScanBloc>(
              create: (_) => ProductScanBloc(repository: productScanRepository),
            ),

            BlocProvider<WalletBloc>(
              create:
                  (_) =>
                      WalletBloc(repository: walletRepository)
                        ..add(LoadWalletTransactions(page: 1, limit: 20)),
            ),
            BlocProvider<ScanHistoryBloc>(
              create:
                  (_) =>
                      ScanHistoryBloc(repository: scanHistoryRepository)
                        ..add(LoadScanHistory(page: 1, limit: 10)),
            ),
            BlocProvider<ShowcaseProductBloc>(
              create:
                  (_) => ShowcaseProductBloc(
                    repository: ShowcaseProductRepositoryImpl(
                      api: ShowcaseProductApi(apiService: apiService),
                    ),
                  ),
            ),

            BlocProvider<ProductInterestBloc>(
              create:
                  (_) => ProductInterestBloc(
                    repository: ShowcaseProductRepositoryImpl(
                      api: ShowcaseProductApi(apiService: apiService),
                    ),
                  ),
            ),
            BlocProvider<InterestedProductBloc>(
              create:
                  (context) => InterestedProductBloc(
                    repository: InterestedProductRepositoryImpl(
                      api: InterestedProductApi(apiService: apiService),
                    ),
                  ),
            ),
            BlocProvider<ProfileBloc>(
              create:
                  (_) =>
                      ProfileBloc(repository: profileRepository)
                        ..add(const LoadProfile()),
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

                home: const SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
