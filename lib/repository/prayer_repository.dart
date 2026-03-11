import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:prayer_time_app/model/prayer_model.dart';

class PrayerRepository {
  static const String apiKey = 'AcQs0yB4v1Pb4tIpWwBEEHPpOTvuSDJ8dJWv4x1W5IdgecPh';
  static const String baseUrl = 'https://islamicapi.com/api/v1/prayer-time/';

  Future<PrayerModel> fetchPrayerDataApi({
    required double lat,
    required double lon,
    int method = 3,
    int school = 1,
  }) async {
    final url = Uri.parse(
      '$baseUrl?lat=$lat&lon=$lon&method=$method&school=$school&api_key=$apiKey',
    );
    
    if (kDebugMode) {
      print('═══════════════════════════════════════════════════════════');
      print('📤 PRAYER API REQUEST');
      print('═══════════════════════════════════════════════════════════');
      print('URL: $url');
      print('Latitude: $lat');
      print('Longitude: $lon');
      print('Method: $method');
      print('School: $school');
      print('═══════════════════════════════════════════════════════════');
    }
    
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http.get(url);
      stopwatch.stop();
      
      final responseBody = response.body;
      final statusCode = response.statusCode;
      
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📥 PRAYER API RESPONSE');
        print('═══════════════════════════════════════════════════════════');
        print('Status Code: $statusCode');
        print('Response Time: ${stopwatch.elapsedMilliseconds}ms');
        print('Response Length: ${responseBody.length} characters');
        print('───────────────────────────────────────────────────────────');
        print('RESPONSE BODY:');
        print('───────────────────────────────────────────────────────────');
        
        // Pretty print JSON
        try {
          final jsonData = jsonDecode(responseBody);
          final encoder = JsonEncoder.withIndent('  ');
          print(encoder.convert(jsonData));
        } catch (e) {
          print(responseBody);
        }
        
        print('───────────────────────────────────────────────────────────');
        
        if (statusCode == 200) {
          print('✅ SUCCESS');
          final body = jsonDecode(responseBody);
          
          // Print key data
          if (body['data'] != null) {
            final data = body['data'];
            print('📅 Date: ${data['date']?['readable'] ?? 'N/A'}');
            if (data['times'] != null) {
              final times = data['times'];
              print('🕌 Prayer Times:');
              print('   Fajr:   ${times['Fajr'] ?? 'N/A'}');
              print('   Dhuhr:  ${times['Dhuhr'] ?? 'N/A'}');
              print('   Asr:    ${times['Asr'] ?? 'N/A'}');
              print('   Maghrib: ${times['Maghrib'] ?? 'N/A'}');
              print('   Isha:   ${times['Isha'] ?? 'N/A'}');
            }
            if (data['qibla'] != null) {
              final qibla = data['qibla'];
              print('🧭 Qibla Direction: ${qibla['direction']?['degrees'] ?? 'N/A'}°');
              print('📏 Distance: ${qibla['distance']?['value'] ?? 'N/A'} ${qibla['distance']?['unit'] ?? 'km'}');
            }
          }
        } else {
          print('❌ ERROR');
          print('Error Body: $responseBody');
        }
        
        print('═══════════════════════════════════════════════════════════');
      }
      
      if (statusCode == 200) {
        final body = jsonDecode(responseBody);
        return PrayerModel.fromJson(body);
      } else {
        throw Exception('Failed to load prayer times: $statusCode - $responseBody');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('❌ PRAYER API EXCEPTION');
        print('═══════════════════════════════════════════════════════════');
        print('Error: $e');
        print('───────────────────────────────────────────────────────────');
        print('Stack Trace:');
        print(stackTrace);
        print('═══════════════════════════════════════════════════════════');
      }
      rethrow;
    }
  }
}