import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      // resizeToAvoidBottomInset: true (default) memastikan scaffold menyesuaikan saat keyboard muncul
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Minimal setinggi layar agar Spacer tetap bisa mendorong konten ke bawah
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // Back Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            "Kembali ke Login",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Logo
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 100,
                            errorBuilder: (c, e, s) => const Icon(Icons.eco, color: Colors.white, size: 70),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "TOGA",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 2,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Smart Watering System",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Spacer sekarang bekerja karena berada di dalam IntrinsicHeight & ConstrainedBox
                    const Spacer(),
                    // Register Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                            child: const Icon(Icons.person_add_outlined, color: Color(0xFF2E7D32), size: 28),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Daftar Akun Baru",
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Buat akun untuk mengakses aplikasi",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 25),
                          _buildField("Username", "Pilih username (min. 3 karakter)", Icons.person_outline),
                          const SizedBox(height: 15),
                          _buildField("Password", "Buat password (min. 5 karakter)", Icons.lock_outline, isPass: true),
                          const SizedBox(height: 15),
                          _buildField("Konfirmasi password", "Ulangi password", Icons.lock_outline, isPass: true),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: Text(
                                "Daftar Sekarang",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sudah punya akun ? ", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  "Login di sini",
                                  style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Bottom security info (Tetap di bawah kartu)
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_user_outlined, size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                "Password dienkripsi dengan aman",
                                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D32))),
          ),
        ),
      ],
    );
  }
}
