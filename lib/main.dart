import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toga/screens/splash_screen.dart';
import 'package:toga/screens/login_screen.dart';
import 'package:toga/screens/register_screen.dart';
import 'package:toga/screens/main_screen.dart';

void main(){
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
        '/home': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
