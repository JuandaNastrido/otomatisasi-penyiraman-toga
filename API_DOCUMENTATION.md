# 🔌 API INTEGRATION GUIDE - TOGA PROJECT

## 📋 Daftar Isi
1. [Backend Lokal (Sensor Data)](#backend-lokal-sensor-data)
2. [OpenWeatherMap API](#openweathermap-api)
3. [Request/Response Examples](#requestresponse-examples)
4. [Error Handling](#error-handling)
5. [API Testing](#api-testing)

---

## 🔐 Authentication & Backend API

### Configuration
```dart
Base URL: http://192.168.1.15:8080
Protocol: HTTP/REST
Content-Type: application/json
Authorization: Bearer <token>
```

### 1) Register
**Method**: POST
**URL**: `http://192.168.1.15:8080/auth/register`

Body:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

### 2) Login
**Method**: POST
**URL**: `http://192.168.1.15:8080/auth/login`

Body:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

Success response:
```json
{
  "token": "jwt-token",
  "email": "user@example.com"
}
```

### 3) Check Email Exists
**Method**: GET
**URL**: `http://192.168.1.15:8080/auth/exists?email=user@example.com`

### 4) Reset Password
**Method**: PUT
**URL**: `http://192.168.1.15:8080/auth/reset-password`

Body:
```json
{
  "email": "user@example.com",
  "password": "newpassword",
  "passwordAgain": "newpassword"
}
```

### 5) Latest Sensor Data
**Method**: GET
**URL**: `http://192.168.1.15:8080/api/sensor-data/latest`

Headers:
```http
Authorization: Bearer <token>
```

### 6) Sensor History
**Method**: GET
**URL**: `http://192.168.1.15:8080/api/sensor-data/history?limit=5`

### 7) Device Settings
**Method**: GET / POST / PUT
**URL**: `http://192.168.1.15:8080/api/sensor-data/device-settings`

Body:
```json
{
  "address": "ESP-01",
  "soil_types": ["Sedang", "Kering", "Basah"]
}
```

### 8) Manual Watering Command
**Method**: POST
**URL**: `http://192.168.1.15:8080/api/sensor-data/command`

Body:
```json
{
  "address": "ESP-01",
  "command": "PUMP_ON_MANUAL",
  "duration": 10,
  "pot_index": 2
}
```

### Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Connection refused | Backend tidak running | Jalankan backend di port 8080 |
| 192.168.1.15 unreachable | Network/IP salah | Periksa konfigurasi lokal dan firewall |
| Token invalid | Session expired | Lakukan login ulang |

**Untuk Android Emulator**:
Gunakan IP host yang sesuai dengan mesin backend, biasanya `10.0.2.2` bila backend berjalan di mesin lokal.

---

## 🌤️ OpenWeatherMap API

### Configuration
```
Base URL: https://api.openweathermap.org/data/2.5
API Key: Dari .env file (OPENWEATHER_API_KEY)
Language: id (Indonesia)
Units: metric (Celsius)
```

### Endpoint 1: GET /weather (Current Weather)

**Purpose**: Mengambil kondisi cuaca saat ini

**URL**: 
```
GET https://api.openweathermap.org/data/2.5/weather?q=Jakarta,id&appid={API_KEY}&units=metric&lang=id
```

**Parameters**:
| Parameter | Type | Required | Example |
|-----------|------|----------|---------|
| q | string | Yes | Jakarta,id |
| appid | string | Yes | your_api_key |
| units | string | No | metric |
| lang | string | No | id |

**Success Response (Status 200)**:
```json
{
  "coord": {
    "lon": 106.8456,
    "lat": -6.2088
  },
  "weather": [
    {
      "id": 803,
      "main": "Clouds",
      "description": "Berawan",
      "icon": "04d"
    }
  ],
  "main": {
    "temp": 28.5,
    "feels_like": 31.2,
    "temp_min": 27.1,
    "temp_max": 29.8,
    "pressure": 1012,
    "humidity": 65
  },
  "visibility": 10000,
  "wind": {
    "speed": 4.5,
    "deg": 230
  },
  "clouds": {
    "all": 75
  },
  "dt": 1718445000,
  "sys": {
    "type": 2,
    "id": 2001249,
    "country": "ID",
    "sunrise": 1718426400,
    "sunset": 1718469600
  },
  "timezone": 25200,
  "id": 1642911,
  "name": "Jakarta",
  "cod": 200
}
```

### Endpoint 2: GET /forecast (Forecast & Rain Probability)

**Purpose**: Mengambil prakiraan cuaca dan probabilitas hujan

**URL**:
```
GET https://api.openweathermap.org/data/2.5/forecast?q=Jakarta,id&appid={API_KEY}&units=metric&cnt=8&lang=id
```

**Parameters**:
| Parameter | Type | Required | Example |
|-----------|------|----------|---------|
| q | string | Yes | Jakarta,id |
| appid | string | Yes | your_api_key |
| units | string | No | metric |
| cnt | integer | No | 8 |
| lang | string | No | id |

**cnt**: Jumlah data forecast yang dikembalikan (default: 40, max per jam)

**Success Response (Status 200)**:
```json
{
  "cod": "200",
  "message": 0,
  "cnt": 8,
  "list": [
    {
      "dt": 1718448000,
      "main": {
        "temp": 28.5,
        "feels_like": 31.2,
        "temp_min": 27.1,
        "temp_max": 28.5,
        "pressure": 1012,
        "humidity": 65
      },
      "weather": [
        {
          "id": 803,
          "main": "Clouds",
          "description": "Berawan",
          "icon": "04d"
        }
      ],
      "clouds": {
        "all": 75
      },
      "wind": {
        "speed": 4.5,
        "deg": 230
      },
      "visibility": 10000,
      "pop": 0.25,
      "sys": {
        "pod": "d"
      },
      "dt_txt": "2024-06-15 13:00:00"
    },
    // ... lebih banyak data forecast
  ],
  "city": {
    "id": 1642911,
    "name": "Jakarta",
    "coord": {
      "lat": -6.2088,
      "lon": 106.8456
    },
    "country": "ID",
    "population": 8259266,
    "timezone": 25200,
    "sunrise": 1718426400,
    "sunset": 1718469600
  }
}
```

**Penjelasan `pop` (Probability of Precipitation)**:
- `pop`: Float antara 0.0 - 1.0
- 0.0 = 0% kemungkinan hujan
- 1.0 = 100% kemungkinan hujan
- Konversi ke persen: `pop * 100`

### Weather Icon Mapping

| Icon | Kondisi | Malam |
|------|---------|-------|
| 01d/01n | Clear sky | ☀️/🌙 |
| 02d/02n | Few clouds | ⛅/☁️ |
| 03d/03n | Scattered clouds | ☁️ |
| 04d/04n | Broken clouds | ☁️ |
| 09d/09n | Shower rain | 🌧️ |
| 10d/10n | Rain | 🌧️ |
| 11d/11n | Thunderstorm | ⛈️ |
| 13d/13n | Snow | ❄️ |
| 50d/50n | Mist | 🌫️ |

### Dart Implementation

```dart
Future<Map<String, dynamic>> getWeatherData() async {
  try {
    // 1. Ambil cuaca saat ini
    final weatherResponse = await http.get(
      Uri.parse('$weatherUrl/weather?q=$city,id&appid=$weatherApiKey&units=metric&lang=id'),
    ).timeout(const Duration(seconds: 10));

    // 2. Ambil prakiraan untuk probabilitas hujan
    double rainProb = 0.0;
    try {
      final forecastResponse = await http.get(
        Uri.parse('$weatherUrl/forecast?q=$city,id&appid=$weatherApiKey&units=metric&cnt=8&lang=id'),
      ).timeout(const Duration(seconds: 10));

      if (forecastResponse.statusCode == 200) {
        final forecastData = json.decode(forecastResponse.body);
        if (forecastData['list'] != null && forecastData['list'].isNotEmpty) {
          rainProb = (forecastData['list'][0]['pop'] ?? 0.0) * 100;
        }
      }
    } catch (e) {
      print('Forecast fetch ignored: $e');
    }

    // 3. Process cuaca utama
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
      throw Exception('Weather API error: ${weatherResponse.statusCode}');
    }
  } catch (e) {
    print('Weather error: $e');
    return _getFallbackWeatherData();
  }
}
```

---

## 📤 Request/Response Examples

### Example 1: Fetch Sensor Data

**Request**:
```bash
curl -X GET http://172.20.12.1:3000/api/data \
  -H "Content-Type: application/json"
```

**Response**:
```json
[
  {
    "id": 1,
    "temperature": 28.5,
    "humidity": 65,
    "soilMoisture": 45
  }
]
```

### Example 2: Fetch Current Weather

**Request**:
```bash
curl -X GET "https://api.openweathermap.org/data/2.5/weather?q=Jakarta,id&appid=YOUR_KEY&units=metric&lang=id"
```

**Response**:
```json
{
  "main": {
    "temp": 28.5,
    "humidity": 65
  },
  "weather": [
    {
      "main": "Clouds",
      "description": "Berawan",
      "icon": "04d"
    }
  ]
}
```

### Example 3: Fetch Weather Forecast

**Request**:
```bash
curl -X GET "https://api.openweathermap.org/data/2.5/forecast?q=Jakarta,id&appid=YOUR_KEY&units=metric&cnt=8&lang=id"
```

**Response Fragment**:
```json
{
  "list": [
    {
      "dt": 1718448000,
      "pop": 0.25,
      "main": {
        "temp": 28.5
      }
    }
  ]
}
```

---

## 🚨 Error Handling

### HTTP Status Codes

| Status | Meaning | Action |
|--------|---------|--------|
| 200 | OK | Process data normally |
| 400 | Bad Request | Check parameters |
| 401 | Unauthorized | Check API key |
| 403 | Forbidden | Check permissions |
| 404 | Not Found | Check endpoint URL |
| 429 | Too Many Requests | Rate limit hit, wait |
| 500 | Server Error | Backend error, retry later |
| 503 | Service Unavailable | API down, use fallback |

### Error Handling Pattern

```dart
Future<T> safeApiCall<T>(
  Future<T> Function() apiCall,
  T Function() fallback,
) async {
  try {
    return await apiCall();
  } on SocketException {
    print('Network error');
    return fallback();
  } on TimeoutException {
    print('Request timeout');
    return fallback();
  } on FormatException {
    print('JSON parsing error');
    return fallback();
  } catch (e) {
    print('Unknown error: $e');
    return fallback();
  }
}
```

### Common Errors

#### Error: 401 Unauthorized
```
Cause: API key invalid atau expired
Solution:
  1. Verify API key di .env
  2. Check OpenWeatherMap dashboard
  3. Generate new API key
```

#### Error: 429 Too Many Requests
```
Cause: Rate limit tercapai (free tier: 60/min)
Solution:
  1. Implement caching
  2. Reduce API call frequency
  3. Upgrade ke paid plan
```

#### Error: Network Timeout
```
Cause: Koneksi lambat atau server unreachable
Solution:
  1. Increase timeout duration
  2. Check network connectivity
  3. Check firewall settings
```

---

## 🧪 API Testing

### Testing Tools
- **Postman**: GUI-based API testing
- **cURL**: Command-line testing
- **Advanced REST Client**: Chrome extension
- **Thunder Client**: VS Code extension

### Test Cases

#### Test 1: Sensor Data Fetch
```bash
# Test sensor API
curl -X GET http://172.20.12.1:3000/api/data \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"

# Expected: 200
```

#### Test 2: Weather Data Fetch
```bash
# Test current weather
curl -X GET "https://api.openweathermap.org/data/2.5/weather?q=Jakarta,id&appid=YOUR_API_KEY&units=metric&lang=id" \
  -w "\nStatus: %{http_code}\n"

# Expected: 200
# Check response contains: main, weather, city
```

#### Test 3: Forecast Data
```bash
# Test forecast
curl -X GET "https://api.openweathermap.org/data/2.5/forecast?q=Jakarta,id&appid=YOUR_API_KEY&units=metric&cnt=8&lang=id" \
  -w "\nStatus: %{http_code}\n"

# Expected: 200
# Check response contains: list array with pop field
```

### Unit Testing dalam Flutter

```dart
// test/api_services_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:toga/services/api_services.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ApiService Tests', () {
    test('getSensorData returns list', () async {
      final apiService = ApiService();
      try {
        final result = await apiService.getSensorData();
        expect(result, isA<List>());
      } catch (e) {
        print('API not available: $e');
      }
    });

    test('getWeatherData returns map', () async {
      final apiService = ApiService();
      try {
        final result = await apiService.getWeatherData();
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('suhu'), true);
      } catch (e) {
        print('Weather API not available: $e');
      }
    });
  });
}
```

Run tests:
```bash
flutter test
```

---

## 🔐 Security Best Practices

### 1. API Key Management
```dart
// ✅ CORRECT - Use .env
final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

// ❌ WRONG - Hardcoded
final String apiKey = 'sk_live_123456789';
```

### 2. Request/Response Validation
```dart
// Validate response
if (response.statusCode == 200) {
  final data = json.decode(response.body);
  
  // Validate required fields
  if (!data.containsKey('main')) {
    throw FormatException('Missing required field: main');
  }
} else {
  throw HttpException('HTTP ${response.statusCode}');
}
```

### 3. HTTPS Only
```dart
// Always use HTTPS for sensitive data
final url = 'https://api.openweathermap.org/data/2.5/weather...';
```

### 4. Timeout Implementation
```dart
final response = await http.get(uri).timeout(
  const Duration(seconds: 10),
  onTimeout: () => throw TimeoutException('Request timeout'),
);
```

---

## 📊 Rate Limiting & Caching

### Caching Strategy
```dart
class CachedApiService {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTimes = {};
  static const Duration cacheDuration = Duration(minutes: 5);

  Future<Map<String, dynamic>> getWeatherDataCached() async {
    final key = 'weather_data';
    
    // Check cache validity
    if (_cache.containsKey(key)) {
      final cacheTime = _cacheTimes[key] ?? DateTime.now();
      if (DateTime.now().difference(cacheTime) < cacheDuration) {
        return _cache[key] ?? {};
      }
    }
    
    // Fetch fresh data
    final data = await getWeatherData();
    _cache[key] = data;
    _cacheTimes[key] = DateTime.now();
    return data;
  }
}
```

---

**Last Updated**: 15 Juni 2024
