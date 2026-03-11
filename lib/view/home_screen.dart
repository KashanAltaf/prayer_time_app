import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prayer_time_app/controller/prayer_controller.dart';
import 'package:prayer_time_app/controller/location_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerController = Get.find<PrayerController>();
    final locationController = Get.find<LocationController>();

    // Request location on first load and trigger prayer fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!locationController.hasPermission.value &&
          locationController.latitude.value == 0.0 &&
          !locationController.isLoading.value) {
        locationController.checkLocationPermission().then((_) {
          if (locationController.hasPermission.value &&
              locationController.latitude.value != 0.0) {
            prayerController.fetchPrayerTimes();
          }
        });
      } else if (locationController.hasPermission.value &&
                 locationController.latitude.value != 0.0 &&
                 prayerController.prayerData.value == null &&
                 !prayerController.isLoading.value) {
        // Location is available but prayer times not fetched yet
        prayerController.fetchPrayerTimes();
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
              const Color(0xFF334155),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prayer time',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final now = DateTime.now();
                      final dateFormat = DateFormat('EEEE, dd MMM, yyyy hh:mm a');
                      final hijriDate = prayerController.prayerData.value?.data?.date?.hijri;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormat.format(now),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          if (hijriDate != null)
                            Text(
                              '${hijriDate.month?.en ?? ''} ${hijriDate.day ?? ''}, ${hijriDate.year ?? ''}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              // Prayer times list
              Expanded(
                child: Obx(() {
                  // Check if location is still loading
                  if (locationController.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Getting your location...',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Check location permission first
                  if (!locationController.hasPermission.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_off,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            locationController.errorMessage.value.isNotEmpty
                                ? locationController.errorMessage.value
                                : 'Location permission is required to get prayer times',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await locationController.checkLocationPermission();
                              if (locationController.hasPermission.value &&
                                  locationController.latitude.value != 0.0) {
                                prayerController.fetchPrayerTimes();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                            ),
                            child: Text(
                              'Grant Permission',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (prayerController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            prayerController.errorMessage.value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => prayerController.fetchPrayerTimes(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                            ),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final times = prayerController.prayerData.value?.data?.times;
                  if (times == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading prayer times...',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final prayers = [
                    {
                      'name': 'Fajr',
                      'apiName': 'Fajr',
                      'time': times.fajr ?? '',
                      'icon': Icons.wb_twilight,
                      'color': const Color(0xFF60A5FA),
                    },
                    {
                      'name': 'Zuhr',
                      'apiName': 'Zuhr',
                      'time': times.dhuhr ?? '',
                      'icon': Icons.wb_sunny,
                      'color': const Color(0xFFF97316),
                    },
                    {
                      'name': 'Asr',
                      'apiName': 'Asr',
                      'time': times.asr ?? '',
                      'icon': Icons.wb_sunny,
                      'color': const Color(0xFFF97316),
                    },
                    {
                      'name': 'Maghrib',
                      'apiName': 'Maghrib',
                      'time': times.maghrib ?? '',
                      'icon': Icons.wb_twilight,
                      'color': const Color(0xFF60A5FA),
                    },
                    {
                      'name': 'Isha',
                      'apiName': 'Isha',
                      'time': times.isha ?? '',
                      'icon': Icons.nightlight_round,
                      'color': const Color(0xFF60A5FA),
                    },
                  ];

                  // Get current prayer name
                  final currentPrayerName = prayerController.getCurrentPrayerName();
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: prayers.length,
                    itemBuilder: (context, index) {
                      final prayer = prayers[index];
                      final prayerApiName = prayer['apiName'] as String;
                      final isActive = prayerApiName.toLowerCase() == 
                                      currentPrayerName.toLowerCase();
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: (prayer['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              prayer['icon'] as IconData,
                              color: prayer['color'] as Color,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            prayer['name'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                prayer['time'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                isActive ? Icons.notifications_active : Icons.notifications_outlined,
                                color: isActive ? const Color(0xFF10B981) : Colors.grey.shade400,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
