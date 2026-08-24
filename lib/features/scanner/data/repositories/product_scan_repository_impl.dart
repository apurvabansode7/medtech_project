

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medtech_project/features/scanner/data/api/product_scan_api.dart';
import 'package:medtech_project/features/scanner/domain/repositories/product_scan_repository.dart';

class ProductScanRepositoryImpl
    implements ProductScanRepository {
  final ProductScanApi productScanApi;

  ProductScanRepositoryImpl({
    required this.productScanApi,
  });

  @override
  Future<Map<String, dynamic>> scanProduct({
    required String code,
    required double latitude,
    required double longitude,
    required String deviceUuid,
    required String deviceInfo,
    required String appVersion,
  }) async {
    try {
      final response = await productScanApi.scanProduct(
        code: code,
        latitude: latitude,
        longitude: longitude,
        deviceUuid: deviceUuid,
        deviceInfo: deviceInfo,
        appVersion: appVersion,
      );

      debugPrint(
        'PRODUCT SCAN RESPONSE: ${response.data}',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        
        // Get "data" from API response
        final data = response.data['data'];

        debugPrint(
          'PRODUCT SCAN DATA: $data',
        );

        return Map<String, dynamic>.from(data);
      }

      throw Exception(
        response.data?['message'] ??
            'Product scan failed',
      );
    } on DioException catch (e) {
      debugPrint(
        'PRODUCT SCAN ERROR: ${e.response?.data}',
      );

      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
}