import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
              child: _buildStatsGrid(),
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
                      "Riwayat Sistem",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "Data Aktivitas Terakhir",
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
                  Text("Rabu, 22 April 2026", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                  Text("09:41 WIB", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
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
                  value: "7x",
                  label: "Total Penyiraman",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  color: const Color(0xFFE8F5E9),
                  icon: Icons.bar_chart,
                  iconColor: Colors.redAccent,
                  value: "58%",
                  label: "Rata-rata kelembapan",
                  customIcon: _buildChartIcon(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  color: const Color(0xFFE3F2FD),
                  icon: Icons.cloudy_snowing,
                  iconColor: Colors.blue,
                  value: "2",
                  label: "Hari Hujan",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  color: const Color(0xFFFFF3E0),
                  icon: Icons.water_drop,
                  iconColor: Colors.blue,
                  value: "5.6L",
                  label: "Total air terpakai",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required Color color,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    Widget? customIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          customIcon ?? Icon(icon, color: iconColor, size: 32),
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

  Widget _buildChartIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(width: 6, height: 14, color: Colors.redAccent),
        const SizedBox(width: 3),
        Container(width: 6, height: 22, color: Colors.blueAccent),
        const SizedBox(width: 3),
        Container(width: 6, height: 11, color: Colors.purpleAccent),
      ],
    );
  }
}
