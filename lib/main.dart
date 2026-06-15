import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. TAMBAHKAN IMPORT INI
import 'package:google_fonts/google_fonts.dart';
import 'package:toga/screens/splash_screen.dart';
import 'package:toga/screens/login_screen.dart';
import 'package:toga/screens/register_screen.dart';
import 'package:toga/screens/main_screen.dart';
import 'package:toga/screens/forgot_password_screen.dart';

// 2. UBAH MAIN MENJADI ASYNC
Future<void> main() async {
  // 3. TAMBAHKAN DUA BARIS INI SEBELUM RUNAPP
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Toga Controller",
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      // Halaman awal adalah Splash Screen
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}