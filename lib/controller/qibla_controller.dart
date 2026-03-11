import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:prayer_time_app/controller/location_controller.dart';

class QiblaController extends GetxController {
  final _locationController = Get.find<LocationController>();
  
  final RxDouble compassHeading = 0.0.obs;
  final RxDouble qiblaDirection = 0.0.obs;
  final RxDouble distanceToKaaba = 0.0.obs; // in kilometers
  final RxBool hasCompass = false.obs;
  final RxString errorMessage = ''.obs;
  
  StreamSubscription<CompassEvent>? _compassSubscription;

  // Kaaba coordinates
  static const double kaabaLat = 21.4225;
  static const double kaabaLon = 39.8262;

  @override
  void onInit() {
    super.onInit();
    initializeCompass();
    calculateQiblaDirection();
    
    // Recalculate when location changes
    ever(_locationController.latitude, (_) => calculateQiblaDirection());
    ever(_locationController.longitude, (_) => calculateQiblaDirection());
  }

  Future<void> initializeCompass() async {
    try {
      if (FlutterCompass.events == null) {
        errorMessage.value = 'Compass not available on this device';
        hasCompass.value = false;
        return;
      }

      hasCompass.value = true;
      
      _compassSubscription = FlutterCompass.events!.listen((event) {
        if (event.heading != null) {
          compassHeading.value = event.heading!;
        }
      });
    } catch (e) {
      errorMessage.value = 'Error initializing compass: $e';
      hasCompass.value = false;
    }
  }

  void calculateQiblaDirection() {
    if (_locationController.latitude.value == 0.0 ||
        _locationController.longitude.value == 0.0) {
      return;
    }

    try {
      double lat = _locationController.latitude.value;
      double lon = _locationController.longitude.value;
      
      // Convert to radians
      double lat1 = math.pi * lat / 180.0;
      double lat2 = math.pi * kaabaLat / 180.0;
      double deltaLon = math.pi * (kaabaLon - lon) / 180.0;
      
      // Calculate bearing using the formula
      double y = math.sin(deltaLon) * math.cos(lat2);
      double x = math.cos(lat1) * math.sin(lat2) - 
                 math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);
      
      double bearing = math.atan2(y, x);
      bearing = bearing * 180.0 / math.pi;
      bearing = (bearing + 360.0) % 360.0;
      
      qiblaDirection.value = bearing;
      
      // Calculate distance to Kaaba using Haversine formula
      double dLat = lat2 - lat1;
      double dLon = deltaLon;
      double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
          math.cos(lat1) * math.cos(lat2) *
          math.sin(dLon / 2) * math.sin(dLon / 2);
      double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      double distance = 6371 * c; // Earth radius in km
      
      distanceToKaaba.value = distance;
    } catch (e) {
      errorMessage.value = 'Error calculating Qibla direction: $e';
    }
  }

  double get qiblaAngle {
    if (!hasCompass.value) return 0.0;
    // Calculate the angle difference between compass heading and Qibla direction
    double angle = qiblaDirection.value - compassHeading.value;
    // Normalize to -180 to 180
    while (angle > 180) angle -= 360;
    while (angle < -180) angle += 360;
    return angle;
  }

  @override
  void onClose() {
    _compassSubscription?.cancel();
    super.onClose();
  }
}

