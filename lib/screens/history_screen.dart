// C:/Users/juand/StudioProjects/Toga/lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_services.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  List<dynamic> devices = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      // Mengambil riwayat dengan limit 50 (Authorization Bearer ditangani di ApiService)
      final data = await _apiService.getSensorHistory(limit: 50);
      if (mounted) {
        setState(() {
          devices = data['devices'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching history: $e");
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat riwayat: ${e.toString().replaceAll('Exception: ', '')}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : RefreshIndicator(
                    onRefresh: _fetchHistory,
                    color: const Color(0xFF2E7D32),
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          "Riwayat Aktivitas Perangkat",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (devices.isEmpty)
                          _buildEmptyState()
                        else
                          ...devices.map((device) => _buildDeviceHistoryCard(device)).toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceHistoryCard(dynamic device) {
    String address = device['address'] ?? "Unknown";
    List pots = device['pots'] ?? [];

    // Filter: Ambil maksimal 5 data terbaru per potIndex
    Map<int, List<dynamic>> filteredPots = {};
    for (var pot in pots) {
      int idx = pot['potIndex'];
      if (!filteredPots.containsKey(idx)) {
        filteredPots[idx] = [];
      }
      if (filteredPots[idx]!.length < 5) {
        filteredPots[idx]!.add(pot);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.router, color: Color(0xFF2E7D32), size: 20),
              const SizedBox(width: 8),
              Text("Alamat Perangkat: $address", 
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const Divider(height: 30),
          _buildPotHistorySection(1, filteredPots[1] ?? []),
          const SizedBox(height: 15),
          _buildPotHistorySection(2, filteredPots[2] ?? []),
          const SizedBox(height: 15),
          _buildPotHistorySection(3, filteredPots[3] ?? []),
        ],
      ),
    );
  }

  Widget _buildPotHistorySection(int potIndex, List<dynamic> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pot $potIndex",
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[700])),
        const SizedBox(height: 8),
        if (history.isEmpty)
          Text("Tidak ada riwayat", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey))
        else
          ...history.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item['moisturePercent']}% - ${item['soilCondition']}",
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
                    Text(item['timestampSensor'] ?? "-",
                        style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey)),
                  ],
                ),
                Text(item['action'] ?? "-",
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold,
                        color: (item['action'] ?? "").toString().contains("ON") ? Colors.blue : Colors.grey)),
              ],
            ),
          )).toList(),
      ],
    );
  }

  Widget _buildHeader() {
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
          Text("Riwayat Sensor", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text("Monitoring aktivitas 5 data terakhir per pot", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Text("Data riwayat tidak ditemukan", style: GoogleFonts.poppins(color: Colors.grey)));
  }
}
