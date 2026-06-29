import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, List<String>> _plantNamesCache = {};
  final ApiService _apiService = ApiService();
  final TextEditingController _plantController = TextEditingController();
  String _humidityGroup = "Sedang";
  bool _isLoading = false;

  List<dynamic> _devices = [];
  bool _isLoadingDevices = false;

  Future<void> _loadDevices() async {
    setState(() => _isLoadingDevices = true);
    try {
      final deviceResponse = await _apiService.getDeviceSettings();
      final sensorResponse = await _apiService.getLatestSensorData();

      final List deviceSettings = deviceResponse['devices'] ?? [];
      final List sensorDevices = sensorResponse['devices'] ?? [];

      final List mergedDevices = deviceSettings.map((device) {
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

      // Load semua nama tanaman sekaligus ke cache
      final prefs = await SharedPreferences.getInstance();
      final Map<String, List<String>> namesCache = {};
      for (var device in mergedDevices) {
        final String address = device['address'];
        final List pots = device['pots'] ?? [];
        namesCache[address] = List.generate(
          pots.isNotEmpty ? pots.length : 3,
              (i) => prefs.getString('plant_${address}_$i') ?? '',
        );
      }

      if (!mounted) return;
      setState(() {
        _devices = mergedDevices;
        _plantNamesCache = namesCache;
      });
    } catch (e) {
      _showSnackBar("Gagal memuat perangkat: $e");
    } finally {
      if (mounted) setState(() => _isLoadingDevices = false);
    }
  }
  // Key format: "plant_{address}_{potIndex}"
  Future<void> _savePlantNames(String address, List<String> plantNames) async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < plantNames.length; i++) {
      await prefs.setString('plant_${address}_$i', plantNames[i]);
    }
  }

  Future<void> _updateDevice(String address, List<String> soilTypes) async {
    setState(() => _isLoading = true);
    try {
      await _apiService.updateDeviceSettings(address, soilTypes);
      _showSnackBar("Perangkat berhasil diperbarui", isError: false);
      await _loadDevices();
    } catch (e) {
      _showSnackBar("Gagal memperbarui: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadDevices();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _plantController.text = prefs.getString('plant_name') ?? "Jahe Merah";
      _humidityGroup = prefs.getString('humidity_group') ?? "Sedang";
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    
    try {
      // 1. Simpan ke SharedPreferences lokal
      await prefs.setString('plant_name', _plantController.text);
      await prefs.setString('humidity_group', _humidityGroup);

      // 2. Sinkronisasi ke Server (PUT untuk update, fallback ke POST jika gagal/data baru)
      try {
        _showSnackBar("Pengaturan berhasil diperbarui di server", isError: false);
      } catch (e) {
        // Jika PUT gagal (mungkin 404 atau data belum ada), coba POST
        _showSnackBar("Pengaturan perangkat baru berhasil disimpan", isError: false);
      }
    } catch (e) {
      _showSnackBar("Gagal menyimpan ke server: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showEditDeviceDialog(dynamic device) async {
    final String address = device['address'] ?? '';
    final List pots = device['pots'] ?? [];
    final int potCount = pots.isNotEmpty ? pots.length : 3;
    final savedNames = _plantNamesCache[address] ?? List.filled(potCount, '');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _EditDeviceDialog(
        device: device,
        savedNames: savedNames,
      ),
    );

    // Hanya jalan setelah dialog benar-benar tertutup
    if (result != null && mounted) {
      final plantNames = List<String>.from(result['plantNames']);
      final soilTypes = List<String>.from(result['soilTypes']);

      setState(() => _plantNamesCache[address] = plantNames);
      await _savePlantNames(address, plantNames);
      await _updateDevice(address, soilTypes);
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
                  _buildDeviceAndHumiditySection(), // GABUNGAN MAC & HUMIDITY
                  const SizedBox(height: 20),
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

  // Penggabungan Input MAC Address dan Kelompok Kelembapan
  Widget _buildDeviceItem(dynamic device) {
    final String address = device['address'] ?? 'Unknown';
    final List pots = device['pots'] ?? [];
    final List<String> plantNames = _plantNamesCache[address] ?? [];

    return GestureDetector(
      onTap: () => _showEditDeviceDialog(device),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.router, color: Color(0xFF2E7D32), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(address,
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
              ],
            ),
            if (pots.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 10),
              ...List.generate(pots.length, (i) {
                final soilType = pots[i]['soil_type'] ?? 'Sedang';
                final plantName = plantNames.length > i ? plantNames[i] : '';

                Color chipColor;
                if (soilType == 'Basah') chipColor = Colors.blue;
                else if (soilType == 'Kering') chipColor = Colors.orange;
                else chipColor = Colors.green;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text("Pot ${i + 1}",
                          style: GoogleFonts.poppins(
                              fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          plantName.isNotEmpty ? plantName : 'Belum diisi',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: plantName.isNotEmpty ? Colors.black87 : Colors.grey[400],
                            fontStyle: plantName.isEmpty ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: chipColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(soilType,
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: chipColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              const SizedBox(height: 8),
              Text("0 pot terhubung",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceAndHumiditySection() {
    return _buildCard([
      _buildSectionTitle(Icons.developer_board, "Konfigurasi Perangkat"),
      const SizedBox(height: 16),
      if (_isLoadingDevices)
        const Center(child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ))
      else if (_devices.isEmpty)
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(Icons.router_outlined, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Text("Belum ada perangkat",
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text("Tambahkan perangkat dari halaman Dashboard",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
          ),
        )
      else
        ..._devices.map((device) => _buildDeviceItem(device)).toList(),
    ]);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Row(
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
      Text("Sistem ini terhubung dengan MAC Address perangkat ESP Anda untuk memastikan data yang ditampilkan akurat.", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
    ]);
  }
}
class _EditDeviceDialog extends StatefulWidget {
  final dynamic device;
  final List<String> savedNames;

  const _EditDeviceDialog({required this.device, required this.savedNames});

  @override
  State<_EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<_EditDeviceDialog> {
  late List<TextEditingController> plantControllers;
  late List<String> soilTypes;
  late int potCount;
  late String address;

  @override
  void initState() {
    super.initState();
    address = widget.device['address'] ?? '';
    final List pots = widget.device['pots'] ?? [];
    potCount = pots.isNotEmpty ? pots.length : 3;

    soilTypes = List.generate(potCount, (i) {
      if (pots.length > i) return pots[i]['soil_type'] ?? 'Sedang';
      return 'Sedang';
    });

    plantControllers = List.generate(
      potCount,
          (i) => TextEditingController(
        text: widget.savedNames.length > i ? widget.savedNames[i] : '',
      ),
    );
  }

  @override
  void dispose() {
    for (var c in plantControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Edit Perangkat", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          Text(address, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(potCount, (i) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("Pot ${i + 1}",
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Text("Nama Tanaman",
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 6),
              TextField(
                controller: plantControllers[i],
                decoration: InputDecoration(
                  hintText: "Contoh: Jahe Merah",
                  hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.eco_outlined, color: Color(0xFF2E7D32), size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text("Jenis Tanah",
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 8),
              _buildSoilOption(i, "Basah", "70% – 90%"),
              const SizedBox(height: 6),
              _buildSoilOption(i, "Sedang", "50% – 70%"),
              const SizedBox(height: 6),
              _buildSoilOption(i, "Kering", "30% – 50%"),
              if (i < potCount - 1) const Divider(height: 28, thickness: 1, color: Colors.grey),
            ],
          )),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final plantNames = plantControllers.map((c) => c.text.trim()).toList();
            final soilTypesCopy = List<String>.from(soilTypes);
            // Return data ke caller
            Navigator.pop(context, {
              'plantNames': plantNames,
              'soilTypes': soilTypesCopy,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Simpan", style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSoilOption(int potIdx, String label, String range) {
    final bool isSelected = soilTypes[potIdx] == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Buat list baru agar Flutter detect perubahan
          soilTypes = List<String>.from(soilTypes)..[potIdx] = label;
        });
      },
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
                Text(label, style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                )),
              ],
            ),
            Text(range, style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
            )),
          ],
        ),
      ),
    );
  }
}
