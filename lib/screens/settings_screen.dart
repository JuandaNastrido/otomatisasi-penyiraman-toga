import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _plantController = TextEditingController();
  String _humidityGroup = "Sedang";
  
  String _modeOperasi = "Otomatis Penuh";
  double _durasiPenyiraman = 5;
  double _cekUlang = 30;

  bool _tundaHujan = true;
  bool _cekPrakiraan = true;
  bool _tetapSiram = false;
  String _batasHujan = ">30% hujan = tunda";

  bool _notifPenyiraman = true;
  bool _notifBaterai = true;
  bool _notifSensor = true;
  bool _notifCuaca = false;
  bool _notifTanah = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _plantController.text = prefs.getString('plant_name') ?? "Jahe Merah";
      _humidityGroup = prefs.getString('humidity_group') ?? "Sedang";
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('plant_name', _plantController.text);
    await prefs.setString('humidity_group', _humidityGroup);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan berhasil disimpan')),
      );
    }
  }

  @override
  void dispose() {
    _plantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildFixedHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildPlantInput(),
                  const SizedBox(height: 20),
                  _buildHumiditySelection(),
                  const SizedBox(height: 20),
                  _buildModeOperasi(),
                  const SizedBox(height: 20),
                  _buildAturanPenyiraman(),
                  const SizedBox(height: 20),
                  _buildAturanCuaca(),
                  const SizedBox(height: 20),
                  _buildPengaturanNotifikasi(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  _buildInformasiPengguna(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, color: Colors.white, size: 10),
                  const SizedBox(width: 8),
                  Text(
                    "Online",
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("User", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pengaturan Sistem",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "Otomatis Aktif",
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Aktif", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                  Text("Sistem Siaga", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[700], size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildPlantInput() {
    return _buildCard([
      _buildSectionTitle(Icons.eco_outlined, "Nama Tanaman"),
      const SizedBox(height: 16),
      TextField(
        controller: _plantController,
        decoration: InputDecoration(
          hintText: "Masukkan nama tanaman...",
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    ]);
  }

  Widget _buildHumiditySelection() {
    return _buildCard([
      _buildSectionTitle(Icons.water_drop_outlined, "Kelompok Kelembapan"),
      const SizedBox(height: 16),
      _buildHumidityOption("Tinggi", "70% – 90%"),
      const SizedBox(height: 12),
      _buildHumidityOption("Sedang", "50% – 70%"),
      const SizedBox(height: 12),
      _buildHumidityOption("Rendah", "30% – 50%"),
    ]);
  }

  Widget _buildHumidityOption(String title, String range) {
    bool isSelected = _humidityGroup == title;
    return GestureDetector(
      onTap: () => setState(() => _humidityGroup = title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.green[50]?.withOpacity(0.3) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.green[700] : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(range, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModeOperasi() {
    return _buildCard([
      _buildSectionTitle(Icons.smart_toy_outlined, "Mode Operasi"),
      const SizedBox(height: 16),
      _buildRadioOption("Otomatis Penuh", "Sistem menyiram berdasarkan sensor dan cuaca"),
      const SizedBox(height: 12),
      _buildRadioOption("Manual Only", "Hanya siram jika ditekan tombol"),
      const SizedBox(height: 12),
      _buildRadioOption("Mati Total", "Nonaktifkan semua penyiraman"),
    ]);
  }

  Widget _buildRadioOption(String title, String subtitle) {
    bool isSelected = _modeOperasi == title;
    return GestureDetector(
      onTap: () => setState(() => _modeOperasi = title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.green[50]?.withOpacity(0.3) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.green[700] : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAturanPenyiraman() {
    return _buildCard([
      _buildSectionTitle(Icons.timer_outlined, "Interval Penyiraman"),
      const SizedBox(height: 20),
      _buildSliderRow("Durasi penyiraman", _durasiPenyiraman, 1, 60, " menit", (v) => setState(() => _durasiPenyiraman = v)),
      const SizedBox(height: 16),
      _buildSliderRow("Cek ulang setelah siram", _cekUlang, 5, 120, " menit", (v) => setState(() => _cekUlang = v)),
    ]);
  }

  Widget _buildSliderRow(String label, double value, double min, double max, String unit, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
            Text("${value.toInt()}$unit", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[700])),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: Colors.green[700],
            inactiveColor: Colors.grey[200],
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${min.toInt()}${unit == "%" ? "%" : " mnt"}", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
            Text("${max.toInt()}${unit == "%" ? "%" : " mnt"}", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
          ],
        )
      ],
    );
  }

  Widget _buildAturanCuaca() {
    return _buildCard([
      _buildSectionTitle(Icons.cloud_outlined, "Aturan Cuaca"),
      const SizedBox(height: 16),
      _buildSwitchRow("Tunda otomatis jika hujan", _tundaHujan, (v) => setState(() => _tundaHujan = v)),
      _buildSwitchRow("Cek prakiraan hujan sebelum siram", _cekPrakiraan, (v) => setState(() => _cekPrakiraan = v)),
      _buildSwitchRow("Tetap siram meskipun hujan", _tetapSiram, (v) => setState(() => _tetapSiram = v)),
      const SizedBox(height: 16),
      Text("Batas toleransi hujan:", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(height: 10),
      _buildBatasHujanOption(">30% hujan = tunda"),
      _buildBatasHujanOption(">50% hujan = tunda"),
      _buildBatasHujanOption(">70% hujan = tunda"),
    ]);
  }

  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green[700],
        ),
      ],
    );
  }

  Widget _buildBatasHujanOption(String title) {
    bool isSelected = _batasHujan == title;
    return GestureDetector(
      onTap: () => setState(() => _batasHujan = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue[300]! : Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildPengaturanNotifikasi() {
    return _buildCard([
      _buildSectionTitle(Icons.notifications_none_outlined, "Pengaturan Notifikasi"),
      const SizedBox(height: 10),
      _buildSwitchRow("Notifikasi penyiraman", _notifPenyiraman, (v) => setState(() => _notifPenyiraman = v)),
      _buildSwitchRow("Notifikasi baterai lemah", _notifBaterai, (v) => setState(() => _notifBaterai = v)),
      _buildSwitchRow("Notifikasi sensor offline", _notifSensor, (v) => setState(() => _notifSensor = v)),
      _buildSwitchRow("Notifikasi cuaca harian", _notifCuaca, (v) => setState(() => _notifCuaca = v)),
      _buildSwitchRow("Notifikasi jika tanah <30%", _notifTanah, (v) => setState(() => _notifTanah = v)),
    ]);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.save_outlined, color: Colors.white),
                const SizedBox(width: 10),
                Text("Simpan Pengaturan", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE64A19),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.white),
                const SizedBox(width: 10),
                Text("Keluar", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInformasiPengguna() {
    return _buildCard([
      _buildSectionTitle(Icons.person_outline, "Informasi Pengguna"),
      const SizedBox(height: 16),
      Text("Nama Pengguna:", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(height: 4),
      Text("user", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
    ]);
  }
}
