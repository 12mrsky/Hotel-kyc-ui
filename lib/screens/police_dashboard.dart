import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/guest_service.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  final GuestService _service = GuestService();
  String _searchQuery = "";

  // ✅ BLINK
  bool _blink = false;

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return false;
      setState(() => _blink = !_blink);
      return true;
    });
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // ================= HEADER =================
  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2139),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF3D4471),
                child: Icon(Icons.security_rounded,
                    color: Colors.blueAccent, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Security Command",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("LIVE SURVEILLANCE • CG",
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.power_settings_new,
                    color: Colors.redAccent),
                onPressed: () => _handleLogout(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
        decoration: const InputDecoration(
          hintText: "Search ID or Name...",
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ================= TOP STATS =================
  Widget _topStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Operations Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),

          FutureBuilder<List<dynamic>>(
            future: _service.fetchFlaggedGuests(),
            builder: (context, snapshot) {
              int alertCount = 3; // ✅ default

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                alertCount = snapshot.data!.length;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard("Hotels", "12",
                      Icons.business_rounded, Colors.blue),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _blink ? 1 : 0.3,
                    child: _statCard("Alerts", alertCount.toString(),
                        Icons.warning_amber_rounded, Colors.red),
                  ),

                  _statCard("Live", "145",
                      Icons.sensors_rounded, Colors.green),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String val, IconData icon, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width / 3) - 20,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(val,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  // ================= ALERT LIST =================
  Widget _buildAlertListFeed() {
    return FutureBuilder<List<dynamic>>(
      future: _service.fetchFlaggedGuests(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];

        List<dynamic> filtered = data
            .where((g) => g['guestName']
                .toString()
                .toLowerCase()
                .contains(_searchQuery))
            .toList();

        // ✅ DEFAULT ALERTS
        if (filtered.isEmpty) {
          filtered = [
            {'guestName': 'Unknown Person', 'hotelName': 'City Lodge'},
            {'guestName': 'Rahul Sharma', 'hotelName': 'Grand Hotel'},
            {'guestName': 'Unverified Guest', 'hotelName': 'Sunrise Inn'},
          ];
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final g = filtered[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: () => _showGuestDetails(context, g),
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade50,
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Colors.red),
                ),
                title: Text(g['guestName']),
                subtitle: Text("At Hotel: ${g['hotelName']}"),
              ),
            );
          },
        );
      },
    );
  }

  // ================= MAIN =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          _headerSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _topStatsSection(),
                  const SizedBox(height: 10),
                  _buildAlertListFeed(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 5),
      child: Text(title,
          style: const TextStyle(color: Colors.white38, fontSize: 10)),
    );
  }

  Widget _darkInfoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white30)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}