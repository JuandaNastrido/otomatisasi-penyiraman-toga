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
  String namaKota = "Mendeteksi...";

  // Data Perangkat & Pot
  List<dynamic> devices = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _showManualWateringDialog() {
    String? selectedAddress = devices.isNotEmpty ? devices[0]['address'] : null;
    int? selectedPotIndex; // null = semua pot
    int selectedDuration = 5;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Siram Manual", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            // Ambil list pot dari device yang dipilih
            final selectedDevice = devices.firstWhere(
                  (d) => d['address'] == selectedAddress,
              orElse: () => {'pots': []},
            );
            final List pots = selectedDevice['pots'] ?? [];

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pilih perangkat
                  Text("Pilih Perangkat",
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  ...devices.map((device) {
                    final address = device['address'];
                    final isSelected = selectedAddress == address;
                    return GestureDetector(
                      onTap: () => setStateDialog(() {
                        selectedAddress = address;
                        selectedPotIndex = null; // reset pilihan pot
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F5E9) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(address,
                                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  if (pots.isNotEmpty) ...[
                    const Divider(height: 24, thickness: 1, color: Colors.grey),
                    Text("Pilih Pot",
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                    const SizedBox(height: 8),

                    // Opsi per pot
                    ...pots.map((pot) {
                      final potIdx = pot['potIndex'] as int? ?? 0;
                      final isSelected = selectedPotIndex == potIdx;
                      return GestureDetector(
                        onTap: () => setStateDialog(() => selectedPotIndex = potIdx),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8F5E9) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.check_circle : Icons.circle_outlined,
                                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text("Pot $potIdx",
                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],

                  const Divider(height: 24, thickness: 1, color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Durasi",
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                      Text("$selectedDuration detik",
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: selectedDuration.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      activeColor: const Color(0xFF2E7D32),
                      inactiveColor: Colors.grey[200],
                      onChanged: (v) => setStateDialog(() => selectedDuration = v.toInt()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1 detik", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
                      Text("60 detik", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedAddress == null) return;
              Navigator.pop(context);
              await _sendManualWatering(selectedAddress!, selectedDuration, potIndex: selectedPotIndex);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Siram Sekarang", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _sendManualWatering(String address, int duration, {int? potIndex}) async {
    try {
      await _apiService.sendManualWatering(address, duration, potIndex: potIndex);
      if (!mounted) return;
      final potLabel = potIndex != null ? "Pot $potIndex" : "Semua Pot";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Perintah siram dikirim ke $address - $potLabel selama $duration detik",
              style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
      await _fetchData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal: ${e.toString().replaceAll('Exception: ', '')}",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddDeviceDialog() {
    final TextEditingController macController = TextEditingController();
    // Default 3 pot, masing-masing 'Sedang'
    List<String> soilTypes = ['Sedang', 'Sedang', 'Sedang'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Tambah Perangkat", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: macController,
                  decoration: InputDecoration(
                    labelText: "MAC Address ESP",
                    hintText: "XX:XX:XX:XX:XX:XX",
                    labelStyle: GoogleFonts.poppins(fontSize: 13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.router, color: Color(0xFF2E7D32)),
                  ),
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                const Divider(height: 28, thickness: 1, color: Colors.grey),
                Row(
                  children: [
                    const Icon(Icons.water_drop_outlined, color: Color(0xFF2E7D32), size: 20),
                    const SizedBox(width: 8),
                    Text("Jenis Tanah per Pot", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(3, (i) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pot ${i + 1}", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                    const SizedBox(height: 8),
                    _buildSoilOption(setStateDialog, "Basah", "70% – 90%", soilTypes[i], (val) => soilTypes[i] = val),
                    const SizedBox(height: 6),
                    _buildSoilOption(setStateDialog, "Sedang", "50% – 70%", soilTypes[i], (val) => soilTypes[i] = val),
                    const SizedBox(height: 6),
                    _buildSoilOption(setStateDialog, "Kering", "30% – 50%", soilTypes[i], (val) => soilTypes[i] = val),
                    if (i < 2) const Divider(height: 24, thickness: 1, color: Colors.grey),
                  ],
                )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final mac = macController.text.trim();
              if (mac.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("MAC Address tidak boleh kosong", style: GoogleFonts.poppins())),
                );
                return;
              }
              Navigator.pop(context);
              await _saveDevice(mac, soilTypes);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Simpan", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDevice(String mac, List<String> soilTypes) async {
    setState(() {
      devices.add({'address': mac, 'pots': []});
    });

    try {
      await _apiService.saveDeviceSettings(mac, soilTypes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Perangkat berhasil ditambahkan", style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
      await _fetchData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal: ${e.toString().replaceAll('Exception: ', '')}", style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => devices.removeWhere((d) => d['address'] == mac));
    }
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

      // Pemanggilan API tanpa email (menggunakan token)
      final Map<String, dynamic> sensorResponse = await _apiService
          .getLatestSensorData();
      final Map<String, dynamic> deviceResponse = await _apiService
          .getDeviceSettings();
      final Map<String, dynamic> weatherData = await _apiService
          .getWeatherData();

      if (!mounted) return;

      setState(() {
        final List sensorDevices = sensorResponse['devices'] ?? [];
        final List deviceSettings = deviceResponse['devices'] ?? [];

        devices = deviceSettings.map((device) {
          final String address = device['address'];
          final sensorDevice = sensorDevices.firstWhere(
            (d) => d['address'] == address,
            orElse: () => {'address': address, 'pots': []},
          );
          return {
            'address': address,
            'soil_type': device['soil_type'],
            'pots': sensorDevice['pots'] ?? [],
          };
        }).toList();

        statusKoneksi = devices.isNotEmpty
            ? "Online (${devices.length} Perangkat)"
            : "Online";

        DateTime now = DateTime.now();
        tanggal = DateFormat('EEEE, d MMMM yyyy', 'id').format(now);
        jam = DateFormat('HH:mm').format(now) + " WIB";

        if (weatherData.isNotEmpty) {
          kelembapanUdara = "${weatherData['kelembaban']}%";
          suhu = "${weatherData['suhu'].toInt()}°C";
          cuaca = (weatherData['kondisi'] ?? "TIDAK DIKETAHUI")
              .toString()
              .toUpperCase();
          prakiraanHujan = "${weatherData['prakiraan_hujan']}%";
          namaKota = weatherData['kota'] ?? "Tidak diketahui";
        }

        isLoading = false;
      });
    } catch (e) {
      print("Error Dashboard: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  double _parsePercent(String text) =>
      (double.tryParse(text.replaceAll('%', '')) ?? 0) / 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            )
          : Column(
              children: [
                _buildFixedHeader(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchData,
                    color: const Color(0xFF2E7D32),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWeatherCard(),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status Sensor Tanah",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _showAddDeviceDialog,
                                icon: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Tambah",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Ganti bagian if (devices.isEmpty):
                          if (devices.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.router_outlined,
                                      size: 48,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Belum ada perangkat terhubung",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Tekan tombol Tambah untuk\nmenambahkan perangkat ESP",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[400],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...devices
                                .map(
                                  (device) => _buildDeviceStatusSection(device),
                                )
                                .toList(),

                          const SizedBox(height: 30),
                          _buildWateringSystemCard(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSoilOption(
    StateSetter setStateDialog,
    String label,
    String range,
    String selected,
    Function(String) onSelect,
  ) {
    final bool isSelected = selected == label;
    return GestureDetector(
      onTap: () => setStateDialog(() => onSelect(label)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected
                        ? const Color(0xFF2E7D32)
                        : Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              range,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
              ),
            ),
          ],
        ),
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
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildThreePotsRow(pots, address), // tambah address
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildFixedHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 10,
        20,
        20,
      ),
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
                    statusKoneksi,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "User",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tanggal,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    jam,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_queue_outlined,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cuaca,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Kelembapan udara: $kelembapanUdara",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                suhu,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Prakiraan potensi hujan hari ini:",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              ),
              Text(
                prakiraanHujan,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _parsePercent(prakiraanHujan),
              backgroundColor: Colors.white.withOpacity(0.3),
              color: Colors.white,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10), // tambah ini
          Row(
            // tambah ini
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                namaKota,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThreePotsRow(List<dynamic> pots, String address) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pots.take(3).map((pot) => _buildIndividualPotCard(pot, address)).toList(),
    );
  }

  Widget _buildIndividualPotCard(dynamic pot, String address) {
    String moisture = "${pot['moisturePercent']}%";
    String condition = pot['soilCondition'] ?? "Normal";
    String action = pot['action'] ?? "OFF";
    int potIdx = pot['potIndex'] ?? 0;
    bool isPumping = action.toLowerCase().contains("on");

    Color statusColor = isPumping ? Colors.blue : Colors.green;
    if (condition.toLowerCase().contains("kering")) statusColor = Colors.orange;

    return FutureBuilder<String>(
      // potIndex dari server mulai dari 1, SharedPreferences dari 0
      future: SharedPreferences.getInstance().then(
            (prefs) => prefs.getString('plant_${address}_${potIdx - 1}') ?? '',
      ),
      builder: (context, snapshot) {
        final plantName = snapshot.data ?? '';

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
              Text("Pot $potIdx",
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              // Nama tanaman jika ada
              if (plantName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    plantName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 9, color: Colors.green[700], fontWeight: FontWeight.w500),
                  ),
                ),
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
                  Text(moisture,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                ],
              ),
              const SizedBox(height: 8),
              Text(condition,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
              const SizedBox(height: 4),
              Text(isPumping ? "SIRAM" : "MATI",
                  style: GoogleFonts.poppins(fontSize: 8, color: isPumping ? Colors.blue : Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWateringSystemCard() {
    bool isAnyPumping = false;
    for (var device in devices) {
      for (var pot in (device['pots'] as List? ?? [])) {
        if ((pot['action'] ?? "").toString().toLowerCase().contains("on")) {
          isAnyPumping = true;
          break;
        }
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sistem Penyiraman Otomatis",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "STATUS: ",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        isAnyPumping ? "MENYIRAM" : "READY",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isAnyPumping ? Colors.blue : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aturan aktif:",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\"Jika kelembaban tanah berada di bawah ambang batas $humidityGroup ($humidityRangeText), pompa akan aktif.\"",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.green[900],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: devices.isEmpty ? null : _showManualWateringDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text("Siram Manual Sekarang",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
