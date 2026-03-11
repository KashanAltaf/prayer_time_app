import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayer_time_app/controller/settings_controller.dart';
import 'package:prayer_time_app/controller/location_controller.dart';
import 'package:prayer_time_app/model/city_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final locationController = Get.find<LocationController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // GPS Toggle and Location Selection
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade700,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Location',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, height: 1),
                // GPS Toggle
                Obx(() {
                  final hasPermission = locationController.hasPermission.value;
                  final useGps = settingsController.useGpsLocation.value;
                  
                  return ListTile(
                    title: Text(
                      'Use GPS Location',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          useGps
                              ? 'Using device GPS location'
                              : 'Using manually selected city',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        if (!hasPermission)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Location permission required to use GPS',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.orange.shade300,
                              ),
                            ),
                          ),
                      ],
                    ),
                    trailing: Switch(
                      value: useGps,
                      onChanged: hasPermission
                          ? (value) {
                              settingsController.setUseGpsLocation(value);
                            }
                          : null,
                      activeColor: const Color(0xFF10B981),
                    ),
                  );
                }),
                // City Dropdown (shown when GPS is off)
                Obx(() {
                  if (settingsController.useGpsLocation.value) {
                    return const SizedBox.shrink();
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select City',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade600,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CityModel>(
                              isExpanded: true,
                              value: settingsController.selectedCity.value,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Select a city',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ),
                              dropdownColor: Colors.grey.shade800,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              items: CitiesData.cities.map((city) {
                                return DropdownMenuItem<CityModel>(
                                  value: city,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      city.displayName,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: settingsController.useGpsLocation.value
                                  ? null
                                  : (CityModel? newCity) {
                                      if (newCity != null) {
                                        settingsController.setSelectedCity(newCity);
                                      }
                                    },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Method Selection
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade700,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Calculation Method',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, height: 1),
                Obx(() {
                  final selectedMethod = settingsController.selectedMethod.value;
                  
                  return ExpansionTile(
                    title: Text(
                      settingsController.getMethodName(selectedMethod),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Method: $selectedMethod',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.grey.shade400,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    children: [
                      ..._buildMethodOptions(settingsController),
                    ],
                  );
                }),
              ],
            ),
          ),

          // School Selection
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade700,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'School of Thought (Asr)',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, height: 1),
                Obx(() {
                  final selectedSchool = settingsController.selectedSchool.value;
                  
                  return ExpansionTile(
                    title: Text(
                      settingsController.getSchoolName(selectedSchool),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'School: $selectedSchool',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.grey.shade400,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    children: [
                      ..._buildSchoolOptions(settingsController),
                    ],
                  );
                }),
              ],
            ),
          ),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blue.shade700,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade300,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Changing these settings will update prayer times. The app will automatically refresh.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blue.shade200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMethodOptions(
    SettingsController settingsController,
  ) {
    final methods = [
      {'value': 0, 'name': 'Jafari / Shia Ithna-Ashari'},
      {'value': 1, 'name': 'University of Islamic Sciences, Karachi'},
      {'value': 2, 'name': 'Islamic Society of North America'},
      {'value': 3, 'name': 'Muslim World League'},
      {'value': 4, 'name': 'Umm Al-Qura University, Makkah'},
      {'value': 5, 'name': 'Egyptian General Authority of Survey'},
      {'value': 7, 'name': 'Institute of Geophysics, Tehran'},
      {'value': 8, 'name': 'Gulf Region'},
      {'value': 9, 'name': 'Kuwait'},
      {'value': 10, 'name': 'Qatar'},
      {'value': 11, 'name': 'MUIS, Singapore'},
      {'value': 12, 'name': 'UOIF, France'},
      {'value': 13, 'name': 'Diyanet, Turkey'},
      {'value': 14, 'name': 'Russia'},
      {'value': 15, 'name': 'Moonsighting Committee Worldwide'},
      {'value': 16, 'name': 'Dubai (experimental)'},
      {'value': 17, 'name': 'JAKIM, Malaysia'},
      {'value': 18, 'name': 'Tunisia'},
      {'value': 19, 'name': 'Algeria'},
      {'value': 20, 'name': 'KEMENAG, Indonesia'},
      {'value': 21, 'name': 'Morocco'},
      {'value': 22, 'name': 'Lisbon, Portugal'},
      {'value': 23, 'name': 'Jordan'},
    ];

    return methods.map((method) {
      final methodValue = method['value'] as int;
      final methodName = method['name'] as String;
      final isSelected = settingsController.selectedMethod.value == methodValue;

      return ListTile(
        title: Text(
          methodName,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.green.shade400)
            : Icon(Icons.radio_button_unchecked, color: Colors.grey.shade600),
        onTap: () {
          settingsController.setMethod(methodValue);
          // Prayer times will refresh automatically via listener in PrayerController
        },
      );
    }).toList();
  }

  List<Widget> _buildSchoolOptions(
    SettingsController settingsController,
  ) {
    final schools = [
      {'value': 1, 'name': 'Shafi'},
      {'value': 2, 'name': 'Hanafi'},
    ];

    return schools.map((school) {
      final schoolValue = school['value'] as int;
      final schoolName = school['name'] as String;
      final isSelected = settingsController.selectedSchool.value == schoolValue;

      return ListTile(
        title: Text(
          schoolName,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.green.shade400)
            : Icon(Icons.radio_button_unchecked, color: Colors.grey.shade600),
        onTap: () {
          settingsController.setSchool(schoolValue);
          // Prayer times will refresh automatically via listener in PrayerController
        },
      );
    }).toList();
  }
}

