import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prayer_time_app/model/city_model.dart';

class SettingsController extends GetxController {
  final RxInt selectedMethod = 3.obs; // Default: Muslim World League
  final RxInt selectedSchool = 1.obs; // Default: Shafi
  final RxBool useGpsLocation = true.obs; // Default: Use GPS
  final Rx<CityModel?> selectedCity = Rx<CityModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      selectedMethod.value = prefs.getInt('prayer_method') ?? 3;
      selectedSchool.value = prefs.getInt('prayer_school') ?? 1;
      useGpsLocation.value = prefs.getBool('use_gps_location') ?? true;
      
      // Load selected city
      final cityName = prefs.getString('selected_city_name');
      final cityCountry = prefs.getString('selected_city_country');
      if (cityName != null && cityCountry != null) {
        final city = CitiesData.cities.firstWhere(
          (c) => c.name == cityName && c.country == cityCountry,
          orElse: () => CitiesData.cities.first,
        );
        selectedCity.value = city;
      }
    } catch (e) {
      // Use defaults if loading fails
    }
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('prayer_method', selectedMethod.value);
      await prefs.setInt('prayer_school', selectedSchool.value);
      await prefs.setBool('use_gps_location', useGpsLocation.value);
      
      if (selectedCity.value != null) {
        await prefs.setString('selected_city_name', selectedCity.value!.name);
        await prefs.setString('selected_city_country', selectedCity.value!.country);
      }
    } catch (e) {
      // Handle error
    }
  }

  void setMethod(int method) {
    selectedMethod.value = method;
    saveSettings();
  }

  void setSchool(int school) {
    selectedSchool.value = school;
    saveSettings();
  }

  void setUseGpsLocation(bool useGps) {
    useGpsLocation.value = useGps;
    saveSettings();
  }

  void setSelectedCity(CityModel? city) {
    selectedCity.value = city;
    saveSettings();
  }

  String getMethodName(int method) {
    switch (method) {
      case 0:
        return 'Jafari / Shia Ithna-Ashari';
      case 1:
        return 'University of Islamic Sciences, Karachi';
      case 2:
        return 'Islamic Society of North America';
      case 3:
        return 'Muslim World League';
      case 4:
        return 'Umm Al-Qura University, Makkah';
      case 5:
        return 'Egyptian General Authority of Survey';
      case 7:
        return 'Institute of Geophysics, Tehran';
      case 8:
        return 'Gulf Region';
      case 9:
        return 'Kuwait';
      case 10:
        return 'Qatar';
      case 11:
        return 'MUIS, Singapore';
      case 12:
        return 'UOIF, France';
      case 13:
        return 'Diyanet, Turkey';
      case 14:
        return 'Russia';
      case 15:
        return 'Moonsighting Committee Worldwide';
      case 16:
        return 'Dubai (experimental)';
      case 17:
        return 'JAKIM, Malaysia';
      case 18:
        return 'Tunisia';
      case 19:
        return 'Algeria';
      case 20:
        return 'KEMENAG, Indonesia';
      case 21:
        return 'Morocco';
      case 22:
        return 'Lisbon, Portugal';
      case 23:
        return 'Jordan';
      default:
        return 'Unknown';
    }
  }

  String getSchoolName(int school) {
    switch (school) {
      case 1:
        return 'Shafi';
      case 2:
        return 'Hanafi';
      default:
        return 'Unknown';
    }
  }
}

