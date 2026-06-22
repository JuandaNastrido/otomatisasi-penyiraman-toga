import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL untuk backend lokal (data sensor utama)
  static const String baseUrl = 'http://193.168.1.34:8082';
  
  // Base URL untuk riwayat data sensor
  static const String historyBaseUrl = 'http://192.168.1.24:8082';

  // Base URL untuk layanan otentikasi (Security Service)
  // Menggunakan IP 172.20.12.1 agar bisa diakses dari emulator/device Android
  static const String authBaseUrl = 'http://192.168.1.24:8084';

  // Konfigurasi OpenWeatherMap menggunakan API Key Anda yang sudah aktif
  final String weatherApiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static const String city = 'Bandung';
  static const String weatherUrl = 'https://api.openweathermap.org/data/2.5';

  /// Registrasi user baru ke security-service
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Coba ambil pesan error jika ada
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Gagal registrasi: ${response.statusCode}');
        } catch (_) {
          throw Exception('Gagal registrasi: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Register API Error: $e');
      throw Exception('Error Register: $e');
    }
  }

  /// Login user ke security-service
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Gagal login: ${response.statusCode}');
        } catch (_) {
          throw Exception('Gagal login: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Login API Error: $e');
      throw Exception('Error Login: $e');
    }
  }

  /// Validasi token
  Future<bool> validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$authBaseUrl/auth/validate?token=$token'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Validate Token Error: $e');
      return false;
    }
  }

  /// Mengambil data sensor terbaru dari server baru (Port 8082)
  Future<Map<String, dynamic>> getLatestSensorData(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$historyBaseUrl/api/sensor-data/latest/$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat data sensor terbaru: ${response.statusCode}');
      }
    } catch (e) {
      print('Latest Sensor API Error: $e');
      throw Exception('Error Latest Sensor: $e');
    }
  }

  /// Mengambil riwayat data sensor dari server baru (Port 8082)
  Future<Map<String, dynamic>> getSensorHistory(String email, {int limit = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$historyBaseUrl/api/sensor-data/history/$email?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat riwayat sensor: ${response.statusCode}');
      }
    } catch (e) {
      print('History API Error: $e');
      throw Exception('Error History: $e');
    }
  }

  /// Mengambil data sensor dari backend lokal (Port 8082)
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
      final weatherResponse = await http.get(
        Uri.parse('$weatherUrl/weather?q=$city,id&appid=$weatherApiKey&units=metric&lang=id'),
      );

      double rainProb = 0.0;
      try {
        final forecastResponse = await http.get(
          Uri.parse('$weatherUrl/forecast?q=$city,id&appid=$weatherApiKey&units=metric&cnt=8&lang=id'),
        );

        if (forecastResponse.statusCode == 200) {
          final forecastData = json.decode(forecastResponse.body);
          if (forecastData['list'] != null && forecastData['list'].isNotEmpty) {
            rainProb = (forecastData['list'][0]['pop'] ?? 0.0) * 100;
          }
        }
      } catch (e) {
        print('Forecast API Error: $e');
      }

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        return {
          'suhu': weatherData['main']['temp'],
          'kelembaban': weatherData['main']['humidity'],
          'kondisi': weatherData['weather'][0]['description'],
          'prakiraan_hujan': rainProb.toInt(),
          'icon': weatherData['weather'][0]['icon'],
        };
      } else {
        throw Exception('Gagal memuat cuaca');
      }
    } catch (e) {
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
