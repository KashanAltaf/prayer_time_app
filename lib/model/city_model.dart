class CityModel {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => '$name, $country';
}

class CitiesData {
  static final List<CityModel> cities = [
    // Pakistan
    CityModel(name: 'Islamabad', country: 'Pakistan', latitude: 33.6844, longitude: 73.0479),
    CityModel(name: 'Karachi', country: 'Pakistan', latitude: 24.8607, longitude: 67.0011),
    
    // Major World Capitals
    CityModel(name: 'Kabul', country: 'Afghanistan', latitude: 34.5553, longitude: 69.2075),
    CityModel(name: 'Tirana', country: 'Albania', latitude: 41.3275, longitude: 19.8187),
    CityModel(name: 'Algiers', country: 'Algeria', latitude: 36.7538, longitude: 3.0588),
    CityModel(name: 'Buenos Aires', country: 'Argentina', latitude: -34.6037, longitude: -58.3816),
    CityModel(name: 'Canberra', country: 'Australia', latitude: -35.2809, longitude: 149.1300),
    CityModel(name: 'Vienna', country: 'Austria', latitude: 48.2082, longitude: 16.3738),
    CityModel(name: 'Dhaka', country: 'Bangladesh', latitude: 23.8103, longitude: 90.4125),
    CityModel(name: 'Brussels', country: 'Belgium', latitude: 50.8503, longitude: 4.3517),
    CityModel(name: 'Brasília', country: 'Brazil', latitude: -15.7942, longitude: -47.8822),
    CityModel(name: 'Ottawa', country: 'Canada', latitude: 45.4215, longitude: -75.6972),
    CityModel(name: 'Beijing', country: 'China', latitude: 39.9042, longitude: 116.4074),
    CityModel(name: 'Cairo', country: 'Egypt', latitude: 30.0444, longitude: 31.2357),
    CityModel(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522),
    CityModel(name: 'Berlin', country: 'Germany', latitude: 52.5200, longitude: 13.4050),
    CityModel(name: 'Athens', country: 'Greece', latitude: 37.9838, longitude: 23.7275),
    CityModel(name: 'New Delhi', country: 'India', latitude: 28.6139, longitude: 77.2090),
    CityModel(name: 'Jakarta', country: 'Indonesia', latitude: -6.2088, longitude: 106.8456),
    CityModel(name: 'Tehran', country: 'Iran', latitude: 35.6892, longitude: 51.3890),
    CityModel(name: 'Baghdad', country: 'Iraq', latitude: 33.3152, longitude: 44.3661),
    CityModel(name: 'Rome', country: 'Italy', latitude: 41.9028, longitude: 12.4964),
    CityModel(name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503),
    CityModel(name: 'Amman', country: 'Jordan', latitude: 31.9539, longitude: 35.9106),
    CityModel(name: 'Nairobi', country: 'Kenya', latitude: -1.2921, longitude: 36.8219),
    CityModel(name: 'Kuwait City', country: 'Kuwait', latitude: 29.3759, longitude: 47.9774),
    CityModel(name: 'Beirut', country: 'Lebanon', latitude: 33.8938, longitude: 35.5018),
    CityModel(name: 'Kuala Lumpur', country: 'Malaysia', latitude: 3.1390, longitude: 101.6869),
    CityModel(name: 'Mexico City', country: 'Mexico', latitude: 19.4326, longitude: -99.1332),
    CityModel(name: 'Rabat', country: 'Morocco', latitude: 34.0209, longitude: -6.8416),
    CityModel(name: 'Amsterdam', country: 'Netherlands', latitude: 52.3676, longitude: 4.9041),
    CityModel(name: 'Abuja', country: 'Nigeria', latitude: 9.0765, longitude: 7.3986),
    CityModel(name: 'Muscat', country: 'Oman', latitude: 23.5859, longitude: 58.4059),
    CityModel(name: 'Doha', country: 'Qatar', latitude: 25.2854, longitude: 51.5310),
    CityModel(name: 'Riyadh', country: 'Saudi Arabia', latitude: 24.7136, longitude: 46.6753),
    CityModel(name: 'Singapore', country: 'Singapore', latitude: 1.3521, longitude: 103.8198),
    CityModel(name: 'Cape Town', country: 'South Africa', latitude: -33.9249, longitude: 18.4241),
    CityModel(name: 'Seoul', country: 'South Korea', latitude: 37.5665, longitude: 126.9780),
    CityModel(name: 'Madrid', country: 'Spain', latitude: 40.4168, longitude: -3.7038),
    CityModel(name: 'Colombo', country: 'Sri Lanka', latitude: 6.9271, longitude: 79.8612),
    CityModel(name: 'Khartoum', country: 'Sudan', latitude: 15.5007, longitude: 32.5599),
    CityModel(name: 'Stockholm', country: 'Sweden', latitude: 59.3293, longitude: 18.0686),
    CityModel(name: 'Damascus', country: 'Syria', latitude: 33.5138, longitude: 36.2765),
    CityModel(name: 'Tunis', country: 'Tunisia', latitude: 36.8065, longitude: 10.1815),
    CityModel(name: 'Ankara', country: 'Turkey', latitude: 39.9334, longitude: 32.8597),
    CityModel(name: 'Abu Dhabi', country: 'UAE', latitude: 24.4539, longitude: 54.3773),
    CityModel(name: 'London', country: 'United Kingdom', latitude: 51.5074, longitude: -0.1278),
    CityModel(name: 'Washington, D.C.', country: 'United States', latitude: 38.9072, longitude: -77.0369),
    CityModel(name: 'New York', country: 'United States', latitude: 40.7128, longitude: -74.0060),
    CityModel(name: 'Los Angeles', country: 'United States', latitude: 34.0522, longitude: -118.2437),
    CityModel(name: 'Chicago', country: 'United States', latitude: 41.8781, longitude: -87.6298),
    CityModel(name: 'Moscow', country: 'Russia', latitude: 55.7558, longitude: 37.6173),
    CityModel(name: 'Istanbul', country: 'Turkey', latitude: 41.0082, longitude: 28.9784),
    CityModel(name: 'Dubai', country: 'UAE', latitude: 25.2048, longitude: 55.2708),
    CityModel(name: 'Jeddah', country: 'Saudi Arabia', latitude: 21.4858, longitude: 39.1925),
    CityModel(name: 'Mecca', country: 'Saudi Arabia', latitude: 21.3891, longitude: 39.8579),
    CityModel(name: 'Medina', country: 'Saudi Arabia', latitude: 24.5247, longitude: 39.5692),
  ];
}

