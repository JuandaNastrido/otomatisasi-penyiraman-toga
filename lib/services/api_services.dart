import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL untuk backend lokal (data sensor)
  static const String baseUrl = 'http://10.242.162.1:3000';

  // Konfigurasi OpenWeatherMap
  // Ganti 'YOUR_API_KEY' dengan API Key yang Anda dapatkan dari OpenWeatherMap
  static const String weatherApiKey = '559fcb010ff79ecfc7ac3d4689f65814';
  static const String city = 'Jakarta'; // Ganti dengan lokasi lahan Anda
  static const String weatherUrl = 'https://api.openweathermap.org/data/2.5';

  /// Mengambil data sensor dari backend lokal
  Future<List<dynamic>> getSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/data'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Mengambil data cuaca real-time dari OpenWeatherMap
  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      // 1. Ambil cuaca saat ini
      final weatherResponse = await http.get(
        Uri.parse('$weatherUrl/weather?q=$city&appid=$weatherApiKey&units=metric&lang=id'),
      );

      // 2. Ambil prakiraan untuk mendapatkan probabilitas hujan (menggunakan endpoint forecast)
      final forecastResponse = await http.get(
        Uri.parse('$weatherUrl/forecast?q=$city&appid=$weatherApiKey&units=metric&cnt=8&lang=id'),
      );

      if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        final forecastData = json.decode(forecastResponse.body);

        // Ambil probabilitas hujan dari item forecast pertama (biasanya ada field 'pop' 0-1)
        double rainProb = 0.0;
        if (forecastData['list'] != null && forecastData['list'].isNotEmpty) {
          rainProb = (forecastData['list'][0]['pop'] ?? 0.0) * 100;
        }

        // Mapping ke format yang digunakan di DashboardScreen
        return {
          'suhu': weatherData['main']['temp'],
          'kelembaban': weatherData['main']['humidity'],
          'kondisi': weatherData['weather'][0]['description'],
          'prakiraan_hujan': rainProb.toInt(),
          'icon': weatherData['weather'][0]['icon'],
        };
      } else {
        throw Exception('Gagal memuat cuaca dari OpenWeatherMap');
      }
    } catch (e) {
      print('Weather API Error: $e');
      // Fallback ke data lokal jika OpenWeatherMap gagal (opsional)
      return _getFallbackWeatherData();
    }
  }

  Future<Map<String, dynamic>> _getFallbackWeatherData() async {
    // Implementasi fallback jika API OpenWeatherMap bermasalah
    return {
      'suhu': 0,
      'kelembaban': 0,
      'kondisi': 'Error Loading',
      'prakiraan_hujan': 0,
    };
  }
}
