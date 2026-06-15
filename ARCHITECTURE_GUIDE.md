# 🏛️ ARCHITECTURE & QUICK REFERENCE - TOGA PROJECT

## 📋 Daftar Isi
1. [Application Architecture](#application-architecture)
2. [Data Flow Diagram](#data-flow-diagram)
3. [Quick Reference](#quick-reference)
4. [File Location Index](#file-location-index)
5. [Common Commands](#common-commands)

---

## 🏛️ Application Architecture

### Layered Architecture

```
┌─────────────────────────────────────┐
│         PRESENTATION LAYER          │
│  (Screens / UI Widgets)             │
│  - LoginScreen                      │
│  - DashboardScreen                  │
│  - SettingsScreen                   │
│  - HistoryScreen                    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         SERVICE LAYER               │
│  (Business Logic & API Calls)       │
│  - ApiService                       │
│  - AuthService (future)             │
│  - NotificationService (future)     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         DATA LAYER                  │
│  (External APIs & Local Storage)    │
│  - Backend API (172.20.12.1:3000)   │
│  - OpenWeatherMap API               │
│  - SharedPreferences                │
└─────────────────────────────────────┘
```

### Component Diagram

```
┌─────────────────────────────────────┐
│         Flutter App                 │
│  ┌────────────────────────────────┐ │
│  │      Navigation Router         │ │
│  │  (Routes Management)           │ │
│  └────────────┬───────────────────┘ │
│               │                      │
│  ┌────────────▼────────────────────┐ │
│  │      Screen Layer               │ │
│  │  ┌──────────────────────────┐   │ │
│  │  │ SplashScreen             │   │ │
│  │  ├──────────────────────────┤   │ │
│  │  │ LoginScreen              │   │ │
│  │  ├──────────────────────────┤   │ │
│  │  │ MainScreen (Tab Host)    │   │ │
│  │  │ ├─ DashboardScreen      │   │ │
│  │  │ ├─ SettingsScreen       │   │ │
│  │  │ └─ HistoryScreen        │   │ │
│  │  └──────────────────────────┘   │ │
│  └────────────┬───────────────────┘ │
│               │                      │
│  ┌────────────▼────────────────────┐ │
│  │      Service Layer              │ │
│  │  ┌──────────────────────────┐   │ │
│  │  │ ApiService               │   │ │
│  │  │ ├─ getSensorData()       │   │ │
│  │  │ └─ getWeatherData()      │   │ │
│  │  └──────────────────────────┘   │ │
│  └────────────┬───────────────────┘ │
│               │                      │
│  ┌────────────▼────────────────────┐ │
│  │   External Integrations         │ │
│  │   ├─ Backend API (REST)         │ │
│  │   ├─ OpenWeatherMap API         │ │
│  │   └─ SharedPreferences (Local)  │ │
│  └────────────────────────────────┘ │
└─────────────────────────────────────┘
```

---

## 📊 Data Flow Diagram

### User Login Flow

```
┌──────────────┐
│ SplashScreen │
└──────┬───────┘
       │ Auto-redirect
       ▼
┌──────────────────────┐
│  LoginScreen         │
│  [Email Input]       │
│  [Password Input]    │
└──────┬───────────────┘
       │ User enters credentials
       │
       ▼
┌──────────────────────┐
│  ApiService.login()  │
│  POST /api/login     │
└──────┬───────────────┘
       │
       ├─ Success ────┐
       │              │
       │              ▼
       │         ┌─────────────┐
       │         │ Save token  │
       │         │ SharedPrefs │
       │         └─────┬───────┘
       │               │
       │               ▼
       │         ┌─────────────┐
       │         │ MainScreen  │
       │         │ (DashBoard) │
       │         └─────────────┘
       │
       └─ Error ──────┐
                      │
                      ▼
                 ┌─────────────┐
                 │ Show Error  │
                 │ Dialog      │
                 └─────────────┘
```

### Dashboard Data Fetch Flow

```
┌─────────────────────┐
│  DashboardScreen    │
│  initState() called │
└──────┬──────────────┘
       │
       ├─ Parallel Calls ─────┬──────────┐
       │                      │          │
       ▼                      ▼          ▼
   ┌──────────────┐    ┌──────────────┐
   │ Fetch Sensor │    │ Fetch Weather│
   │    Data      │    │    Data      │
   └──────┬───────┘    └──────┬───────┘
          │                   │
          │ Call              │ Call
          │ getSensorData()   │ getWeatherData()
          │                   │
          ▼                   ▼
   ┌──────────────────────────────────────┐
   │  API Service                         │
   │  ├─ GET /api/data                    │
   │  └─ GET /weather (OpenWeatherMap)    │
   └──────┬───────────────┬───────────────┘
          │               │
          ▼               ▼
   ┌──────────────┐ ┌────────────────┐
   │ Sensor Data  │ │ Weather Data   │
   └──────┬───────┘ └────────┬───────┘
          │                  │
          └────────┬─────────┘
                   │
                   ▼
          ┌─────────────────┐
          │  setState()     │
          │  Update UI      │
          └─────────────────┘
```

---

## 🔍 Quick Reference

### File Quick Links

| Function | File | Line |
|----------|------|------|
| App Entry Point | `lib/main.dart` | 1 |
| Route Definition | `lib/main.dart` | 18 |
| Sensor API | `lib/services/api_services.dart` | 10 |
| Weather API | `lib/services/api_services.dart` | 35 |
| Dashboard UI | `lib/screens/dasboard_screen.dart` | 1 |
| Login Screen | `lib/screens/login_screen.dart` | 1 |

### Key Classes & Methods

```dart
// Main Configuration
MyApp                    # App configuration & theme
MyApp.build()           # Build app widget tree

// Screens
SplashScreen            # Splash screen (2-3 sec)
LoginScreen             # Login with email/password
RegisterScreen          # New user registration
ForgotPasswordScreen    # Password recovery
MainScreen              # Main app container (bottom nav)
DashboardScreen         # Sensor & weather display
SettingsScreen          # App settings & profile
HistoryScreen           # Usage history & stats

// Services
ApiService              # API communication
getSensorData()         # Fetch sensor readings
getWeatherData()        # Fetch weather data
_getFallbackWeatherData() # Fallback if API fails

// External APIs
Backend: 172.20.12.1:3000  # Local sensor API
OpenWeatherMap API      # Weather data provider
SharedPreferences       # Local data storage
```

### Important Constants

```dart
// Colors
PRIMARY_GREEN     = Color(0xFF2E7D32)
LIGHT_GREEN       = Colors.green[50]

// API
BACKEND_URL       = 'http://172.20.12.1:3000'
WEATHER_API_URL   = 'https://api.openweathermap.org/data/2.5'
CITY              = 'Jakarta'
API_TIMEOUT       = 10 seconds

// Routes
SPLASH_ROUTE      = '/'
LOGIN_ROUTE       = '/login'
REGISTER_ROUTE    = '/register'
FORGOT_PW_ROUTE   = '/forgot-password'
HOME_ROUTE        = '/home'

// UI
FONT_FAMILY       = 'Poppins'
BORDER_RADIUS     = 40
BOTTOM_SHEET_HEIGHT = 40%
```

---

## 📑 File Location Index

### Core Files
```
pubspec.yaml              Project dependencies & config
pubspec.lock              Lock file (version pinning)
analysis_options.yaml     Linting & code analysis rules
.env                      Environment variables (API keys)
.gitignore                Git ignore patterns
```

### Main Code
```
lib/main.dart
  ├─ Entry point
  ├─ App configuration
  ├─ Theme setup
  └─ Route definition

lib/screens/
  ├─ splash_screen.dart
  ├─ login_screen.dart
  ├─ register_screen.dart
  ├─ forgot_password_screen.dart
  ├─ main_screen.dart (tab host)
  ├─ dasboard_screen.dart
  ├─ settings_screen.dart
  └─ history_screen.dart

lib/services/
  └─ api_services.dart (all API calls)

lib/assets/
  └─ logo.jpeg
```

### Build & Configuration
```
android/
  ├─ build.gradle.kts       (Root build config)
  ├─ settings.gradle.kts
  └─ app/
      └─ src/
          ├─ main/
          ├─ debug/
          └─ profile/

ios/
  ├─ Runner/
  │   ├─ AppDelegate.swift
  │   ├─ Info.plist
  │   └─ Assets.xcassets/
  ├─ Runner.xcworkspace/
  └─ Flutter/

build/
  ├─ app/               (Android builds)
  ├─ ios/               (iOS builds)
  └─ ...generated files
```

### Testing
```
test/
  └─ widget_test.dart
```

---

## 🚀 Common Commands

### Development Commands

```bash
# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean

# Run app (debug mode)
flutter run
flutter run -d <device_id>

# Run specific file
flutter run lib/main.dart

# Analyze code
flutter analyze
dart analyze

# Format code
flutter format lib/
dart format lib/

# Lint with fix
flutter format lib/ --fix
```

### Build Commands

```bash
# Build APK (Android Release)
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release

# Build iOS app
flutter build ios --release

# Build for web (if enabled)
flutter build web --release

# Build with specific flavor/target
flutter build apk --target=lib/main.dart
```

### Testing Commands

```bash
# Run tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# Watch mode (re-run on changes)
flutter test --watch
```

### Debugging Commands

```bash
# Check setup
flutter doctor
flutter doctor -v

# Get package info
flutter pub dependencies
flutter pub deps

# Update packages
flutter pub upgrade
flutter pub upgrade --null-safety

# Show verbose output
flutter run -v
flutter build apk --verbose

# Generate app icons
flutter pub global activate flutter_launcher_icons
flutter_launcher_icons

# Generate splash screen
flutter pub global activate flutter_native_splash
flutter_native_splash:create
```

### Environment Commands

```bash
# Get Flutter version
flutter --version

# Get Dart version
dart --version

# List Flutter channels
flutter channel

# Switch channel
flutter channel stable/beta/dev

# Update Flutter
flutter upgrade

# Activate global packages
flutter pub global activate <package>
```

---

## 📊 Architecture Decision Records (ADR)

### ADR 1: Single Service Class for All APIs
**Decision**: Menggunakan 1 `ApiService` class untuk semua API calls
**Rationale**: 
- Centralized API management
- Easy error handling
- Consistent timeout & retry logic
- Easier to mock for testing

**Alternative**: Separate service classes per API (rejected - over-engineering)

### ADR 2: Using SharedPreferences for Storage
**Decision**: SharedPreferences untuk local data storage
**Rationale**:
- Simple key-value storage
- Good for small data (tokens, user prefs)
- No setup required
- Fast access

**Note**: Future migration ke Hive atau SQLite jika perlu:
```dart
// Untuk complex data:
import 'package:hive/hive.dart';

// Untuk relational data:
import 'package:sqflite/sqflite.dart';
```

### ADR 3: Material Design Theme
**Decision**: Menggunakan Material Design 3 dengan custom green color
**Rationale**:
- Consistent with modern Android design
- Good accessibility
- Easy to customize
- Wide widget support

---

## 🎯 Future Enhancements

### Planned Features
- [ ] Push notifications
- [ ] Offline mode
- [ ] Data caching strategy
- [ ] Advanced filtering & search
- [ ] Export data (CSV, PDF)
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Widget provider/Riverpod state management

### Technical Improvements
- [ ] Add unit tests
- [ ] Add widget tests
- [ ] Implement CI/CD (GitHub Actions)
- [ ] Add analytics tracking
- [ ] Implement error reporting (Sentry)
- [ ] Database migration strategy
- [ ] API versioning

---

## 📞 Contact & Support

**Repository**: [Link ke GitHub]
**Issues**: [GitHub Issues]
**Documentation**: This file + DOKUMENTASI_LENGKAP.md + API_DOCUMENTATION.md + DEVELOPMENT_GUIDE.md

**Last Updated**: 15 Juni 2024
**Version**: 1.0.0
