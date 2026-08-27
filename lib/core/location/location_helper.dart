import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> getCurrentLocation() async {
    // Check whether location service is enabled
    final bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      throw Exception(
        'Location services are disabled.',
      );
    }

    // Check permission
    LocationPermission permission =
        await Geolocator.checkPermission();

    // Request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Permission denied
    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission denied.',
      );
    }

    // Permission permanently denied
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      throw Exception(
        'Location permission permanently denied.',
      );
    }

    // Get current location
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}