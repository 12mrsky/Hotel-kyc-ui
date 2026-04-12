import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'guest_registration_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  final String email;

  const HomeScreen({super.key, required this.fullName, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOtherKYCView = false;
  bool _isPoliceAlertView = false;

  final PageController _sliderController = PageController(
    viewportFraction: 0.9,
  );
  int _currentSliderPage = 0;
  Timer? _sliderTimer;

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentSliderPage < 2)
        _currentSliderPage++;
      else
        _currentSliderPage = 0;
      if (_sliderController.hasClients) {
        _sliderController.animateToPage(
          _currentSliderPage,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _sliderController.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // --- UPDATED HEADER & SEARCH BAR ---
  Widget _buildHeader() {
    bool showBack = _isOtherKYCView || _isPoliceAlertView;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1C2E), Color(0xFF25284D)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      child: Column(
        children: [
          // Top Row: Profile & Logout
          Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: () => setState(() {
                    _isOtherKYCView = false;
                    _isPoliceAlertView = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF2D3152),
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showBack ? "NAVIGATION" : "WELCOME BACK,",
                      style: TextStyle(
                        color: Colors.blueAccent.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      showBack ? "Back to Dashboard" : widget.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Logout Button with subtle background
              IconButton(
                onPressed: () => _handleLogout(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Color(0xFFFF5252),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // SEARCH BAR
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Search guests, reports, or KYC...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.indigo,
                  size: 24,
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.indigo,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- POPUP HANDLERS (Same as before) ---
  void _showHotelDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.indigo),
            SizedBox(width: 10),
            Text(
              "Hotel Insights",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _detailTile(Icons.bed, "Total Occupancy", "85%"),
            _detailTile(Icons.people, "Guests In-house", "42"),
            _detailTile(Icons.verified_user, "KYC Completion", "98%"),
            const Divider(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "View Full Dashboard",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKYCActionPopup(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 35),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Start Scan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 10),
              Text(label),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEmergencyHelplines(context),
        backgroundColor: const Color(0xFFFF5252),
        elevation: 10,
        icon: const Icon(Icons.emergency, color: Colors.white),
        label: const Text(
          "POLICE SOS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(), // CALLED UPDATED HEADER
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("FEATURED UPDATES"),
                  _buildImageSlider(),
                  if (_isOtherKYCView) ...[
                    _sectionTitle("OTHER KYC METHODS"),
                    _buildOtherKYCGrid(),
                  ] else if (_isPoliceAlertView) ...[
                    _sectionTitle("ACTIVE SECURITY ALERTS"),
                    _buildPoliceAlertsList(),
                  ] else ...[
                    _sectionTitle("MAIN MANAGEMENT"),
                    _buildManagementRow(),
                  ],
                  _sectionTitle("ACTIVITY PULSE"),
                  _buildActivityPulse(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REMAINING UI BUILDERS (Management cards, pulse, etc.) ---
  Widget _buildManagementRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildCard(
            Icons.person_add,
            "Guest KYC",
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GuestRegistrationScreen(),
              ),
            ),
          ),
          _buildCard(
            Icons.business_center,
            "Hotel Panel",
            Colors.indigo,
            () => _showHotelDetails(context),
            isDark: true,
          ),
          _buildCard(
            Icons.fingerprint,
            "Other KYC",
            Colors.orange,
            () => setState(() => _isOtherKYCView = true),
          ),
          _buildCard(
            Icons.local_police,
            "Police",
            Colors.redAccent,
            () => setState(() => _isPoliceAlertView = true),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherKYCGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _buildActionCard(
          Icons.qr_code_scanner,
          "Aadhaar QR",
          Colors.orange,
          () => _showKYCActionPopup(
            "Aadhaar Scanner",
            "Scan the QR for fast entry.",
            Icons.qr_code_scanner,
            Colors.orange,
          ),
        ),
        _buildActionCard(
          Icons.fingerprint,
          "Fingerprint",
          Colors.blue,
          () => _showKYCActionPopup(
            "Biometric Scan",
            "Verify guest via fingerprint.",
            Icons.fingerprint,
            Colors.blue,
          ),
        ),
        _buildActionCard(
          Icons.face_unlock_outlined,
          "Face Match",
          Colors.purple,
          () => _showKYCActionPopup(
            "Face Recognition",
            "Position face in frame.",
            Icons.face_unlock_outlined,
            Colors.purple,
          ),
        ),
        _buildActionCard(
          Icons.edit_document,
          "Manual Upload",
          Colors.teal,
          () => _showKYCActionPopup(
            "Manual Entry",
            "Upload document photos.",
            Icons.edit_document,
            Colors.teal,
          ),
        ),
      ],
    );
  }

  // Activity Pulse & Helper Methods...
  Widget _buildActivityPulse() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _districtPulse("Raipur", "45", Colors.blueAccent),
          _districtPulse("Bastar", "05", Colors.orangeAccent),
          _districtPulse("Bilaspur", "12", Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _districtPulse(String name, String count, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.radar, color: color.withOpacity(0.2), size: 40),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showEmergencyHelplines(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "EMERGENCY CONTACTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _helplineTile("Police Station", "100", Colors.blue),
            _helplineTile("Emergency Line", "112", Colors.redAccent),
            _helplineTile("Ambulance", "108", Colors.pink),
            _helplineTile("Women Helpline", "1091", Colors.orange),
            _helplineTile("Cyber Financial Fraud", "1930", Colors.blue),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _helplineTile(String name, String num, Color col) {
    return ListTile(
      leading: Icon(Icons.call, color: col),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      trailing: Text(
        num,
        style: TextStyle(color: col, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap, {
    bool isDark = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115,
        height: 125,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isDark ? Colors.white : color, size: 35),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    // 1. Data list for images and titles
    final List<Map<String, String>> sliderData = [
      {
        'image':
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=500', // Hotel
        'title': 'Premium Hospitality',
        'desc': 'Managing guest stays with excellence.',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1554224155-6726b3ff858f?q=80&w=500', // Security/Police
        'title': 'Secure Operations',
        'desc': 'Real-time police network integration.',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1563986768609-322da13575f3?q=80&w=500', // KYC/Tech
        'title': 'Smart KYC',
        'desc': 'Instant identity verification system.',
      },
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _sliderController,
        itemCount: sliderData.length,
        onPageChanged: (index) => setState(() => _currentSliderPage = index),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: NetworkImage(sliderData[index]['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // 2. Added Gradient Overlay for a premium look
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sliderData[index]['title']!.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    sliderData[index]['desc']!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPoliceAlertsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 2,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const ListTile(
          leading: Icon(Icons.warning, color: Colors.red),
          title: Text(
            "Security Alert",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Flagged guest detected."),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          color: Colors.blueGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
