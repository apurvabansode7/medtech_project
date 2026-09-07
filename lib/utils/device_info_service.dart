import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static const String _persistentDeviceIdKey = 'persistent_device_id';

  /// Dynamically fetches the app version from pubspec.yaml via PackageInfo
  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version.isNotEmpty) {
        return packageInfo.version;
      }
    } catch (e) {
      debugPrint('Error getting App Version from PackageInfo: $e');
    }
    return '1.0.0';
  }

  /// Dynamically fetches real native device hardware identifier using DeviceInfoPlugin
  static Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedId = prefs.getString(_persistentDeviceIdKey);

      if (savedId != null &&
          savedId.isNotEmpty &&
          savedId != 'unknown_device_id' &&
          !savedId.startsWith('device_')) {
        return savedId;
      }

      String deviceId = '';

      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        deviceId = 'web_${webInfo.vendor}_${webInfo.userAgent?.hashCode}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        debugPrint('Android ID: ${androidInfo.id}');
        debugPrint('Android Model: ${androidInfo.model}');
        debugPrint('Android Fingerprint: ${androidInfo.fingerprint}');

        if (androidInfo.id.isNotEmpty && androidInfo.id != 'unknown') {
          deviceId = androidInfo.id;
        } else if (androidInfo.fingerprint.isNotEmpty) {
          deviceId = androidInfo.fingerprint;
        } else if (androidInfo.model.isNotEmpty) {
          deviceId = '${androidInfo.manufacturer}_${androidInfo.model}';
        }
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? iosInfo.model;
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        deviceId = windowsInfo.deviceId;
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfoPlugin.macOsInfo;
        deviceId = macInfo.systemGUID ?? macInfo.model;
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        deviceId = linuxInfo.machineId ?? linuxInfo.name;
      }

      if (deviceId.isEmpty ||
          deviceId == 'unknown' ||
          deviceId == 'unknown_device_id') {
        deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      }

      await prefs.setString(_persistentDeviceIdKey, deviceId);
      return deviceId;
    } catch (e) {
      debugPrint('Error getting Device ID: $e');
      return 'device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
  static String getPlatform() {
  if (kIsWeb) {
    return 'web';
  } else if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'ios';
  } else if (Platform.isWindows) {
    return 'windows';
  } else if (Platform.isMacOS) {
    return 'macos';
  } else if (Platform.isLinux) {
    return 'linux';
  }

  return 'unknown';
}

  /// Helper to get both deviceId & appVersion dynamically
  static Future<Map<String, String>> getDeviceAndAppInfo() async {
    final deviceId = await getDeviceId();
    final appVersion = await getAppVersion();
     final platform = getPlatform();


    debugPrint(
      '[DeviceInfoService] Dynamic Device ID: $deviceId | App Version: $appVersion | Platform: $platform', 
    );

    return {
      'deviceId': deviceId,
      'appVersion': appVersion,
      'platform': platform,
    };
  }
}

