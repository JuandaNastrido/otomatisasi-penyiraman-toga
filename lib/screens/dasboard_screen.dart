import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;

  String userEmail = "decalyps@gmail.com";
  String statusKoneksi = "Online";
  String tanaman = "Jahe Merah";
  String humidityGroup = "Sedang";
  String humidityRangeText = "50% - 70%";
  String tanggal = "Memuat...";
  String jam = "--:-- WIB";

  // Data Cuaca
  String cuaca = "LOADING...";
  String kelembapanUdara = "0%";
  String suhu = "0°C";
  String prakiraanHujan = "0%";

  // Data Perangkat & Pot
  List<dynamic> devices = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await initializeDateFormatting('id', null);
      
      final prefs = await SharedPreferences.getInstance();
      tanaman = prefs.getString('plant_name') ?? "Jahe Merah";
      humidityGroup = prefs.getString('humidity_group') ?? "Sedang";
      
      if (humidityGroup == "Tinggi") {
        humidityRangeText = "70% - 90%";
      } else if (humidityGroup == "Sedang") {
        humidityRangeText = "50% - 70%";
      } else {
        humidityRangeText = "30% - 50%";
      }

      final Map<String, dynamic> sensorResponse = await _apiService.getLatestSensorData(userEmail);
      final Map<String, dynamic> weatherData = await _apiService.getWeatherData();

      if (!mounted) return;

      setState(() {
        devices = sensorResponse['devices'] ?? [];
        statusKoneksi = devices.isNotEmpty ? "Online (${devices.length} Perangkat)" : "Online";

        // Update Waktu
        DateTime now = DateTime.now();
        tanggal = DateFormat('EEEE, d MMMM yyyy', 'id').format(now);
        jam = DateFormat('HH:mm').format(now) + " WIB";

        if (weatherData.isNotEmpty) {
          kelembapanUdara = "${weatherData['kelembaban']}%";
          suhu = "${weatherData['suhu'].toInt()}°C";
          cuaca = (weatherData['kondisi'] ?? "TIDAK DIKETAHUI").toString().toUpperCase();
          prakiraanHujan = "${weatherData['prakiraan_hujan']}%";
        }

        isLoading = false;
      });
    } catch (e) {
      print("Error Dashboard: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  double _parsePercent(String text) => (double.tryParse(text.replaceAll('%', '')) ?? 0) / 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : Column(
              children: [
                _buildFixedHeader(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchData,
                    color: const Color(0xFF2E7D32),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWeatherCard(),
                          const SizedBox(height: 30),
                          Text("Status Sensor Tanah", 
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          
                          // UI Baru: Menampilkan semua perangkat
                          if (devices.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text("Tidak ada perangkat terhubung", 
                                    style: GoogleFonts.poppins(color: Colors.grey)),
                              ),
                            )
                          else
                            ...devices.map((device) => _buildDeviceStatusSection(device)).toList(),
                          
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

  Widget _buildDeviceStatusSection(dynamic device) {
    String address = device['address'] ?? "Unknown Device";
    List pots = device['pots'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.router, size: 16, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Text(
              "MAC: $address",
              style: GoogleFonts.poppins(
                fontSize: 13, 
                fontWeight: FontWeight.bold, 
                color: Colors.grey[700]
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildThreePotsRow(pots),
        const SizedBox(height: 25),
      ],
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
                      "Kelompok Kelembaban: $humidityGroup",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
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
              const Icon(Icons.cloud_queue_outlined, color: Colors.white, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cuaca, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Kelembapan udara: $kelembapanUdara", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              Text(suhu, style: GoogleFonts.poppins(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Prakiraan potensi hujan hari ini:", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
              Text(prakiraanHujan, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: _parsePercent(prakiraanHujan), backgroundColor: Colors.white.withOpacity(0.3), color: Colors.white, minHeight: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildThreePotsRow(List<dynamic> pots) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pots.take(3).map((pot) => _buildIndividualPotCard(pot)).toList(),
    );
  }

  Widget _buildIndividualPotCard(dynamic pot) {
    String moisture = "${pot['moisturePercent']}%";
    String condition = pot['soilCondition'] ?? "Normal";
    String action = pot['action'] ?? "OFF";
    int potIdx = pot['potIndex'] ?? 0;
    bool isPumping = action.toLowerCase().contains("on");

    Color statusColor = isPumping ? Colors.blue : Colors.green;
    if (condition.toLowerCase().contains("kering")) statusColor = Colors.orange;

    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Text("Pot $potIdx", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: _parsePercent(moisture),
                  backgroundColor: Colors.grey[100],
                  color: statusColor,
                  strokeWidth: 4,
                ),
              ),
              Text(moisture, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text(condition, 
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
          const SizedBox(height: 4),
          Text(isPumping ? "SIRAM" : "MATI", style: GoogleFonts.poppins(fontSize: 8, color: isPumping ? Colors.blue : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWateringSystemCard() {
    // Mengambil status pompa dari pot pertama perangkat pertama sebagai representasi sistem
    String action = devices.isNotEmpty && devices[0]['pots'].isNotEmpty 
        ? devices[0]['pots'][0]['action'] 
        : "OFF";
    bool isPumping = action.toLowerCase().contains("on");

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
                  Row(children: [
                    Text("STATUS: ", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)), 
                    Text(isPumping ? "MENYIRAM" : "READY", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isPumping ? Colors.blue : Colors.green)), 
                    const SizedBox(width: 4), 
                    const Icon(Icons.check_circle, color: Colors.green, size: 12)
                  ]),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Aturan aktif:", style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[800])), 
              const SizedBox(height: 4), 
              Text("\"Jika kelembaban tanah berada di bawah ambang batas $humidityGroup ($humidityRangeText), pompa akan aktif.\"", 
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green[900]))
            ]),
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: Text("Siram Manual Sekarang", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)))),
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
          Row(children: [const Icon(Icons.cloud_outlined, color: Colors.blue, size: 24), const SizedBox(width: 10), Text("Integrasi Cuaca Intelijen", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 16))]),
          const SizedBox(height: 16),
          _buildCheckItem("Jika hujan turun – penyiraman OTOMATIS TUNDA"),
          _buildCheckItem("Jika tanah kering & cuaca cerah – BERSIAP SIRAM"),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Status Keputusan:", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[800])), const SizedBox(height: 4), Text("\"Kondisi cuaca saat ini $cuaca. Sistem memantau seluruh pot secara real-time.\"", style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[900]))]),
          )
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Row(children: [const Icon(Icons.check, color: Colors.blue, size: 18), const SizedBox(width: 10), Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.blue[900])))]));
  }
}
