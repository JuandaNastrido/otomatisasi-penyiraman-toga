import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  bool _isEmailVerified = false; // Step 1: Check if email exists

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleCheckEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar("Email tidak boleh kosong");
      return;
    }

    setState(() => _isLoading = true);
    try {
      bool exists = await _apiService.checkEmailExists(email);
      if (exists) {
        setState(() {
          _isEmailVerified = true;
        });
        _showSnackBar("Email terdaftar. Silakan masukkan password baru", isError: false);
      } else {
        _showSnackBar("Email tidak terdaftar");
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan koneksi");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      _showSnackBar("Password tidak boleh kosong");
      return;
    }

    if (password != confirm) {
      _showSnackBar("Konfirmasi password tidak cocok");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.resetPassword(email, password, confirm);
      _showSnackBar("Password berhasil direset! Silakan login", isError: false);
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Kembali ke Login",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 100,
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
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_isEmailVerified ? Icons.lock_reset : Icons.mail_outline, color: Colors.blue, size: 30),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _isEmailVerified ? "Reset Password" : "Lupa Password",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isEmailVerified 
                          ? "Masukkan password baru Anda" 
                          : "Masukkan email Anda untuk mengecek akun",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 30),
                      
                      // Step 1: Email Field
                      _buildField("Email", "nama@email.com", Icons.mail_outline, controller: _emailController, enabled: !_isEmailVerified),
                      
                      if (_isEmailVerified) ...[
                        const SizedBox(height: 15),
                        _buildField("Password Baru", "Min. 5 karakter", Icons.lock_outline, controller: _passwordController, isPass: true),
                        const SizedBox(height: 15),
                        _buildField("Konfirmasi Password", "Ulangi password baru", Icons.lock_outline, controller: _confirmPasswordController, isPass: true),
                      ],
                      
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading 
                            ? null 
                            : (_isEmailVerified ? _handleResetPassword : _handleCheckEmail),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isEmailVerified ? "Simpan Password" : "Cek Akun",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon, {required TextEditingController controller, bool isPass = false, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPass,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
