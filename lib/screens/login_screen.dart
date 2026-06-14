import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Logo and App Name
              Center(
                child: Column(
                  children: [
                    // Menggunakan Logo Toga
                    Image.asset(
                      'assets/logo.png',
                      height: 120,
                      errorBuilder: (c, e, s) => const Icon(Icons.eco, color: Colors.white, size: 80),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "TOGA",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "Smart Watering System",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Login Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32), size: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Masukkan Kredensial Anda",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      label: "Username",
                      hint: "Masukkan Username",
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Password",
                      hint: "Masukkan Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Masuk",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Lupa Password ?",
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun ? ",
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // Menghubungkan ke halaman pendaftaran
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: Text(
                              "Daftar di sini",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32)),
            ),
          ),
        ),
      ],
    );
  }
}
