import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Email dan Password tidak boleh kosong");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Konfirmasi password tidak cocok");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiService.register(email, password);
      if (mounted) {
        _showSnackBar("Registrasi Berhasil! Silakan Login", isError: false);
        Navigator.pop(context); // Kembali ke Login
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
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
                    const Spacer(),
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
                          _buildField("Email", "Masukkan email Anda", Icons.email_outlined, controller: _emailController),
                          const SizedBox(height: 15),
                          _buildField("Password", "Buat password (min. 5 karakter)", Icons.lock_outline, isPass: true, controller: _passwordController),
                          const SizedBox(height: 15),
                          _buildField("Konfirmasi password", "Ulangi password", Icons.lock_outline, isPass: true, controller: _confirmPasswordController),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon, {bool isPass = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D32))),
          ),
        ),
      ],
    );
  }
}
