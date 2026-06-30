# 📚 PANDUAN DOKUMENTASI TOGA PROJECT

## Selamat Datang! 👋

Dokumentasi lengkap proyek **TOGA - Smart Watering System** telah tersedia. Silakan pilih dokumentasi sesuai kebutuhan Anda.

---

## 📖 Dokumen Tersedia

### 1. **DOKUMENTASI_LENGKAP.md** 📱
**Untuk**: Overview lengkap proyek

**Isi**:
- Overview & deskripsi proyek
- Struktur folder lengkap
- Teknologi & dependencies
- Setup & instalasi project
- Fitur-fitur utama
- Routing & navigasi
- Penjelasan detail setiap screen
- Services & API integration
- Best practices & troubleshooting
- Security considerations

**Baca jika**: Anda ingin memahami project secara menyeluruh dari awal

**Waktu baca**: ~45 menit

---

### 2. **API_DOCUMENTATION.md** 🔌
**Untuk**: Detail integrasi & dokumentasi API

**Isi**:
- Backend lokal (Sensor Data) API
- OpenWeatherMap API
- Request/Response examples
- Error handling
- API testing guide
- Rate limiting & caching
- Security best practices

**Baca jika**: Anda perlu memahami bagaimana aplikasi berkomunikasi dengan backend

**Waktu baca**: ~30 menit

---

### 3. **DEVELOPMENT_GUIDE.md** 🛠️
**Untuk**: Panduan setup development & coding standards

**Isi**:
- Development environment setup (lengkap)
- Project structure conventions
- Dart coding standards
- Flutter best practices
- Build & release procedures
- Common development tasks
- Debugging guide
- Performance optimization

**Baca jika**: Anda ingin setup development environment atau berkontribusi code

**Waktu baca**: ~50 menit

---

### 4. **ARCHITECTURE_GUIDE.md** 🏛️
**Untuk**: Arsitektur aplikasi & quick reference

**Isi**:
- Application architecture (layered)
- Component diagram
- Data flow diagrams
- Quick reference
- File location index
- Common commands
- Architecture decision records
- Future enhancements

**Baca jika**: Anda ingin memahami struktur teknis atau mencari command tertentu

**Waktu baca**: ~20 menit

---

## 🚀 Quick Start untuk Berbagai Role

### Untuk Product Manager 👔
1. Baca: DOKUMENTASI_LENGKAP.md (Bagian: Overview, Fitur-Fitur Utama)
2. Baca: ARCHITECTURE_GUIDE.md (Bagian: Future Enhancements)

### Untuk Backend Developer 💻
1. Baca: API_DOCUMENTATION.md (Semua bagian)
2. Baca: DOKUMENTASI_LENGKAP.md (Bagian: Services & API Integration)

### Untuk Frontend Developer 💻
1. Baca: DEVELOPMENT_GUIDE.md (Setup + Coding Standards)
2. Baca: DOKUMENTASI_LENGKAP.md (Bagian: Screens)
3. Referensi: ARCHITECTURE_GUIDE.md (Quick Reference)

### Untuk DevOps / Build Engineer ⚙️
1. Baca: DEVELOPMENT_GUIDE.md (Bagian: Build & Release)
2. Baca: ARCHITECTURE_GUIDE.md (Bagian: Common Commands)

### Untuk QA / Tester 🧪
1. Baca: DOKUMENTASI_LENGKAP.md (Bagian: Fitur-Fitur Utama)
2. Baca: API_DOCUMENTATION.md (Bagian: API Testing)
3. Baca: DEVELOPMENT_GUIDE.md (Bagian: Common Development Tasks)

---

## 📋 Ringkasan Project

### Deskripsi Singkat
**TOGA** adalah aplikasi mobile Flutter untuk sistem pengairan otomatis tanaman yang mengintegrasikan autentikasi pengguna, data sensor real-time, cuaca berbasis lokasi, konfigurasi perangkat, dan fitur siram manual.

### Tech Stack
```
Frontend:        Flutter (Dart)
UI Framework:    Material Design 3
Backend API:     REST (http://192.168.1.15:8080)
Weather API:     OpenWeatherMap via GPS
Local Storage:   SharedPreferences
Charts:          fl_chart
Native Support:  Android + iOS
```

### Key Features
✅ User Authentication (Login, Register, Forgot Password)
✅ Latest & History Sensor Data Monitoring
✅ Weather Integration & Rain Prediction
✅ Manual Watering Control per Device/Pot
✅ Device Settings & Plant Naming per Pot
✅ Usage History & Analytics with Charts

### Struktur Project
```
toga/
├── lib/
│   ├── main.dart
│   ├── screens/ (8 screens)
│   ├── services/ (API integration)
│   └── (future: models/, widgets/, utils/)
├── android/ (Native Android)
├── ios/ (Native iOS)
├── assets/ (Images, resources)
└── pubspec.yaml (Dependencies)
```

