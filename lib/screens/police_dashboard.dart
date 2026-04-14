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

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // --- 1. FULL DETAIL TACTICAL DARK MODAL ---
  void _showGuestDetails(BuildContext context, dynamic g) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Color(0xFF0F1222), // Tactical Dark Background
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Report Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.gpp_bad_rounded,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SECURITY REPORT",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "PRIORITY: HIGH • ACTION REQUIRED",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 40, color: Colors.white10),

              // SECTION 1: IDENTITY
              _sectionHeader("SUBJECT IDENTITY"),
              _darkInfoTile(Icons.person_outline, "Full Name", g['guestName']),
              _darkInfoTile(
                Icons.fingerprint,
                "Aadhaar ID",
                g['aadhaarNumber'] ?? "NOT PROVIDED",
              ),
              _darkInfoTile(
                Icons.phone_android_rounded,
                "Contact",
                g['mobileNumber'],
              ),

              const SizedBox(height: 20),

              // SECTION 2: LOCATION
              _sectionHeader("CURRENT LOCATION"),
              _darkInfoTile(
                Icons.business_rounded,
                "Hotel Name",
                g['hotelName'] ?? 'N/A',
              ),
              _darkInfoTile(
                Icons.room_service_rounded,
                "Room Number",
                g['roomNumber'] ?? "Pending",
              ),
              _darkInfoTile(
                Icons.history_toggle_off,
                "Check-In",
                g['checkInTime'] ?? 'N/A',
              ),

              const SizedBox(height: 20),

              // SECTION 3: POLICE REMARKS
              _sectionHeader("CRITICAL ALERT DETAILS"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                ),
                child: Text(
                  g['policeRemarks'] ??
                      "Subject flagged for manual verification by surveillance team.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.local_police_rounded),
                      label: const Text(
                        "SEND FORCE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.call, color: Colors.greenAccent),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 2. STICKY COMMAND CENTER HEADER ---
  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2139), // Dark Navy
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
                child: Icon(
                  Icons.security_rounded,
                  color: Colors.blueAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Security Command",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "LIVE SURVEILLANCE • CG",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.redAccent,
                ),
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
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // --- 3. TOP STATS SECTION ---
  Widget _topStatsSection() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Operations Summary",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),

        FutureBuilder<List<dynamic>>(
          future: _service.fetchFlaggedGuests(),
          builder: (context, snapshot) {
            int alertCount = 1; // ✅ default 1

            if (snapshot.connectionState == ConnectionState.waiting) {
              alertCount = 1;
            } else if (snapshot.hasData) {
              alertCount =
                  snapshot.data!.isEmpty ? 1 : snapshot.data!.length;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard(
                  "Hotels",
                  "12", // ⚠️ unchanged (as you said no logic change)
                  Icons.business_rounded,
                  Colors.blue,
                ),

                _statCard(
                  "Alerts",
                  alertCount.toString(), // ✅ dynamic
                  Icons.warning_amber_rounded,
                  Colors.red,
                ),

                _statCard(
                  "Live",
                  "145", // unchanged
                  Icons.sensors_rounded,
                  Colors.green,
                ),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          _headerSection(), // Sticky Header
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _topStatsSection(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Critical Alert Feed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildAlertListFeed() {
    return FutureBuilder<List<dynamic>>(
      future: _service.fetchFlaggedGuests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        final data = snapshot.data ?? [];
        final filtered = data
            .where(
              (g) => g['guestName'].toString().toLowerCase().contains(
                _searchQuery,
              ),
            )
            .toList();

        if (filtered.isEmpty)
          return const Text(
            "No Threats Detected",
            style: TextStyle(color: Colors.grey),
          );

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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListTile(
                onTap: () => _showGuestDetails(context, g),
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade50,
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                title: Text(
                  g['guestName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  "At Hotel: ${g['hotelName']}",
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- HELPERS ---
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _darkInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueAccent.shade100),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white30, fontSize: 10),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
