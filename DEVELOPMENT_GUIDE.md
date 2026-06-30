# 🛠️ DEVELOPMENT GUIDE - TOGA PROJECT

## 📋 Daftar Isi
1. [Development Environment Setup](#development-environment-setup)
2. [Project Structure Conventions](#project-structure-conventions)
3. [Coding Standards](#coding-standards)
4. [Build & Release](#build--release)
5. [Common Development Tasks](#common-development-tasks)
6. [Debugging Guide](#debugging-guide)
7. [Performance Optimization](#performance-optimization)

---

## 🚀 Development Environment Setup

### System Requirements

**Minimum Specifications**:
- **RAM**: 8 GB
- **Storage**: 15 GB free space
- **OS**: Windows 10+, macOS 10.15+, atau Linux

**Recommended**:
- RAM: 16 GB
- Storage: 50 GB free space
- SSD untuk faster builds

### Step 1: Install Flutter

#### Windows

```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
# Edit Environment Variables > System Variables > Path
# Add: C:\flutter\bin

# Verify installation
flutter doctor
```

#### macOS

```bash
# Using Homebrew
brew install flutter

# Or manual install
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (.zshrc atau .bash_profile)
export PATH="$PATH:$HOME/development/flutter/bin"

# Verify
flutter doctor
```

#### Linux

```bash
# Install dependencies
sudo apt-get install clang cmake git ninja-build pkg-config libgtk-3-dev

# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (.bashrc)
export PATH="$PATH:$HOME/flutter/bin"

# Verify
flutter doctor
```

### Step 2: Install Dependencies

```bash
# Run Flutter doctor untuk identify missing dependencies
flutter doctor

# Follow recommendations untuk:
# - Android Toolchain
# - Xcode (macOS/iOS)
# - Android Studio IDE
# - VS Code with Flutter extension
```

### Step 3: Setup IDE

#### VS Code Setup

```bash
# Install extensions
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
code --install-extension Dart-Code.flutter-test

# Generate launch configuration
# Create .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

#### Android Studio Setup

```
1. Open Android Studio
2. File > Settings > Plugins
3. Search dan install:
   - Flutter plugin
   - Dart plugin
4. Restart Android Studio
5. File > New > New Flutter Project
```

### Step 4: Setup .env File

```bash
# Create .env di root project
echo "OPENWEATHER_API_KEY=your_api_key_here" > .env

# Add ke .gitignore
echo ".env" >> .gitignore
```

### Step 5: Verify Setup

```bash
# Generate API key dari OpenWeatherMap
# https://openweathermap.org/api

# Run flutter doctor
flutter doctor

# Output harus menunjukkan:
# ✓ Flutter (Channel stable)
# ✓ Android toolchain
# ✓ Xcode (macOS)
# ✓ VS Code / Android Studio
```

---

## 📁 Project Structure Conventions

### Folder Organization

```
lib/
├── main.dart                    # Entry point & route setup
├── screens/                     # UI Pages
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── forgot_password_screen.dart
│   ├── main_screen.dart
│   ├── dasboard_screen.dart
│   ├── settings_screen.dart
│   └── history_screen.dart
├── services/                    # Business Logic & API
│   └── api_services.dart        # Auth, sensor, settings, manual watering
├── models/                      # Data Models (can be added as feature grows)
├── widgets/                     # Reusable Widgets (can be added as feature grows)
└── utils/                       # Utilities & Helpers (can be added as feature grows)
```

### Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Files | snake_case | login_screen.dart |
| Classes | PascalCase | LoginScreen, UserModel |
| Variables | camelCase | userName, sensorData |
| Constants | UPPER_SNAKE_CASE | API_TIMEOUT, MAX_RETRIES |
| Private members | _camelCase | _password, _fetchData() |
| Boolean variables | isBool, hasXyz | isLoading, hasError |

### File Organization Best Practices

```dart
// Order of imports
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toga/services/api_services.dart';

// Order of declarations
class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // 1. Properties & Constants
  static const String _title = 'My Screen';
  late ApiService _apiService;

  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(...)
  }

  // 4. Helper methods
  void _handleAction() {}

  Future<void> _fetchData() async {}
}
```

---

## 📝 Coding Standards

### Dart Style Guide

#### 1. Use const When Possible
```dart
// ✅ GOOD
const EdgeInsets padding = EdgeInsets.all(16);

// ❌ BAD
EdgeInsets padding = EdgeInsets.all(16);
```

#### 2. Use final for Variables That Never Change
```dart
// ✅ GOOD
final List<String> items = ['a', 'b', 'c'];
final int count = items.length;

// ❌ BAD
var items = ['a', 'b', 'c'];
int count = items.length;
```

#### 3. Type Annotations for Public APIs
```dart
// ✅ GOOD
Future<List<User>> fetchUsers() async {
  return _apiService.getUsers();
}

// ❌ BAD
fetchUsers() async {
  return _apiService.getUsers();
}
```

#### 4. Use Named Parameters for Functions
```dart
// ✅ GOOD
void showDialog({
  required String title,
  required String message,
  VoidCallback? onConfirm,
}) {
  // Implementation
}

// ❌ BAD
void showDialog(String title, String message, VoidCallback onConfirm) {
  // Implementation
}
```

#### 5. Use Spread Operator for Lists/Maps
```dart
// ✅ GOOD
final list = [...items1, ...items2];
final map = {...map1, ...map2};

// ❌ BAD
final list = items1 + items2;
final newMap = Map.from(map1);
newMap.addAll(map2);
```

### Flutter Widget Guidelines

#### 1. Extract Complex Widgets
```dart
// ✅ GOOD - Separate widget
class UserCard extends StatelessWidget {
  final User user;
  const UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(/* User display */);
  }
}

// Usage
ListView(
  children: [
    UserCard(user: user1),
    UserCard(user: user2),
  ],
)

// ❌ BAD - Complex inline
ListView(
  children: [
    Card(
      child: Column(
        children: [/* Complex UI */],
      ),
    ),
  ],
)
```

#### 2. Use Const Constructors
```dart
// ✅ GOOD
const SizedBox(height: 16),
const Icon(Icons.home),

// ❌ BAD
SizedBox(height: 16),
Icon(Icons.home),
```

#### 3. Consistent Text Styling
```dart
// ✅ GOOD - Use theme
Text(
  'Title',
  style: Theme.of(context).textTheme.titleLarge,
)

// ❌ BAD - Hardcoded styles
Text(
  'Title',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
)
```

### Error Handling

```dart
// ✅ GOOD
try {
  final data = await _apiService.getData();
  setState(() => _data = data);
} on TimeoutException {
  _showErrorMessage('Request timeout');
} on SocketException {
  _showErrorMessage('Network error');
} catch (e) {
  _showErrorMessage('Unknown error: $e');
}

// ❌ BAD
final data = await _apiService.getData();
setState(() => _data = data);
```

### Comments & Documentation

```dart
/// Fetches user data from the API.
/// 
/// Throws [TimeoutException] if request exceeds 10 seconds.
/// Throws [SocketException] if network is unavailable.
/// 
/// Returns a list of [User] objects.
Future<List<User>> fetchUsers() async {
  // Implementation
}

// Single line comment untuk quick notes
final isValid = email.contains('@'); // Email validation

/// TODO: Implement pagination
/// See: https://example.com/pagination-guide
```

---

## 🏗️ Build & Release

### Debug Build

```bash
# Run in debug mode (default)
flutter run

# Run with specific device
flutter devices                    # List devices
flutter run -d <device_id>

# Run on physical device
# Enable USB debugging on Android
# Connect device
flutter run -d physical_device
```

### Release Build - Android

```bash
# Build APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab

# Split APK by ABI (for multiple architectures)
flutter build apk --release --split-per-abi
```

### Release Build - iOS

```bash
# Build iOS app
flutter build ios --release

# Output: build/ios/iphoneos/Runner.app

# Build for release (ready for App Store)
flutter build ios --release

# Open in Xcode for signing
open ios/Runner.xcworkspace
```

### Build Configuration

**pubspec.yaml**:
```yaml
version: 1.0.0+1
# Format: version+buildNumber
# Version: semantic versioning (MAJOR.MINOR.PATCH)
# BuildNumber: increment for each release
```

Update saat release:
```bash
# Before building
# 1. Update version in pubspec.yaml
# 2. Update CHANGELOG.md
# 3. Commit changes

flutter clean
flutter pub get
flutter build apk --release
```

---

## 📋 Common Development Tasks

### Task 1: Add New Screen

```dart
// 1. Create file: lib/screens/new_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: Center(child: Text('Content')),
    );
  }
}

// 2. Add route di main.dart
'/new': (context) => const NewScreen(),

// 3. Navigate dari screen lain
Navigator.pushNamed(context, '/new');
```

### Task 2: Add New API Endpoint

```dart
// api_services.dart
Future<User> getUser(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
```

### Task 3: Add Local Storage

```dart
// Using SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user_data';

  static Future<void> saveUser(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData);
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
```

### Task 4: Add Input Validation

```dart
// lib/utils/validators.dart
class Validators {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Email required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password required';
    if (value!.length < 8) return 'Password minimum 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Include uppercase letter';
    return null;
  }
}

// Usage in form
TextFormField(
  validator: Validators.validateEmail,
)
```

---

## 🐛 Debugging Guide

### Enable Debug Logging

```dart
// main.dart
void main() {
  // Enable debug prints
  debugPrintBeginFrame = true;
  debugPrintEndFrame = true;
  
  runApp(const MyApp());
}

// Dalam code
print('Debug: $value');
debugPrint('Debug: $value'); // Better formatting
```

### Use DevTools

```bash
# Start app
flutter run

# In another terminal
flutter pub global activate devtools
devtools

# Open browser at http://localhost:9100
```

### Breakpoint Debugging (VS Code)

```bash
# Launch debug mode
flutter run

# Set breakpoint di VS Code (click on line number)
# App akan pause saat mencapai breakpoint
# View variables di Debug Console
```

### Network Debugging

```dart
// Add HTTP logging
import 'package:http/http.dart' as http;

class LoggingClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    print('Request: ${request.method} ${request.url}');
    print('Headers: ${request.headers}');
    
    var response = await super.send(request);
    
    print('Response: ${response.statusCode}');
    print('Body: ${response.stream}');
    
    return response;
  }
}
```

### Performance Profiling

```bash
# Run dengan profiling
flutter run --profile

