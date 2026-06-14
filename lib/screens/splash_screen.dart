import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.eco,
                color: Colors.white,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            // App Name
            Text(
              "TOGA",
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            // Line
            Container(
              width: 80,
              height: 3,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            // Tagline
            Text(
              "Smart Watering",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            // Description
            Text(
              "Sistem Penyiraman Otomatis\nTanaman Obat Keluarga",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            // Bottom Indicator (Line)
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
