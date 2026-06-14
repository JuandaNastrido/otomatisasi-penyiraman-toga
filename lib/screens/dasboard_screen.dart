import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/api_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;

  String statusKoneksi = "Online";
  String tanaman = "Jahe Merah";
  String namaIlmiah = "Ziniger officinale";
  String tanggal = "Rabu, 22 April 2026";
  String jam = "09:41 WIB";
  String cuaca = "CERAH";
  String kelembapanUdara = "75%";
  String suhu = "28°C";
  String prakiraanHujan = "20%";

  String kelembabanTanah = "65%";
  String kondisiTanah = "Normal";
  String statusPompa = "Mati";
  String durasiPompa = "0s";

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      String cleaned = value.replaceAll(RegExp(r'[^0-9-]'), '');
      return int.tryParse(cleaned) ?? 0;
    }
    return 0;
  }

  String _toString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await initializeDateFormatting('id', null);
      final List<dynamic> rawSensorData = await _apiService.getSensorData();
      final dynamic rawWeatherData = await _apiService.getWeatherData();
      if (!mounted) return;
      setState(() {
        Map<String, dynamic> sensorData = {};
        if (rawSensorData.isNotEmpty) sensorData = Map<String, dynamic>.from(rawSensorData[0]);
        Map<String, dynamic> weatherData = {};
        if (rawWeatherData is List && rawWeatherData.isNotEmpty) {
          weatherData = Map<String, dynamic>.from(rawWeatherData[0]);
        } else if (rawWeatherData is Map) {
          weatherData = Map<String, dynamic>.from(rawWeatherData);
        }
        var moistureValue = sensorData['moisture_percent'] ?? sensorData['moisture'];
        if (moistureValue != null) kelembabanTanah = "${_toInt(moistureValue)}%";
        kondisiTanah = _toString(sensorData['soil_condition']);
        if (kondisiTanah.isEmpty) kondisiTanah = "Normal";
        statusPompa = _toString(sensorData['action']);
        if (statusPompa.isEmpty) statusPompa = "Idle";
        durasiPompa = "${_toInt(sensorData['pump_duration'])}s";
        var tsValue = sensorData['timestamp'];
        if (tsValue != null) {
          try {
            int timestampInt = _toInt(tsValue);
            if (timestampInt > 0) {
              DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestampInt);
              tanggal = DateFormat('EEEE, d MMMM yyyy', 'id').format(dt);
              jam = DateFormat('HH:mm').format(dt) + " WIB";
            }
          } catch (e) {}
        }
        if (weatherData.isNotEmpty) {
          kelembapanUdara = "${_toInt(weatherData['kelembaban'])}%";
          suhu = "${_toInt(weatherData['suhu'])}°C";
          var kondisiValue = weatherData['kondisi'];
          cuaca = _toString(kondisiValue).toUpperCase();
          if (cuaca.isEmpty) cuaca = "CERAH";
          prakiraanHujan = "${_toInt(weatherData['prakiraan_hujan'])}%";
        }
        isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  double _parsePercent(String text) => (double.tryParse(text.replaceAll('%', '')) ?? 0) / 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildFixedHeader(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWeatherCard(),
                    const SizedBox(height: 30),
                    Text("Status Sensor Tanah", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildSoilSensorCard(),
                    const SizedBox(height: 16),
                    _buildSensorInfoCard(),
                    const SizedBox(height: 30),
                    _buildWateringSystemCard(),
                    const SizedBox(height: 30),
                    _buildWeatherIntegrationCard(),
                    const SizedBox(height: 40),
                  ],
                ),
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
                  Text(statusKoneksi, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
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
                      tanaman,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                    ),
                    Text(
                      namaIlmiah,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(tanggal, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                  Text(jam, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF1976D2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, color: Colors.yellow, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cuaca, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Kelembapan udara: $kelembapanUdara", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              Text(suhu, style: GoogleFonts.poppins(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Prakiraan hujan:", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
              Text(prakiraanHujan, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: _parsePercent(prakiraanHujan), backgroundColor: Colors.white.withOpacity(0.3), color: Colors.white, minHeight: 8),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text("Info: Potensi hujan sore hari\n\"Sistem akan tunda otomatis jika hujan turun\"", style: GoogleFonts.poppins(color: Colors.white, fontSize: 11))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSoilSensorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.eco_outlined, color: Colors.green, size: 40), Icon(Icons.signal_cellular_alt, color: Colors.green, size: 24)]),
          const SizedBox(height: 16),
          Text("KELEMBABAN SAAT INI", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
          Text(kelembabanTanah, style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: _parsePercent(kelembabanTanah), backgroundColor: Colors.grey[200], color: Colors.green[700], minHeight: 12)),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)), child: Text(kondisiTanah, style: GoogleFonts.poppins(color: Colors.green[700], fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildSensorInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          _buildDetailRow("Ambang batas:", "<40% akan menyiraman", isBoldValue: true),
          const SizedBox(height: 16),
          _buildBatteryRow("Baterai sensor:", 0.85),
          const SizedBox(height: 16),
          _buildDetailRow("Terakhir baca:", "2 menit lalu", isBoldValue: true),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ID Sensor:", style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)), child: Text("SNS-001", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWateringSystemCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_outlined, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sistem Penyiraman Otomatis", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                  Row(children: [Text("STATUS: ", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)), Text("SIAP", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)), const SizedBox(width: 4), const Icon(Icons.check_circle, color: Colors.green, size: 12)]),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Aturan aktif:", style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[800])), const SizedBox(height: 4), Text("\"Jika tanah <40%, siram selama 5 menit\"", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green[900]))]),
          ),
          const SizedBox(height: 20),
          Text("Riwayat penyiraman terakhir:", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 10),
          _buildHistoryItem("Kemarin 16:30", "Berhasil (0.8L)"),
          const SizedBox(height: 8),
          _buildHistoryItem("2 hari lalu 08:15", "Berhasil (0.8L)"),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: Text("Siram Manual Sekarang", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 50, child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.orange), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.pause, color: Colors.orange, size: 20), const SizedBox(width: 8), Text("Pause Otomatis Sementara", style: GoogleFonts.poppins(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14))]))),
        ],
      ),
    );
  }

  Widget _buildWeatherIntegrationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Icon(Icons.cloud_outlined, color: Colors.blue, size: 24), const SizedBox(width: 10), Text("Integrasi Cuaca", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 16))]),
          const SizedBox(height: 16),
          _buildCheckItem("Jika hujan turun – penyiraman TUNDA"),
          _buildCheckItem("Jika tanah kering & cuaca cerah – SIRAM"),
          _buildCheckItem("Cek cuaca setiap 30 menit"),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Status saat ini:", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[800])), const SizedBox(height: 4), Text("\"Tanah 65% (normal), cuaca cerah, tidak perlu penyiraman\"", style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[900]))]),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14)), Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal))]);
  }

  Widget _buildBatteryRow(String label, double percent) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14)), Row(children: [SizedBox(width: 80, height: 10, child: ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: percent, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(Colors.green[400]!)))), const SizedBox(width: 10), Text("${(percent * 100).toInt()}%", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14))])]);
  }

  Widget _buildHistoryItem(String time, String status) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("• $time", style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)), Text(status, style: GoogleFonts.poppins(fontSize: 13, color: Colors.green[700], fontWeight: FontWeight.w600))]);
  }

  Widget _buildCheckItem(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Row(children: [const Icon(Icons.check, color: Colors.blue, size: 18), const SizedBox(width: 10), Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.blue[900])))]));
  }
}
