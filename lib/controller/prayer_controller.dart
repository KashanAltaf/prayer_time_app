import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_time_app/model/prayer_model.dart';
import 'package:prayer_time_app/repository/prayer_repository.dart';
import 'package:prayer_time_app/controller/location_controller.dart';

class PrayerController extends GetxController {
  final _repo = PrayerRepository();
  final _locationController = Get.find<LocationController>();

  final Rx<PrayerModel?> prayerData = Rx<PrayerModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for location changes and fetch prayer times when location is available
    ever(_locationController.latitude, (_) {
      if (_locationController.latitude.value != 0.0 &&
          _locationController.longitude.value != 0.0 &&
          _locationController.hasPermission.value &&
          !_locationController.isLoading.value) {
        fetchPrayerTimes();
      }
    });
    
    ever(_locationController.hasPermission, (_) {
      if (_locationController.hasPermission.value &&
          _locationController.latitude.value != 0.0 &&
          _locationController.longitude.value != 0.0) {
        fetchPrayerTimes();
      }
    });
    
    // Initial fetch attempt
    _tryFetchPrayerTimes();
  }

  Future<void> _tryFetchPrayerTimes() async {
    // Wait a bit for location to be ready
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_locationController.latitude.value != 0.0 &&
        _locationController.longitude.value != 0.0 &&
        _locationController.hasPermission.value) {
      fetchPrayerTimes();
    } else if (!_locationController.hasPermission.value &&
               !_locationController.isLoading.value) {
      // Location permission not granted, try to get it
      await _locationController.checkLocationPermission();
    }
  }

  Future<void> fetchPrayerTimes({int method = 3, int school = 1}) async {
    // Don't fetch if already loading
    if (isLoading.value) {
      if (kDebugMode) {
        print('PrayerController: Already loading, skipping fetch');
      }
      return;
    }
    
    // Check and get location if needed
    if (_locationController.latitude.value == 0.0 ||
        _locationController.longitude.value == 0.0) {
      if (kDebugMode) {
        print('PrayerController: Location not available, requesting...');
      }
      
      if (!_locationController.hasPermission.value) {
        await _locationController.checkLocationPermission();
      }
      if (_locationController.hasPermission.value) {
        await _locationController.getCurrentLocation();
      }
      
      // If still no location, return
      if (_locationController.latitude.value == 0.0 ||
          _locationController.longitude.value == 0.0) {
        if (kDebugMode) {
          print('PrayerController: Location still not available after request');
        }
        return;
      }
    }

    if (!_locationController.hasPermission.value) {
      errorMessage.value = 'Location permission required';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (kDebugMode) {
        print('PrayerController: Fetching prayer times for lat: ${_locationController.latitude.value}, lon: ${_locationController.longitude.value}');
      }

      final response = await _repo.fetchPrayerDataApi(
        lat: _locationController.latitude.value,
        lon: _locationController.longitude.value,
        method: method,
        school: school,
      );

      prayerData.value = response;
      isLoading.value = false;
      
      if (kDebugMode) {
        print('PrayerController: Successfully fetched prayer times');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to fetch prayer times: $e';
      if (kDebugMode) {
        print('PrayerController: Error fetching prayer times: $e');
      }
    }
  }

  String getCurrentPrayerName() {
    if (prayerData.value?.data?.times == null) return 'Zuhr';
    
    final now = DateTime.now();
    final times = prayerData.value!.data!.times!;
    
    // Parse prayer times
    final fajr = _parseTime(times.fajr ?? '');
    final dhuhr = _parseTime(times.dhuhr ?? '');
    final asr = _parseTime(times.asr ?? '');
    final maghrib = _parseTime(times.maghrib ?? '');
    final isha = _parseTime(times.isha ?? '');
    
    final currentTime = TimeOfDay.fromDateTime(now);
    
    // Determine current prayer based on time
    // If before Fajr or after Isha, next prayer is Fajr
    if (_isTimeBefore(currentTime, fajr) || 
        _isTimeAfter(currentTime, isha)) {
      return 'Fajr';
    } else if (_isTimeBefore(currentTime, dhuhr)) {
      return 'Fajr';
    } else if (_isTimeBefore(currentTime, asr)) {
      return 'Zuhr';
    } else if (_isTimeBefore(currentTime, maghrib)) {
      return 'Asr';
    } else if (_isTimeBefore(currentTime, isha)) {
      return 'Maghrib';
    } else {
      return 'Isha';
    }
  }

  String getCurrentPrayerTime() {
    if (prayerData.value?.data?.times == null) return '';
    
    final prayerName = getCurrentPrayerName();
    final times = prayerData.value!.data!.times!;
    
    switch (prayerName) {
      case 'Fajr':
        return times.fajr ?? '';
      case 'Zuhr':
      case 'Duhr':
        return times.dhuhr ?? '';
      case 'Asr':
        return times.asr ?? '';
      case 'Maghrib':
        return times.maghrib ?? '';
      case 'Isha':
        return times.isha ?? '';
      default:
        return times.dhuhr ?? '';
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      // Handle formats like "05:03 AM" or "05:03"
      final cleanTime = timeStr.trim().toUpperCase();
      final parts = cleanTime.split(':');
      
      if (parts.length >= 2) {
        var hour = int.parse(parts[0].trim());
        final minutePart = parts[1].trim().split(' ')[0];
        final minute = int.parse(minutePart);
        
        // Check for AM/PM
        if (cleanTime.contains('PM') && hour != 12) {
          hour += 12;
        } else if (cleanTime.contains('AM') && hour == 12) {
          hour = 0;
        }
        
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Handle error
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    final minutes1 = time1.hour * 60 + time1.minute;
    final minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 < minutes2;
  }

  bool _isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    final minutes1 = time1.hour * 60 + time1.minute;
    final minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 > minutes2;
  }
}
