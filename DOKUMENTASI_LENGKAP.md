# 📱 DOKUMENTASI LENGKAP PROYEK TOGA

## 📋 Daftar Isi
1. [Overview Proyek](#overview-proyek)
2. [Struktur Folder](#struktur-folder)
3. [Teknologi & Dependencies](#teknologi--dependencies)
4. [Setup & Instalasi](#setup--instalasi)
5. [Fitur-Fitur Utama](#fitur-fitur-utama)
6. [Routing & Navigasi](#routing--navigasi)
7. [Penjelasan Screens](#penjelasan-screens)
8. [Services & API Integration](#services--api-integration)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)

---

## 🌱 Overview Proyek

### Nama Proyek
**TOGA - Smart Watering System**

### Deskripsi
Toga adalah aplikasi mobile Flutter untuk sistem pengairan otomatis tanaman. Aplikasi ini mengintegrasikan:
- Sistem autentikasi pengguna (Login, Register, Forgot Password)
- Data sensor real-time dari backend
- Data cuaca dari OpenWeatherMap API berbasis lokasi GPS
- Riwayat penggunaan sistem per perangkat dan pot
- Pengaturan perangkat, jenis tanah, dan nama tanaman per pot
- Fitur siram manual dengan durasi dan target pot

### Target Platform
- 🤖 **Android** (API Level: minimum sesuai Flutter support)
- 🍎 **iOS** (iOS 11.0+)

### Versi
- **App Version**: 1.0.0+1
- **Flutter SDK**: ^3.11.4

---

## 📁 Struktur Folder

```
toga/
├── 📄 pubspec.yaml              # Konfigurasi Flutter & Dependencies
├── 📄 pubspec.lock              # Lock file untuk dependency versions
├── 📄 analysis_options.yaml     # Konfigurasi linting & analisis kode
├── 📄 README.md                 # Dokumentasi dasar
├── 📄 toga.iml                  # IntelliJ IDE configuration
│
├── 📂 android/                  # Kode native Android
│   ├── app/
│   │   ├── build.gradle.kts     # Gradle build script
│   │   └── src/
│   │       ├── main/            # Source code utama
│   │       ├── debug/           # Debug configuration
│   │       └── profile/         # Profile configuration
│   ├── gradle/                  # Gradle wrapper
│   └── settings.gradle.kts
│
├── 📂 ios/                      # Kode native iOS
│   ├── Runner/                  # Aplikasi utama iOS
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── Assets.xcassets/
│   ├── Runner.xcworkspace/
│   └── Flutter/                 # Konfigurasi Flutter iOS
│
├── 📂 assets/                   # Aset aplikasi
│   └── logo.jpeg               # Logo aplikasi
│
├── 📂 lib/                      # Source code utama Dart/Flutter
│   ├── 📄 main.dart             # Entry point aplikasi
│   │
│   ├── 📂 screens/              # Layar (UI Pages)
│   │   ├── splash_screen.dart   # Splash screen
│   │   ├── login_screen.dart    # Halaman login
│   │   ├── register_screen.dart # Halaman registrasi
│   │   ├── forgot_password_screen.dart  # Halaman lupa password
│   │   ├── main_screen.dart     # Halaman utama dengan bottom nav
│   │   ├── dasboard_screen.dart # Dashboard/Beranda
│   │   ├── settings_screen.dart # Pengaturan
│   │   └── history_screen.dart  # Riwayat
│   │
│   └── 📂 services/             # Business Logic & API
│       └── api_services.dart    # Integrasi API Backend & OpenWeatherMap
│
├── 📂 test/                     # Unit & Widget Testing
│   └── widget_test.dart
│
├── 📂 build/                    # Build output (auto-generated)
│   ├── app/
│   ├── jni/
│   ├── jni_flutter/
│   └── ...
│
└── 📄 .env                      # Environment variables (API Keys)
```

---

## 🔧 Teknologi & Dependencies

### Versi Flutter & Dart
```yaml
SDK Flutter: ^3.11.4
```

### Dependencies Utama

| Package | Versi | Fungsi |
|---------|-------|--------|
| **flutter** | SDK | Framework utama |
| **cupertino_icons** | ^1.0.8 | iOS style icons |
| **google_fonts** | ^6.2.1 | Custom fonts dari Google Fonts |
| **http** | ^1.1.0 | HTTP client untuk API calls |
| **intl** | ^0.19.0 | Internasionalisasi & formatting |
| **shared_preferences** | ^2.2.2 | Penyimpanan data lokal sederhana |
| **flutter_dotenv** | ^6.0.1 | Manajemen environment variables |

### Dev Dependencies
```yaml
flutter_test          # Testing framework bawaan Flutter
flutter_lints: ^6.0.0 # Linting dan code quality checks
```

### Material Design
Aplikasi menggunakan Material 3 design system dengan tema hijau (`Color(0xFF2E7D32)`).

---

## 🚀 Setup & Instalasi

### Prerequisites
- Flutter SDK (versi 3.11.4 atau lebih baru)
- Dart SDK (included dengan Flutter)
- Android Studio / Xcode (untuk emulator/simulator)
- Git (untuk version control)

### Langkah-Langkah Instalasi

#### 1. Clone Repository
```bash
git clone <repository_url>
cd toga
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Setup Environment Variables
Buat file `.env` di root project:
```env
OPENWEATHER_API_KEY=your_api_key_here
```

Dapatkan API key gratis dari [OpenWeatherMap](https://openweathermap.org/api)

#### 4. Verifikasi Setup
```bash
flutter doctor
```

Pastikan semua items menunjukkan ✓ (terutama Android Toolchain dan Xcode jika di macOS)

#### 5. Run Aplikasi

**Development Mode:**
```bash
flutter run
```

**Release Build (Android):**
```bash
flutter build apk
```

**Release Build (iOS):**
```bash
flutter build ios
```

---

## ✨ Fitur-Fitur Utama

### 1. **Autentikasi Pengguna** 🔐
- **Login**: Pengguna dapat login dengan kredensial
- **Register**: Pendaftaran akun baru
- **Forgot Password**: Reset password jika lupa
- **Session Management**: Menggunakan SharedPreferences

### 2. **Dashboard/Beranda** 📊
- Menampilkan data sensor real-time dari backend
- Integrasi cuaca real-time dari OpenWeatherMap berbasis GPS
- Monitoring kondisi tanaman dan status perangkat
- Quick action untuk siram manual per perangkat/pot

### 3. **Pengaturan** ⚙️
- Konfigurasi perangkat dan jenis tanah per pot
- Pengelolaan nama tanaman per pot
- Pengaturan kelompok kelembapan
- Penyimpanan preferensi lokal via SharedPreferences

### 4. **Riwayat** 📜
- Log aktivitas perangkat dan pot
- Grafik kelembapan per pot
- Data historis sensor terbaru
- Refresh data manual

### 5. **API Integration** 🔌
- **Backend**: Auth + sensor + device settings (IP: 192.168.1.15:8080)
- **OpenWeatherMap API**: Data cuaca & prediksi hujan
- **Error Handling**: Fallback data jika API tidak tersedia

---

## 🗺️ Routing & Navigasi

### Route Configuration (main.dart)
```dart
routes: {
  '/': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/forgot-password': (context) => const ForgotPasswordScreen(),
  '/home': (context) => const MainScreen(),
}
```

### Flow Navigasi
```
Splash Screen (/)
    ↓
Login Screen (/login)
    ├→ Register Screen (/register)
    ├→ Forgot Password Screen (/forgot-password)
    └→ Main Screen (/home)
            ├→ Dashboard Screen
            ├→ Settings Screen
            └→ History Screen
```

### Navigasi Bottom Tab
Di MainScreen, terdapat 3 tab yang dapat diakses:
1. **Beranda** - Dashboard dengan data sensor & cuaca
2. **Pengaturan** - Settings aplikasi
3. **Riwayat** - History & statistik

---

## 📺 Penjelasan Screens

### 1. **SplashScreen** (`splash_screen.dart`)
**Fungsi**: 
- Menampilkan splash saat aplikasi pertama kali dibuka
- Validasi session pengguna
- Redirect ke login atau home

**Durasi**: Biasanya 2-3 detik

### 2. **LoginScreen** (`login_screen.dart`)
**Layout**:
- Logo TOGA dan subtitle "Smart Watering System"
- Form input email/username
- Form input password
- Tombol login
- Link ke register & forgot password

**Features**:
- Input validation
- Error handling
- Loading indicator
- Password visibility toggle

### 3. **RegisterScreen** (`register_screen.dart`)
**Layout**:
- Form input email
- Form input nama lengkap
- Form input password
- Form input konfirmasi password
- Tombol register

**Validasi**:
- Email format validation
- Password strength check
- Password confirmation match

### 4. **ForgotPasswordScreen** (`forgot_password_screen.dart`)
**Flow**:
1. Input email untuk verifikasi
2. Verifikasi melalui OTP/Link
3. Input password baru
4. Konfirmasi perubahan password

### 5. **MainScreen** (`main_screen.dart`)
**Fungsi**: 
- Container utama untuk navigasi bottom tab
- Mengelola state index tab yang dipilih
- Host untuk 3 screen utama

**Components**:
```dart
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(label: "Beranda"),    // Index 0
    BottomNavigationBarItem(label: "Pengaturan"), // Index 1
    BottomNavigationBarItem(label: "Riwayat"),    // Index 2
  ]
)
```

### 6. **DashboardScreen** (`dasboard_screen.dart`)
**Fitur Utama**:
- **Real-time Sensor Data**: 
  - Suhu
  - Kelembaban
  - Status pompa
  - Penggunaan air

- **Weather Integration**:
  - Suhu saat ini
  - Kondisi cuaca
  - Probabilitas hujan
  - Icon cuaca

- **Quick Controls**:
  - ON/OFF pompa
  - Manual watering
  - Auto mode toggle

**API Calls**:
- `getSensorData()` - Ambil data sensor
- `getWeatherData()` - Ambil data cuaca

### 7. **SettingsScreen** (`settings_screen.dart`)
**Opsi Pengaturan**:
- Pengaturan jadwal watering
- Sensitivitas sensor
- Notifikasi alert
- Bahasa aplikasi
- Tentang aplikasi
- Logout

### 8. **HistoryScreen** (`history_screen.dart`)
**Menampilkan**:
- Timeline pengairan
- Durasi watering
- Volume air yang digunakan
- Kondisi cuaca saat watering
- Filter berdasarkan tanggal

---

## 🔌 Services & API Integration

### File: `lib/services/api_services.dart`

#### Class: `ApiService`
Menangani semua komunikasi dengan backend dan API eksternal.

#### Constants
```dart
static const String baseUrl = 'http://172.20.12.1:3000';
static const String city = 'Jakarta';
static const String weatherUrl = 'https://api.openweathermap.org/data/2.5';
```

#### Methods

##### 1. `getSensorData()` - Ambil Data Sensor
**Endpoint**: `GET http://172.20.12.1:3000/api/data`

**Return Type**: `Future<List<dynamic>>`

**Response Example**:
```json
[
  {
    "id": 1,
    "temperature": 28.5,
    "humidity": 65,
    "pump_status": true,
    "water_level": 80,
    "timestamp": "2024-06-15T10:30:00"
  }
]
```

**Error Handling**:
- Status code check (200 = success)
- Exception throw jika gagal
- Console logging untuk debugging

##### 2. `getWeatherData()` - Ambil Data Cuaca
**Endpoints**: 
- Current Weather: `https://api.openweathermap.org/data/2.5/weather`
- Forecast: `https://api.openweathermap.org/data/2.5/forecast`

**Parameters**:
- `q`: Kota (Jakarta)
- `appid`: API Key dari .env
- `units`: metric (Celsius)
- `lang`: id (Bahasa Indonesia)

**Return Type**: `Future<Map<String, dynamic>>`

**Response Example**:
```json
{
  "suhu": 28.5,
  "kelembaban": 65,
  "kondisi": "Berawan",
  "prakiraan_hujan": 25,
  "icon": "04d"
}
```

**Fitur Khusus**:
- Mengambil probabilitas hujan dari forecast data
- Error logging tanpa crash aplikasi
- Fallback data jika koneksi terputus

##### 3. `_getFallbackWeatherData()` - Data Cadangan
Mengembalikan data default jika OpenWeatherMap tidak accessible:
```dart
{
  'suhu': 0,
  'kelembaban': 0,
  'kondisi': 'Data tidak tersedia',
  'prakiraan_hujan': 0,
  'icon': '00d'
}
```

#### Error Handling Strategy
```dart
try {
  // API call
} catch (e) {
  print('Error: $e');
  // Return fallback data atau throw exception
}
```

---

## 🎨 UI/UX & Styling

### Color Scheme
```dart
Primary Green: Color(0xFF2E7D32)   // Material Green 700
Light Green: Colors.green[50]
Text Color: Colors.black87 / Colors.white
```

### Typography
**Font Family**: Google Fonts Poppins
```dart
GoogleFonts.poppins(
  fontSize: 24,
  fontWeight: FontWeight.bold,
)
```

### Icons
- Material Icons (built-in)
- Cupertino Icons (iOS style)

### Responsive Design
Menggunakan:
- `MediaQuery` untuk ukuran layar
- `SingleChildScrollView` untuk overflow handling
- `Column` & `Row` dengan `Expanded` untuk flexibility

---

## 📝 Best Practices

### 1. **State Management**
- Gunakan `StatefulWidget` untuk screen dengan state
- Gunakan `StatelessWidget` untuk static UI
- Pertimbangkan `Provider` atau `Riverpod` untuk state kompleks

### 2. **API Calls**
- Selalu wrap dengan try-catch
- Gunakan environment variables untuk API keys (via .env)
- Implement timeout untuk HTTP requests
- Log error untuk debugging

### 3. **Error Handling**
```dart
// ✅ BAIK
try {
  final data = await apiService.getData();
} catch (e) {
  print('Error: $e');
  _showErrorDialog(context, e.toString());
}

// ❌ HINDARI
var data = await apiService.getData(); // Bisa crash
```

### 4. **Widget Organization**
- Buat widget kecil yang reusable
- Pisahkan business logic dari UI
- Gunakan custom widgets untuk UI patterns yang berulang

### 5. **Performance**
- Gunakan `const` constructor untuk widget statis
- Implement caching untuk data API
- Gunakan `ListView.builder` untuk list panjang

### 6. **Code Style**
- Follow Dart conventions & Flutter style guide
- Gunakan meaningful variable names
- Add comments untuk logic kompleks
- Format code dengan `flutter format`

---

## 🐛 Troubleshooting

### Issue 1: Build Gagal - Dependencies Not Found
**Solusi**:
```bash
flutter pub clean
flutter pub get
flutter pub upgrade
```

### Issue 2: API Connection Error (172.20.12.1)
**Penyebab**: Backend lokal tidak running atau IP salah

**Solusi**:
1. Pastikan backend running di IP 172.20.12.1:3000
2. Untuk emulator Android, gunakan IP host: 10.0.2.2:3000
3. Check firewall settings

**Update di api_services.dart**:
```dart
// Untuk emulator Android
static const String baseUrl = 'http://10.0.2.2:3000';

// Untuk device fisik
static const String baseUrl = 'http://172.20.12.1:3000';
```

### Issue 3: OpenWeatherMap API Error
**Penyebab**: API key tidak valid atau API limit tercapai

**Solusi**:
1. Verify API key di .env
2. Check API key aktif di OpenWeatherMap dashboard
3. Verify rate limit (free tier: 60 calls/min)

### Issue 4: .env File Not Loaded
**Error**: `flutter_dotenv` tidak membaca .env

**Solusi**:
1. Pastikan file `.env` exist di root project
2. Verifikasi path di main.dart: `await dotenv.load(fileName: ".env");`
3. Add ke pubspec.yaml:
```yaml
flutter:
  assets:
    - .env
```

### Issue 5: Widget Not Rebuilding
**Penyebab**: State tidak di-update dengan benar

**Solusi**:
```dart
// ✅ BENAR - gunakan setState
setState(() {
  _variable = newValue;
});

// Atau gunakan reactive state management (Provider, Riverpod)
```

### Issue 6: Debug Build Terlalu Besar
**Solusi** - Build release mode:
```bash
flutter build apk --release
flutter build ios --release
```

---

## 📚 Resources & Referensi

### Official Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)

### Packages Used
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [HTTP Package](https://pub.dev/packages/http)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)

### API Documentation
- [OpenWeatherMap API](https://openweathermap.org/api)
- [REST API Best Practices](https://restfulapi.net/)

---

## 🔐 Security Considerations

### 1. **Sensitive Data**
- Jangan hardcode API keys → gunakan .env
- Jangan store password di SharedPreferences → gunakan secure storage
- Implement HTTPS untuk API calls

### 2. **Input Validation**
- Validasi semua user input sebelum dikirim ke API
- Sanitize data yang diterima dari API
- Check response status code

### 3. **Authentication**
- Implement token-based auth (JWT)
- Add bearer token ke HTTP headers
- Implement refresh token mechanism

### 4. **.env Security**
Jangan commit `.env` ke git:
```
# .gitignore
.env
```

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Main Screens | 8 |
| Services | 1 (ApiService) |
| Dependencies | 6 |
| Dev Dependencies | 2 |
| Min Flutter Version | 3.11.4 |
| Target Platforms | Android, iOS |

---

## 📞 Support & Contact

Untuk pertanyaan atau issues, silakan:
1. Check GitHub Issues
2. Email development team
3. Review documentation ini

---

**Terakhir diupdate**: 15 Juni 2024
**Versi Dokumentasi**: 1.0.0
**Status**: ✅ Active Development
