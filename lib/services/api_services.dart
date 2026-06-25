import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Domain Server
  static const String host = 'trs.viewdns.net'; 
  static const String authBaseUrl = 'http://$host:8084';
  static const String sensorBaseUrl = 'http://$host:8082';

  final String weatherApiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static const String city = 'Bandung';
  static const String weatherUrl = 'https://api.openweathermap.org/data/2.5';

  /// REGISTER
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Cek apakah responnya JSON atau teks biasa
        try {
          return json.decode(response.body);
        } catch (e) {
          // Jika bukan JSON (teks biasa), buat Map manual
          return {'message': response.body};
        }
      }

      throw Exception('Gagal registrasi: ${response.body}');
    } catch (e) {
      throw Exception('Error Register: $e');
    }
  }

  /// LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('email', data['email']);
        return data;
      }
      throw Exception('Email atau password salah');
    } catch (e) {
      throw Exception('Error Login: $e');
    }
  }

  /// CEK EMAIL EXISTS (Lupa Password)
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await http.get(Uri.parse('$authBaseUrl/auth/exists?email=$email'));
      // Mengembalikan true jika response body adalah "true" string
      return response.statusCode == 200 && response.body.toLowerCase() == 'true';
    } catch (e) {
      return false;
    }
  }

  /// RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword(String email, String password, String passwordAgain) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'passwordAgain': passwordAgain,
        }),
      );
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Gagal reset password');
    } catch (e) {
      throw Exception('Error Reset: $e');
    }
  }

  /// DATA DASHBOARD (LATEST)
  Future<Map<String, dynamic>> getLatestSensorData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final response = await http.get(
        Uri.parse('$sensorBaseUrl/api/sensor-data/latest'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Gagal memuat data dashboard');
    } catch (e) {
      throw Exception('Error Dashboard: $e');
    }
  }

  /// DATA HISTORY
  Future<Map<String, dynamic>> getSensorHistory({int limit = 5}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$sensorBaseUrl/api/sensor-data/history?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Gagal memuat riwayat');
    } catch (e) {
      throw Exception('Error History: $e');
    }
  }

  /// WEATHER DATA
  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      final response = await http.get(
        Uri.parse('$weatherUrl/weather?q=$city,id&appid=$weatherApiKey&units=metric&lang=id'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'suhu': data['main']['temp'],
          'kelembaban': data['main']['humidity'],
          'kondisi': data['weather'][0]['description'],
          'icon': data['weather'][0]['icon'],
        };
      }
      return _getFallbackWeatherData();
    } catch (e) {
      return _getFallbackWeatherData();
    }
  }

  Future<Map<String, dynamic>> _getFallbackWeatherData() async {
    return {'suhu': 0, 'kelembaban': 0, 'kondisi': 'Error', 'icon': '01d'};
  }
}
