import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/api_services.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  List<dynamic> historyData = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final data = await _apiService.getSensorData();
      setState(() {
        historyData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching history: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildFixedHeader(context),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : RefreshIndicator(
                    onRefresh: _fetchHistory,
                    color: const Color(0xFF2E7D32),
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildStatsGrid(),
                        const SizedBox(height: 25),
                        Text(
                          "Log Aktivitas Perangkat",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (historyData.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Tidak ada data riwayat", style: GoogleFonts.poppins(color: Colors.grey)),
                            ),
                          )
                        else
                          ...historyData.map((item) => _buildHistoryItem(item)).toList(),
                        const SizedBox(height: 20),
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
              Text(
                "Riwayat Sistem",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Live Data", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Data Aktivitas Terakhir dari Sensor",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    // Data di sini masih dummy karena API tidak memberikan agregasi langsung
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  color: const Color(0xFFE3F2FD),
                  icon: Icons.water_drop_outlined,
                  iconColor: Colors.blue,
                  value: "${historyData.where((e) => e['action'].toString().toLowerCase().contains('siram') || e['action'].toString().toLowerCase().contains('on')).length}x",
                  label: "Penyiraman (Log)",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  color: const Color(0xFFE8F5E9),
                  icon: Icons.bar_chart,
                  iconColor: Colors.green,
                  value: historyData.isNotEmpty ? "${_calculateAverageMoisture()}%" : "0%",
                  label: "Rata-rata kelembapan",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateAverageMoisture() {
    if (historyData.isEmpty) return 0;
    double total = 0;
    for (var item in historyData) {
      total += double.tryParse(item['moisture_percent'].toString()) ?? 0;
    }
    return (total / historyData.length).round();
  }

  Widget _buildStatCard({
    required Color color,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(dynamic item) {
    String action = item['action']?.toString() ?? "N/A";
    bool isWatering = action.toLowerCase().contains('siram') || action.toLowerCase().contains('on');
    
    DateTime dt;
    try {
      dt = DateTime.parse(item['created_at'].toString());
    } catch (_) {
      dt = DateTime.now();
    }
    
    String formattedTime = DateFormat('dd MMM, HH:mm').format(dt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isWatering ? Colors.blue[50] : Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWatering ? Icons.water_drop : Icons.eco,
              color: isWatering ? Colors.blue : Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['soil_condition'] ?? "Kondisi Normal",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Kelembapan: ${item['moisture_percent']}% | Sensor: ${item['sensor_value']}",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedTime,
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Text(
                action,
                style: GoogleFonts.poppins(
                  fontSize: 11, 
                  color: isWatering ? Colors.blue : Colors.green,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
