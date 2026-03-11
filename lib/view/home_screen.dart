import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prayer_time_app/controller/prayer_controller.dart';
import 'package:prayer_time_app/controller/location_controller.dart';
import 'package:prayer_time_app/controller/prayer_timer_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerController = Get.find<PrayerController>();
    final locationController = Get.find<LocationController>();
    final timerController = Get.find<PrayerTimerController>();

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
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header section with gradient and mosque illustration
            Container(
              height: Get.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF8C42),
                    const Color(0xFFFFB347),
                    const Color(0xFFFFA500),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(120),
                  bottomLeft: Radius.circular(120),
                )
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Mosque illustration - full width
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.orange,
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Prayer time',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Countdown timer
                    Positioned(
                      left: 0,
                      right: 0,
                      top: Get.height * 0.11,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                        child: Obx(() {
                          if (!timerController.isInitialized.value) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Time until ${timerController.nextPrayerName.value}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  timerController.timeRemaining.value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${timerController.nextPrayerName.value} at ${timerController.nextPrayerTime.value}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Obx(() {
                        final now = DateTime.now();
                        final dateFormat = DateFormat('EEEE, dd MMM, yyyy hh:mm a');
                        final hijriDate = prayerController.prayerData.value?.data?.date?.hijri;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dateFormat.format(now),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (hijriDate != null)
                              Text(
                                '${hijriDate.month?.en ?? ''} ${hijriDate.day ?? ''}, ${hijriDate.year ?? ''}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02,),
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

                if (prayerController.isLoading.value) {
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
                    'name': 'Fajar',
                    'apiName': 'Fajr',
                    'time': times.fajr ?? '',
                    'icon': Icons.wb_twilight,
                    'iconColor': const Color(0xFF60A5FA),
                    'bgColor': const Color(0xFFE3F2FD),
                  },
                  {
                    'name': 'Zuhr',
                    'apiName': 'Zuhr',
                    'time': times.dhuhr ?? '',
                    'icon': Icons.wb_sunny,
                    'iconColor': const Color(0xFFFF8C42),
                    'bgColor': const Color(0xFFFFF3E0),
                  },
                  {
                    'name': 'Asr',
                    'apiName': 'Asr',
                    'time': times.asr ?? '',
                    'icon': Icons.wb_sunny,
                    'iconColor': const Color(0xFFFF8C42),
                    'bgColor': const Color(0xFFFFF3E0),
                  },
                  {
                    'name': 'Maghrib',
                    'apiName': 'Maghrib',
                    'time': times.maghrib ?? '',
                    'icon': Icons.wb_twilight,
                    'iconColor': const Color(0xFF60A5FA),
                    'bgColor': const Color(0xFFE3F2FD),
                  },
                  {
                    'name': 'Isha',
                    'apiName': 'Isha',
                    'time': times.isha ?? '',
                    'icon': Icons.nightlight_round,
                    'iconColor': const Color(0xFF90CAF9),
                    'bgColor': const Color(0xFFE3F2FD),
                  },
                ];

                // Get current prayer name
                final currentPrayerName = prayerController.getCurrentPrayerName();
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: prayers.length,
                  itemBuilder: (context, index) {
                    final prayer = prayers[index];
                    final prayerApiName = prayer['apiName'] as String;
                    final isActive = prayerApiName.toLowerCase() == 
                                    currentPrayerName.toLowerCase();
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade700.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: prayer['bgColor'] as Color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            prayer['icon'] as IconData,
                            color: prayer['iconColor'] as Color,
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
                              isActive 
                                  ? Icons.notifications_active 
                                  : Icons.notifications_off,
                              color: isActive 
                                  ? const Color(0xFF10B981) 
                                  : Colors.grey.shade400,
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
    );
  }
}
