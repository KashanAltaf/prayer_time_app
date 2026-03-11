import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_time_app/model/prayer_model.dart';
import 'package:prayer_time_app/repository/prayer_repository.dart';
import 'package:prayer_time_app/controller/location_controller.dart';
import 'package:prayer_time_app/controller/settings_controller.dart';

class PrayerController extends GetxController {
  final _repo = PrayerRepository();
  final _locationController = Get.find<LocationController>();
  
  SettingsController? get _settingsController {
    try {
      return Get.find<SettingsController>();
    } catch (e) {
      return null;
    }
  }

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
    
    // Listen for settings changes and refresh prayer times
    if (_settingsController != null) {
      ever(_settingsController!.selectedMethod, (_) {
        if (_locationController.latitude.value != 0.0 &&
            _locationController.longitude.value != 0.0) {
          fetchPrayerTimes();
        }
      });
      
      ever(_settingsController!.selectedSchool, (_) {
        if (_locationController.latitude.value != 0.0 &&
            _locationController.longitude.value != 0.0) {
          fetchPrayerTimes();
        }
      });
      
      // Listen for GPS toggle changes
      ever(_settingsController!.useGpsLocation, (_) {
        // Location will be updated by LocationController, which will trigger prayer fetch
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_locationController.latitude.value != 0.0 &&
              _locationController.longitude.value != 0.0) {
            fetchPrayerTimes();
          }
        });
      });
      
      // Listen for city selection changes
      ever(_settingsController!.selectedCity, (_) {
        if (!_settingsController!.useGpsLocation.value &&
            _settingsController!.selectedCity.value != null) {
          // Location will be updated by LocationController, which will trigger prayer fetch
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_locationController.latitude.value != 0.0 &&
                _locationController.longitude.value != 0.0) {
              fetchPrayerTimes();
            }
          });
        }
      });
    }
    
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

  Future<void> fetchPrayerTimes({int? method, int? school}) async {
    // Don't fetch if already loading
    if (isLoading.value) {
      if (kDebugMode) {
        print('PrayerController: Already loading, skipping fetch');
      }
      return;
    }
    
    // Get method and school from settings if not provided
    final prayerMethod = method ?? _settingsController?.selectedMethod.value ?? 3;
    final prayerSchool = school ?? _settingsController?.selectedSchool.value ?? 1;
    
    // Check if using GPS or manual location
    final useGps = _settingsController?.useGpsLocation.value ?? true;
    
    if (useGps) {
      // Check and get location if needed (GPS mode)
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
    } else {
      // Manual location mode - check if city is selected
      if (_settingsController?.selectedCity.value == null) {
        errorMessage.value = 'Please select a city from settings';
        isLoading.value = false;
        return;
      }
      
      // Update location controller with selected city
      final city = _settingsController!.selectedCity.value!;
      _locationController.latitude.value = city.latitude;
      _locationController.longitude.value = city.longitude;
      _locationController.locationName.value = city.displayName;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (kDebugMode) {
        print('PrayerController: Fetching prayer times for lat: ${_locationController.latitude.value}, lon: ${_locationController.longitude.value}, method: $prayerMethod, school: $prayerSchool');
      }

      final response = await _repo.fetchPrayerDataApi(
        lat: _locationController.latitude.value,
        lon: _locationController.longitude.value,
        method: prayerMethod,
        school: prayerSchool,
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
