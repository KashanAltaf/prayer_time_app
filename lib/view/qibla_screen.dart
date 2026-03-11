import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayer_time_app/controller/qibla_controller.dart';
import 'package:prayer_time_app/controller/location_controller.dart';
import 'package:prayer_time_app/controller/prayer_controller.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qiblaController = Get.find<QiblaController>();
    final locationController = Get.find<LocationController>();
    final prayerController = Get.find<PrayerController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qibla Direction',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Location panel (light green)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Obx(() {
                final locationParts = locationController.locationName.value.split(', ');
                final city = locationParts.isNotEmpty ? locationParts[0] : '';
                final country = locationParts.length > 1 
                    ? locationParts.sublist(1).join(', ') 
                    : locationController.locationName.value;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locationController.locationName.value,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.green.shade700, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              '🇧🇩',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          country,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 24),

            // Compass section
            Expanded(
              child: Obx(() {
                if (!qiblaController.hasCompass.value) {
                  return Center(
                    child: Text(
                      qiblaController.errorMessage.value.isNotEmpty
                          ? qiblaController.errorMessage.value
                          : 'Compass not available',
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Compass
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Compass background circle
                          Transform.rotate(
                            angle: (qiblaController.compassHeading.value * 
                                    (math.pi / 180)),
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Degree tick marks
                                  ...List.generate(72, (index) {
                                    final angle = (index * 5) * (math.pi / 180);
                                    final isMain = index % 6 == 0;
                                    final isCardinal = index % 18 == 0;
                                    
                                    return Positioned(
                                      left: 140 + 130 * math.cos(angle - math.pi / 2),
                                      top: 140 + 130 * math.sin(angle - math.pi / 2),
                                      child: Transform.rotate(
                                        angle: angle + math.pi / 2,
                                        child: Container(
                                          width: isMain ? 2 : 1,
                                          height: isMain 
                                              ? (isCardinal ? 20 : 15) 
                                              : 8,
                                          color: isCardinal 
                                              ? const Color(0xFF2E7D32)
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    );
                                  }),

                                  // Cardinal directions
                                  Positioned(
                                    top: 8,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Text(
                                        'N',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Text(
                                        'S',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(
                                        'W',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(
                                        'E',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Center dot
                                  Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Compass needle (rotates with device)
                          Transform.rotate(
                            angle: (qiblaController.compassHeading.value * 
                                    (math.pi / 180)),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Red part of needle (pointing north)
                                Positioned(
                                  top: -120,
                                  child: Container(
                                    width: 3,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                // Black part of needle (pointing south)
                                Positioned(
                                  bottom: -120,
                                  child: Container(
                                    width: 3,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Kaaba icon (positioned on compass circle based on Qibla direction)
                          Obx(() {
                            final qiblaAngle = qiblaController.qiblaDirection.value;
                            final compassAngle = qiblaController.compassHeading.value;
                            final relativeAngle = (qiblaAngle - compassAngle) * (math.pi / 180);
                            
                            // Calculate position relative to center (140, 140)
                            final radius = 120.0;
                            final centerX = 140.0;
                            final centerY = 140.0;
                            final iconSize = 12.0; // Half of 24
                            
                            final x = centerX + radius * math.sin(relativeAngle) - iconSize;
                            final y = centerY - radius * math.cos(relativeAngle) - iconSize;
                            
                            return Positioned(
                              left: x,
                              top: y,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B4513),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.black87,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF654321),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Qibla info
                    Obx(() {
                      final qiblaDeg = qiblaController.qiblaDirection.value;
                      final distance = qiblaController.distanceToKaaba.value;
                      
                      return Column(
                        children: [
                          Text(
                            'Qibla ${qiblaDeg.toStringAsFixed(1)}° from north',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Distance to Ka\'bah ${distance.toStringAsFixed(0)} KM',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

                    // Earth graphic with prayer times
                    Expanded(
                      child: Stack(
                        children: [
                          // Earth graphic (semi-circle)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: CustomPaint(
                              size: Size(MediaQuery.of(context).size.width, 200),
                              painter: EarthPainter(),
                            ),
                          ),

                          // Prayer times positioned around Earth
                          Obx(() {
                            final times = prayerController.prayerData.value?.data?.times;
                            if (times == null) {
                              return const SizedBox.shrink();
                            }

                            final prayers = [
                              {
                                'name': 'Fajr',
                                'time': times.fajr ?? '',
                                'position': const Alignment(-0.8, 0.7),
                                'icon': Icons.wb_sunny,
                                'iconColor': Colors.amber,
                              },
                              {
                                'name': 'Zuhr',
                                'time': times.dhuhr ?? '',
                                'position': const Alignment(-0.4, 0.2),
                                'icon': Icons.wb_sunny,
                                'iconColor': Colors.amber,
                              },
                              {
                                'name': 'Asr',
                                'time': times.asr ?? '',
                                'position': const Alignment(0.0, -0.3),
                                'icon': Icons.wb_cloudy,
                                'iconColor': Colors.lightBlue,
                              },
                              {
                                'name': 'Maghrib',
                                'time': times.maghrib ?? '',
                                'position': const Alignment(0.4, 0.2),
                                'icon': Icons.wb_cloudy,
                                'iconColor': Colors.lightBlue,
                              },
                              {
                                'name': 'Isha',
                                'time': times.isha ?? '',
                                'position': const Alignment(0.8, 0.7),
                                'icon': Icons.wb_sunny,
                                'iconColor': Colors.amber,
                              },
                            ];

                            return Stack(
                              children: prayers.map((prayer) {
                                return Align(
                                  alignment: prayer['position'] as Alignment,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        prayer['name'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Icon(
                                        prayer['icon'] as IconData,
                                        color: prayer['iconColor'] as Color,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class EarthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw semi-circular Earth
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * 0.3,
      size.width,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Ocean color
    final oceanPaint = Paint()..color = const Color(0xFF2196F3);
    canvas.drawPath(path, oceanPaint);

    // Land masses (green shapes)
    final landPaint = Paint()..color = const Color(0xFF4CAF50);
    
    // Draw some land shapes
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.3, size.width * 0.25, size.height * 0.2),
      landPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.65, size.height * 0.4, size.width * 0.25, size.height * 0.15),
      landPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.5, size.width * 0.3, size.height * 0.18),
      landPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
