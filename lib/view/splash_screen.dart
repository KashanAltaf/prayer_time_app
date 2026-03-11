import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:prayer_time_app/res/routes/routes_name.dart';
import 'package:prayer_time_app/controller/location_controller.dart';
import 'package:prayer_time_app/controller/prayer_controller.dart';
import 'package:prayer_time_app/controller/qibla_controller.dart';
import 'package:prayer_time_app/controller/navigation_controller.dart';
import 'package:prayer_time_app/controller/prayer_timer_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    Get.put(LocationController());
    Get.put(PrayerController());
    Get.put(PrayerTimerController());
    Get.put(QiblaController());
    Get.put(NavigationController());

    // Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(RoutesName.mainScreen);
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E3A8A),
              const Color(0xFF1E40AF),
              const Color(0xFF1E3A8A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.mosque,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              
              // App Name
              Text(
                'Prayer Time',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Your Daily Prayer Companion',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 50),
              
              // Loading indicator
              SpinKitWaveSpinner(
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