---

## 🔗 Dependencies

| Package | Versi | Purpose |
|---------|-------|---------|
| flutter | SDK | Framework |
| google_fonts | ^6.2.1 | Custom fonts |
| http | ^1.1.0 | HTTP client |
| shared_preferences | ^2.2.2 | Local storage |
| flutter_dotenv | ^6.0.1 | Environment vars |
| intl | ^0.19.0 | Internationalization |

---

## 📊 Project Statistics

```
Lines of Code (LOC):     ~2,500+
Main Screens:            8
Services:                1 (ApiService)
Total Dependencies:      6
Dev Dependencies:        2
Min Flutter Version:     3.11.4
Target Platforms:        Android, iOS
```

---

## 🎯 Routing Map

```
Splash Screen (/)
├── Login Screen (/login)
│   ├── Register (/register)
│   └── Forgot Password (/forgot-password)
└── Main Screen (/home) [Authenticated]
    ├── Dashboard (Beranda)
    ├── Settings (Pengaturan)
    └── History (Riwayat)
```

---

## ✨ Setup Singkat (5 menit)

### Prerequisites
```bash
# Pastikan Flutter sudah terinstall
flutter doctor
```

### Steps
```bash
# 1. Clone/navigate ke project
cd toga

# 2. Get dependencies
flutter pub get

# 3. Setup .env
echo "OPENWEATHER_API_KEY=your_key_here" > .env

# 4. Run
flutter run
```

### Dapatkan API Key
1. Kunjungi: https://openweathermap.org/api
2. Daftar & generate free API key
3. Paste ke `.env` file

---

## 🐛 Troubleshooting Cepat

| Masalah | Solusi |
|---------|--------|
| `flutter doctor` error | Ikuti recommended steps di output |
| Build gagal | `flutter clean && flutter pub get` |
| API connection error | Check `.env` file dan network |
| Widget tidak rebuild | Use `setState()` atau state management |
| Backend tidak reachable | Pastikan server backend aktif di 192.168.1.15:8080 |

Untuk troubleshooting lengkap → DOKUMENTASI_LENGKAP.md (Bagian: Troubleshooting)

---

## 📝 File Checklist

Pastikan file dokumentasi berikut tersedia:

- ✅ DOKUMENTASI_LENGKAP.md
- ✅ API_DOCUMENTATION.md
- ✅ DEVELOPMENT_GUIDE.md
- ✅ ARCHITECTURE_GUIDE.md
- ✅ PANDUAN_DOKUMENTASI.md (file ini)

---

## 🔐 Important Notes

### .env File
⚠️ **JANGAN** commit `.env` ke Git
```
# Add ke .gitignore
.env
```

### API Keys
🔒 Simpan API key dengan aman
- Jangan hardcode di code
- Gunakan environment variables (.env)
- Rotate keys regularly

### Security
🛡️ Untuk production:
- Implement HTTPS
- Token-based authentication
- Input validation
- Error logging (Sentry)

---

## 📞 Support & Resources

### Official Docs
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)
- [Material Design 3](https://m3.material.io/)

### APIs
- [OpenWeatherMap API Docs](https://openweathermap.org/api)
- [REST API Guide](https://restfulapi.net/)

### Community
- Flutter Official: https://flutter.dev
- GitHub: https://github.com/flutter/flutter
- Stack Overflow: [Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)

---

## 📈 Next Steps

### Untuk Development
1. ✅ Read DOKUMENTASI_LENGKAP.md
2. ✅ Setup dev environment (DEVELOPMENT_GUIDE.md)
3. ✅ Understand architecture (ARCHITECTURE_GUIDE.md)
4. ✅ Start coding!

### Untuk Integration
1. ✅ Read API_DOCUMENTATION.md
2. ✅ Understand endpoints & error handling
3. ✅ Test dengan Postman/cURL
4. ✅ Implement in code

### Untuk Deployment
1. ✅ Review DEVELOPMENT_GUIDE.md (Build & Release)
2. ✅ Create release build
3. ✅ Sign & upload ke app stores
4. ✅ Monitor & maintain

---

## 📅 Document Version

```
Version:      1.0.0
Last Updated: 15 Juni 2024
Status:       ✅ Active
Coverage:     Complete documentation set
```

---

## 💡 Tips

✨ **Pro Tips**:
1. Bookmark ARCHITECTURE_GUIDE.md untuk quick reference
2. Gunakan search function untuk menemukan specific topics
3. Follow link-nya untuk navigasi antar dokumen
4. Update dokumentasi saat ada perubahan project

---

**Happy Coding! 🚀**

Jika ada pertanyaan atau feedback tentang dokumentasi, silakan buat issue atau hubungi tim development.

---

*Generated: 15 Juni 2024*
*For Toga Project v1.0.0*
