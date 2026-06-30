# 🌱 TOGA - Smart Watering System

A Flutter mobile application for automated plant watering system with real-time sensor monitoring and weather integration.

## 📱 Overview

**TOGA** is an intelligent watering system that combines:
- ✅ User authentication (Login, Register, Password Recovery)
- ✅ Real-time sensor monitoring from the backend with latest and history endpoints
- ✅ Weather data integration based on GPS location and rain prediction
- ✅ Manual watering control per device and pot
- ✅ Device settings management and plant naming per pot
- ✅ Usage history & analytics with charts
- ✅ Cross-platform support (Android & iOS)

## 🚀 Quick Start

### Prerequisites
- Flutter 3.11.4+
- Dart SDK
- Android Studio / Xcode
- Git

### Installation

```bash
# 1. Clone repository
git clone <repository_url>
cd toga

# 2. Install dependencies
flutter pub get

# 3. Setup environment
echo "OPENWEATHER_API_KEY=your_api_key" > .env

# 4. Run app
flutter run
```

## 📚 Documentation

Complete documentation is available:

| Document | Purpose | Duration |
|----------|---------|----------|
| [PANDUAN_DOKUMENTASI.md](PANDUAN_DOKUMENTASI.md) | 📖 Navigation guide & quick links | 5 min |
| [DOKUMENTASI_LENGKAP.md](DOKUMENTASI_LENGKAP.md) | 📱 Complete project documentation | 45 min |
| [API_DOCUMENTATION.md](API_DOCUMENTATION.md) | 🔌 API integration & endpoints | 30 min |
| [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) | 🛠️ Setup & development standards | 50 min |
| [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) | 🏛️ Architecture & quick reference | 20 min |

**Start here**: [PANDUAN_DOKUMENTASI.md](PANDUAN_DOKUMENTASI.md)

## 🏗️ Tech Stack

```
Frontend:         Flutter (Dart)
UI Framework:     Material Design 3
Backend API:      REST API (http://192.168.1.15:8080)
Weather API:      OpenWeatherMap via GPS location
Local Storage:    SharedPreferences
Native Support:   Android + iOS
Charts:           fl_chart
Location Services: geolocator + location
Min SDK:          Flutter 3.11.4+
```

## 📁 Project Structure

```
toga/
├── lib/
│   ├── main.dart              # Entry point & routing
│   ├── screens/               # 8 UI screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   ├── main_screen.dart   # Tab host
│   │   ├── dasboard_screen.dart
│   │   ├── settings_screen.dart
│   │   └── history_screen.dart
│   └── services/
│       └── api_services.dart  # API integration
├── android/                   # Android native code
├── ios/                       # iOS native code
├── assets/                    # Images & resources
├── .env                       # Environment variables
└── pubspec.yaml              # Dependencies
```

## ✨ Key Features

### 🔐 Authentication
- User login & registration
- Password recovery via backend check/reset flow
- Session management with token storage
- Secure credential storage in SharedPreferences

### 📊 Dashboard
- Latest sensor data display from backend
- Current weather & rain prediction from OpenWeatherMap
- Device and pot status overview
- Manual watering action with duration and pot selection

### ⚙️ Settings
- Device configuration and soil-type setup per pot
- Plant name management per pot
- Humidity group configuration
- Local persistence for user preferences

### 📜 History
- Sensor history per device and pot
- Moisture trend chart with fl_chart
- Recent activity timeline
- Refreshable history view

## 🔌 API Integration

### Backend API
```
Base URL: http://192.168.1.15:8080
Endpoints:
  - POST /auth/register
  - POST /auth/login
  - GET /auth/exists?email=...
  - PUT /auth/reset-password
  - GET /api/sensor-data/latest
  - GET /api/sensor-data/history?limit=...
  - GET/POST/PUT /api/sensor-data/device-settings
  - POST /api/sensor-data/command
```

### Weather API
```
Provider: OpenWeatherMap
Endpoints:
  - Current weather: /weather
  - Forecast: /forecast
Location: based on GPS coordinates from device
Language: Indonesian (id)
Units: Metric (°C)
```

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for detailed API specs.

## 🛠️ Development

### Build

```bash
# Debug build
flutter run

# Release APK (Android)
flutter build apk --release

# Release App Bundle (Play Store)
flutter build appbundle --release

# Release iOS
flutter build ios --release
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test
```

### Common Commands

See [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md#-common-commands) for complete list.

## 🐛 Troubleshooting

### Build Fails
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### API Connection Error
- Verify `.env` file exists with valid API key
- Check backend running at 172.20.12.1:3000
- For Android emulator, use: 10.0.2.2:3000

### Dependencies Issue
```bash
flutter doctor
flutter pub cache clean
flutter pub get
```

See [DOKUMENTASI_LENGKAP.md](DOKUMENTASI_LENGKAP.md#-troubleshooting) for more troubleshooting.

## 🔐 Security

⚠️ **Important**:
- DO NOT commit `.env` file to Git
- Add to `.gitignore`: `echo ".env" >> .gitignore`
- Use environment variables for API keys
- Implement HTTPS for production

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | SDK | Framework |
| google_fonts | ^6.2.1 | Typography |
| http | ^1.1.0 | HTTP client |
| shared_preferences | ^2.2.2 | Local storage |
| flutter_dotenv | ^6.0.1 | Environment config |
| intl | ^0.19.0 | Internationalization |
| geolocator | ^13.0.0 | GPS location access |
| location | ^7.0.0 | Location services |
| fl_chart | ^0.69.0 | Sensor history charts |

## 📊 Project Stats

```
Files: 8 main screens
Lines of Code: ~2,500+
Backend: REST API
Platforms: Android, iOS
Version: 1.0.0+1
Status: Active Development ✅
```

## 📖 Learning Resources

### Official Docs
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)
- [Material Design 3](https://m3.material.io/)

### External APIs
- [OpenWeatherMap API](https://openweathermap.org/api)
- [REST API Best Practices](https://restfulapi.net/)

### Community
- [Flutter Community](https://fluttercommunity.dev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Follow [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md#-coding-standards)
4. Test thoroughly
5. Submit pull request

## 📝 Version History

- **v1.1.0** (2026-06-30): Feature expansion update
  - Authentication flow with backend endpoints
  - Device settings management and plant naming per pot
  - Manual watering command with duration and pot selection
  - History screen with moisture trend chart
  - Weather data based on device GPS location

- **v1.0.0** (2024-06-15): Initial release
  - Authentication system
  - Sensor data integration
  - Weather API integration
  - Multi-screen UI
  - Android & iOS support

## 📞 Support

For issues or questions:
1. Check documentation in the links above
2. Review [PANDUAN_DOKUMENTASI.md](PANDUAN_DOKUMENTASI.md)
3. Open an issue on GitHub
4. Contact development team

## 📄 License

Proyek ini dilisensikan di bawah [MIT License](LICENSE)

---

**Last Updated**: 15 Juni 2024
**Version**: 1.0.0
**Status**: ✅ Active Development

For detailed documentation, start with [PANDUAN_DOKUMENTASI.md](PANDUAN_DOKUMENTASI.md)
