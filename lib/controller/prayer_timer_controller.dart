import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_time_app/controller/prayer_controller.dart';
import 'package:prayer_time_app/model/prayer_model.dart';

class PrayerTimerController extends GetxController {
  final _prayerController = Get.find<PrayerController>();
  
  final RxString timeRemaining = '00:00:00'.obs;
  final RxString nextPrayerName = 'Loading...'.obs;
  final RxString nextPrayerTime = ''.obs;
  final RxBool isInitialized = false.obs;
  
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    
    // Restart timer when prayer data changes
    ever(_prayerController.prayerData, (_) {
      if (_prayerController.prayerData.value != null) {
        startTimer();
      }
    });
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateCountdown();
    });
    updateCountdown();
  }

  void updateCountdown() {
    final prayerData = _prayerController.prayerData.value;
    if (prayerData?.data?.times == null) {
      timeRemaining.value = '00:00:00';
      nextPrayerName.value = 'Loading...';
      nextPrayerTime.value = '';
      isInitialized.value = false;
      return;
    }

    final times = prayerData!.data!.times!;
    final now = DateTime.now();
    
    // Parse all prayer times
    final fajr = _parseTime(times.fajr ?? '');
    final zuhr = _parseTime(times.dhuhr ?? '');
    final asr = _parseTime(times.asr ?? '');
    final maghrib = _parseTime(times.maghrib ?? '');
    final isha = _parseTime(times.isha ?? '');
    
    final currentTime = TimeOfDay.fromDateTime(now);
    
    // Find next prayer
    DateTime? nextPrayerDateTime;
    String? nextPrayer;
    String? nextPrayerTimeStr;
    
    // Create DateTime objects for today
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime fajrDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      fajr.hour,
      fajr.minute,
    );
    
    DateTime zuhrDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      zuhr.hour,
      zuhr.minute,
    );
    
    DateTime asrDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      asr.hour,
      asr.minute,
    );
    
    DateTime maghribDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      maghrib.hour,
      maghrib.minute,
    );
    
    DateTime ishaDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      isha.hour,
      isha.minute,
    );
    
    // If current time is after Isha, next prayer is Fajr tomorrow
    if (_isTimeAfter(currentTime, isha)) {
      nextPrayerDateTime = fajrDateTime.add(const Duration(days: 1));
      nextPrayer = 'Fajr';
      nextPrayerTimeStr = times.fajr ?? '';
    }
    // If before Fajr, next is Fajr today
    else if (_isTimeBefore(currentTime, fajr)) {
      nextPrayerDateTime = fajrDateTime;
      nextPrayer = 'Fajr';
      nextPrayerTimeStr = times.fajr ?? '';
    }
    // If between Fajr and Zuhr
    else if (_isTimeBefore(currentTime, zuhr)) {
      nextPrayerDateTime = zuhrDateTime;
      nextPrayer = 'Zuhr';
      nextPrayerTimeStr = times.dhuhr ?? '';
    }
    // If between Zuhr and Asr
    else if (_isTimeBefore(currentTime, asr)) {
      nextPrayerDateTime = asrDateTime;
      nextPrayer = 'Asr';
      nextPrayerTimeStr = times.asr ?? '';
    }
    // If between Asr and Maghrib
    else if (_isTimeBefore(currentTime, maghrib)) {
      nextPrayerDateTime = maghribDateTime;
      nextPrayer = 'Maghrib';
      nextPrayerTimeStr = times.maghrib ?? '';
    }
    // If between Maghrib and Isha
    else if (_isTimeBefore(currentTime, isha)) {
      nextPrayerDateTime = ishaDateTime;
      nextPrayer = 'Isha';
      nextPrayerTimeStr = times.isha ?? '';
    }
    
    if (nextPrayerDateTime != null && nextPrayer != null) {
      final difference = nextPrayerDateTime.difference(now);
      
      if (difference.isNegative) {
        // If we've passed the prayer time, recalculate
        startTimer();
        return;
      }
      
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);
      
      timeRemaining.value = 
          '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
      
      nextPrayerName.value = nextPrayer;
      nextPrayerTime.value = nextPrayerTimeStr ?? '';
      isInitialized.value = true;
    } else {
      timeRemaining.value = '00:00:00';
      nextPrayerName.value = 'Loading...';
      nextPrayerTime.value = '';
      isInitialized.value = false;
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final cleanTime = timeStr.trim().toUpperCase();
      final parts = cleanTime.split(':');
      
      if (parts.length >= 2) {
        var hour = int.parse(parts[0].trim());
        final minutePart = parts[1].trim().split(' ')[0];
        final minute = int.parse(minutePart);
        
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

