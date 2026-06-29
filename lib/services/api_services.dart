import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class ApiService {
  // Domain Server
  static const String host = '192.168.1.15';
  static const String authBaseUrl = 'http://$host:8080';
  static const String sensorBaseUrl = 'http://$host:8080';

  final String weatherApiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
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
      final response = await http.get(
        Uri.parse('$authBaseUrl/auth/exists?email=$email'),
      );
      // Mengembalikan true jika response body adalah "true" string
      return response.statusCode == 200 &&
          response.body.toLowerCase() == 'true';
    } catch (e) {
      return false;
    }
  }

  /// RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String password,
    String passwordAgain,
  ) async {
    try {
      // Ganti .post menjadi .put
      final response = await http.put(
        Uri.parse('$authBaseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'passwordAgain': passwordAgain,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return json.decode(response.body);
        } catch (e) {
          return {'message': response.body};
        }
      }

      throw Exception(
        response.body.isNotEmpty ? response.body : 'Gagal reset password',
      );
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

  /// DEVICE SETTINGS (POST)
  Future<Map<String, dynamic>> saveDeviceSettings(String address, List<String> soilTypes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('$sensorBaseUrl/api/sensor-data/device-settings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'address': address,
          'soil_types': soilTypes,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return json.decode(response.body);
        } catch (e) {
          return {'message': response.body};
        }
      }
      throw Exception('Gagal menyimpan pengaturan perangkat: ${response.body}');
    } catch (e) {
      throw Exception('Error Device Settings: $e');
    }
  }


  /// GET DEVICE SETTINGS
  Future<Map<String, dynamic>> getDeviceSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$sensorBaseUrl/api/sensor-data/device-settings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Gagal memuat device settings: ${response.body}');
    } catch (e) {
      throw Exception('Error Get Device Settings: $e');
    }
  }

  /// UPDATE DEVICE SETTINGS (PUT)
  Future<Map<String, dynamic>> updateDeviceSettings(String address, List<String> soilTypes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.put(
        Uri.parse('$sensorBaseUrl/api/sensor-data/device-settings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'address': address,
          'soil_types': soilTypes,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return json.decode(response.body);
        } catch (e) {
          return {'message': response.body};
        }
      }
      throw Exception('Gagal memperbarui pengaturan perangkat: ${response.body}');
    } catch (e) {
      throw Exception('Error Update Device Settings: $e');
    }
  }

  Future<Position> _getUserLocation() async {
    final location = loc.Location();

    // Minta aktifkan GPS dengan dialog native Android
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location
          .requestService(); // munculkan dialog native
      if (!serviceEnabled) throw Exception('GPS tidak aktif');
    }

    // Cek permission lewat geolocator seperti biasa
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Izin lokasi ditolak permanen');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// SIRAM MANUAL
  Future<Map<String, dynamic>> sendManualWatering(String address, int duration, {int? potIndex}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final Map<String, dynamic> body = {
        'address': address,
        'command': 'PUMP_ON_MANUAL',
        'duration': duration,
      };

      // Tambahkan pot_index jika ada
      if (potIndex != null) body['pot_index'] = potIndex;

      final response = await http.post(
        Uri.parse('$sensorBaseUrl/api/sensor-data/command'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return json.decode(response.body);
        } catch (e) {
          return {'message': response.body};
        }
      }
      throw Exception('Gagal mengirim perintah: ${response.body}');
    } catch (e) {
      throw Exception('Error Manual Watering: $e');
    }
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      // Ambil koordinat user
      final position = await _getUserLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      final response = await http.get(
        Uri.parse(
          '$weatherUrl/weather?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric&lang=id',
        ),
      );

      if (response.statusCode != 200) return _getFallbackWeatherData();

      final data = json.decode(response.body);

      double rainProb = 0.0;
      try {
        final forecastResponse = await http.get(
          Uri.parse(
            '$weatherUrl/forecast?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric&lang=id',
          ),
        );

        if (forecastResponse.statusCode == 200) {
          final forecastData = json.decode(forecastResponse.body);
          final list = forecastData['list'] as List?;

          if (list != null && list.isNotEmpty) {
            double maxPop = 0.0;
            final checkCount = list.length < 3 ? list.length : 3;
            for (int i = 0; i < checkCount; i++) {
              final pop = (list[i]['pop'] as num?)?.toDouble() ?? 0.0;
              if (pop > maxPop) maxPop = pop;
            }
            rainProb = maxPop * 100;
          }
        }
      } catch (e) {
        debugPrint("Gagal mengambil data forecast: $e");
      }

      return {
        'suhu': data['main']['temp'],
        'kelembaban': data['main']['humidity'],
        'kondisi': data['weather'][0]['description'],
        'prakiraan_hujan': rainProb.round(),
        'icon': data['weather'][0]['icon'],
        'kota': data['name'], // bonus: nama kota otomatis dari API
      };
    } catch (e) {
      debugPrint("Error getWeatherData: $e");
      return _getFallbackWeatherData();
    }
  }

  Future<Map<String, dynamic>> _getFallbackWeatherData() async {
    return {
      'suhu': 0,
      'kelembaban': 0,
      'kondisi': 'Error',
      'prakiraan_hujan': 0, // Tambahkan baris ini
      'icon': '01d',
    };
  }
}
