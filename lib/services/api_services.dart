import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL untuk backend lokal (data sensor)
  static const String baseUrl = 'http://172.20.12.1:3000';

  // Konfigurasi OpenWeatherMap menggunakan API Key Anda yang sudah aktif
  final String weatherApiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static const String city = 'Jakarta';
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
        throw Exception('Gagal memuat data sensor: ${response.statusCode}');
      }
    } catch (e) {
      print('Sensor API Error: $e');
      throw Exception('Error Sensor: $e');
    }
  }

  /// Mengambil data cuaca real-time dari OpenWeatherMap
  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      // 1. Ambil cuaca saat ini (Current Weather)
      final weatherResponse = await http.get(
        Uri.parse('$weatherUrl/weather?q=$city,id&appid=$weatherApiKey&units=metric&lang=id'),
      );

      // 2. Ambil prakiraan cuaca (Forecast) untuk mendapatkan probabilitas hujan
      double rainProb = 0.0;
      try {
        final forecastResponse = await http.get(
          Uri.parse('$weatherUrl/forecast?q=$city,id&appid=$weatherApiKey&units=metric&cnt=8&lang=id'),
        );

        if (forecastResponse.statusCode == 200) {
          final forecastData = json.decode(forecastResponse.body);
          if (forecastData['list'] != null && forecastData['list'].isNotEmpty) {
            // Ambil field 'pop' (Probability of Precipitation) dari data terdekat (indeks 0) dan ubah ke persen
            rainProb = (forecastData['list'][0]['pop'] ?? 0.0) * 100;
          }
        } else {
          print('Forecast API returned status: ${forecastResponse.statusCode}');
        }
      } catch (e) {
        // Jika forecast error/limit, abaikan saja agar data cuaca utama tidak ikut gagal ter-load
        print('Forecast API Error (Diabaikan agar tidak crash): $e');
      }

      // 3. Validasi respon data cuaca utama
      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);

        // Cetak log ke Debug Console Android Studio untuk memantau data masuk
        print("=== DATA CUACA BERHASIL DIAMBIL ===");
        print("Kota: ${weatherData['name']}");
        print("Suhu: ${weatherData['main']['temp']}°C");
        print("Kondisi: ${weatherData['weather'][0]['description']}");
        print("Probabilitas Hujan: ${rainProb.toInt()}%");
        print("===================================");

        // Mapping data JSON ke Map yang siap dibaca oleh DashboardScreen
        return {
          'suhu': weatherData['main']['temp'],
          'kelembaban': weatherData['main']['humidity'],
          'kondisi': weatherData['weather'][0]['description'],
          'prakiraan_hujan': rainProb.toInt(),
          'icon': weatherData['weather'][0]['icon'],
        };
      } else {
        print('OpenWeatherMap Error Status: ${weatherResponse.statusCode}');
        print('Respon Body: ${weatherResponse.body}');
        throw Exception('Gagal memuat cuaca dari OpenWeatherMap');
      }
    } catch (e) {
      // Menangkap error jika terjadi kendala koneksi internet atau parsing gagal
      print('Sistem Error pada getWeatherData(): $e');
      return _getFallbackWeatherData();
    }
  }

  /// Data cadangan (fallback) jika koneksi ke OpenWeatherMap terputus
  Future<Map<String, dynamic>> _getFallbackWeatherData() async {
    return {
      'suhu': 0,
      'kelembaban': 0,
      'kondisi': 'Koneksi Error',
      'prakiraan_hujan': 0,
      'icon': '01d',
    };
  }
}