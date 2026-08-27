import 'package:dio/dio.dart';
import 'package:medtech_project/constant/api_constants.dart';
import 'package:medtech_project/core/network/internet_checker.dart';
import 'package:medtech_project/utils/app_prefrences.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _setupInterceptors();
  }

  // void _setupInterceptors() {
  //   dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) async {
  //         // Attach access token to all requests
  //         final token = await AppPreferences.getAccessToken();
  //         if (token != null && token.isNotEmpty) {
  //           options.headers['Authorization'] = 'Bearer $token';
  //         }
  //         return handler.next(options);
  //       },
  //       onError: (error, handler) async {
  //         // Handle 401 Unauthorized - token might be expired
  //         if (error.response?.statusCode == 401) {
  //           // Could implement token refresh here
  //           await AppPreferences.logout();
  //         }
  //         return handler.next(error);
  //       },
  //     ),
  //   );
  // }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AppPreferences.getAccessToken();

          print('METHOD: ${options.method}');
          print('URL: ${options.uri}');
          print('TOKEN EXISTS: ${token != null && token.isNotEmpty}');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';

            print(
              'Token: ${token.length > 15 ? '${token.substring(0, 15)}...' : token}',
            );
          } else {
            print('WARNING: ACCESS TOKEN IS NULL/EMPTY');
          }

          print('Headers: ${options.headers}');

          return handler.next(options);
        },

        onResponse: (response, handler) {
          print('URL: ${response.requestOptions.uri}');
          print('STATUS: ${response.statusCode}');
          print('DATA: ${response.data}');

          return handler.next(response);
        },

        onError: (error, handler) async {
          print('URL: ${error.requestOptions.uri}');
          print('STATUS: ${error.response?.statusCode}');
          print('DATA: ${error.response?.data}');
          print('MESSAGE: ${error.message}');

          if (error.response?.statusCode == 401) {
            await AppPreferences.logout();
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _checkInternet() async {
    final connected = await InternetChecker.instance.isConnected;
    if (!connected) {
      throw Exception('No internet connection');
    }
  }

  Future<Response> get(
    String endpoint, {
    required Map<String, int> queryParameters,
  }) async {
    await _checkInternet();
    return await dio.get(endpoint, queryParameters: queryParameters);
  }

  // Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
  //   await _checkInternet();
  //   return await dio.post(endpoint, data: data);
  // }
  Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    await _checkInternet();

    return await dio.post(endpoint, data: data, options: options);
  }

  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    await _checkInternet();
    return await dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    await _checkInternet();
    return await dio.delete(endpoint);
  }
}