# Di DevTools, buka Performance tab
# Record timeline dan analyze frame rendering
```

---

## ⚡ Performance Optimization

### 1. Widget Building Optimization

```dart
// ❌ BAD - Rebuilds everything
class Parent extends StatefulWidget {
  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  late int counter;

  void _increment() => setState(() => counter++);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget(), // Rebuilds every time
        Text('Counter: $counter'),
        ElevatedButton(onPressed: _increment, child: const Text('Inc')),
      ],
    );
  }
}

// ✅ GOOD - Only rebuilds counter
class Parent extends StatefulWidget {
  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  late int counter;

  void _increment() => setState(() => counter++);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(), // Const = not rebuilt
        CounterDisplay(counter: counter),
        ElevatedButton(onPressed: _increment, child: const Text('Inc')),
      ],
    );
  }
}

class CounterDisplay extends StatelessWidget {
  final int counter;
  const CounterDisplay({required this.counter});

  @override
  Widget build(BuildContext context) => Text('Counter: $counter');
}
```

### 2. List Optimization

```dart
// ❌ BAD - Full list rebuild
ListView(
  children: items.map((item) => ItemWidget(item: item)).toList(),
)

// ✅ GOOD - Lazy loading & efficient
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// ✅ BETTER - With caching
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
  separatorBuilder: (context, index) => const Divider(),
)
```

### 3. Image Optimization

```dart
// ✅ GOOD - Cached images
Image.network(
  imageUrl,
  cache: true,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)

// Use cache_network_image package
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const SizedBox(
    height: 200,
    child: CircularProgressIndicator(),
  ),
)
```

### 4. Reduce Build Complexity

```dart
// Extract large build methods
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    bottomNavigationBar: _buildBottomBar(),
  );
}

Widget _buildAppBar() => AppBar(...);
Widget _buildBody() => Center(...);
Widget _buildBottomBar() => BottomNavigationBar(...);
```

### 5. Memory Management

```dart
// ❌ BAD - Memory leak
class Screen extends StatefulWidget {
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventStream.listen((event) {
      // Handle event
    });
  }

  // Missing dispose!
}

// ✅ GOOD - Proper cleanup
class _ScreenState extends State<Screen> {
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventStream.listen((event) {});
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
```

---

## 📚 Additional Resources

### Official Documentation
- [Flutter Development Guide](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Best Practices](https://flutter.dev/docs/best-practices)

### Tools
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Android Studio](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/)

### Community
- [Stack Overflow - Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub Repo](https://github.com/flutter/flutter)
- [Flutter Community Slack](https://fluttercommunity.dev/)

---

**Last Updated**: 15 Juni 2024
**Version**: 1.0.0
