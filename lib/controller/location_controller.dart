import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxString locationName = 'Unknown'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          hasPermission.value = false;
          errorMessage.value = 'Location permission denied';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        hasPermission.value = false;
        errorMessage.value = 'Location permission permanently denied. Please enable it in settings.';
        return;
      }

      // Permission is granted
      hasPermission.value = true;
      
      // Get location if not already available
      if (latitude.value == 0.0 || longitude.value == 0.0) {
        await getCurrentLocation();
      }
    } catch (e) {
      errorMessage.value = 'Error checking location permission: $e';
      hasPermission.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    if (!hasPermission.value) {
      await checkLocationPermission();
      if (!hasPermission.value) return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Get location name
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String city = place.locality ?? '';
          String country = place.country ?? '';
          locationName.value = city.isNotEmpty && country.isNotEmpty
              ? '$city, $country'
              : country.isNotEmpty
                  ? country
                  : 'Unknown';
        }
      } catch (e) {
        locationName.value = 'Unknown';
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Error getting location: $e';
    }
  }
}

