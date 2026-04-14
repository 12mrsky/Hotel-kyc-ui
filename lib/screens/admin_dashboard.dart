import 'dart:async';

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'hotel_registration_kyc.dart';
import '../services/guest_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final GuestService service = GuestService();
  late AnimationController _pulseController;
  final PageController _sliderController = PageController(
    viewportFraction: 0.9,
  );

  int _currentIndex = 0;
  Timer? _sliderTimer;
  int _sliderPage = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // --- AUTO SLIDE LOGIC (1 SECOND) ---
    _sliderTimer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_sliderPage < 1) {
        _sliderPage++;
      } else {
        _sliderPage = 0;
      }
      if (_sliderController.hasClients) {
        _sliderController.animateToPage(
          _sliderPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pulseController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            const SizedBox(height: 20),
            _sectionTitle("IMAGE SLIDER"),
            _imageSlider(),
            const SizedBox(height: 25),
            _sectionTitle("TOP STATS"),
            _horizontalStatsRow(context),
            const SizedBox(height: 25),
            _recentReportsSection(),
            const SizedBox(height: 25),
            _activityPulseSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _customBottomNav(),
    );
  }

  // --- 1. HEADER ---
  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 25),
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
                child: Icon(Icons.shield, color: Colors.blueAccent, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Admin Command Center",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
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
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune, color: Color(0xFF1E2139)),
        ),
      ],
    );
  }

  // --- 2. IMAGE SLIDER ---
  Widget _imageSlider() {
    // Define your data in a list for easy management
    final List<Map<String, String>> sliderItems = [
      {
        "label": "Hotel Security",
        "url":
            "https://images.unsplash.com/photo-1582564286939-400a311013a2?q=80&w=500",
      },
      {
        "label": "User KYC",
        "url":
            "https://images.unsplash.com/photo-1554224155-6726b3ff858f?q=80&w=500",
      },
      {
        "label": "Room Service",
        "url":
            "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=500",
      },
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _sliderController,
        // Use the list length so it updates automatically
        itemCount: sliderItems.length,
        itemBuilder: (context, index) {
          final item = sliderItems[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(item['url']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.bottomLeft,
              child: Text(
                item['label']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 3. ALL STATS CARDS ---
Widget _horizontalStatsRow(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16),

          // ✅ HOTELS
          FutureBuilder<List<dynamic>>(
            future: service.fetchAllHotels(),
            builder: (context, snapshot) {
              String count = "0";

              if (snapshot.connectionState == ConnectionState.waiting) {
                count = "...";
              } else if (snapshot.hasData) {
                count = snapshot.data!.length.toString();
              }

              return _statCard(
                context,
                Icons.hotel,
                "Hotels",
                count,
                "Registered",
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllHotelsListScreen(),
                    ),
                  );
                },
              );
            },
          ),

          // ✅ GUESTS
          FutureBuilder<List<dynamic>>(
            future: service.fetchGuestsRaw(),
            builder: (context, snapshot) {
              String count = "0";

              if (snapshot.connectionState == ConnectionState.waiting) {
                count = "...";
              } else if (snapshot.hasData) {
                count = snapshot.data!.length.toString();
              }

              return _statCard(
                context,
                Icons.bar_chart,
                "Guests",
                count,
                "Live Data",
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HotelWiseGuestSelection(),
                    ),
                  );
                },
                isLive: true,
              );
            },
          ),

          // ✅ KYC
          FutureBuilder<List<dynamic>>(
            future: service.fetchAllHotels(),
            builder: (context, snapshot) {
              String count = "0";

              if (snapshot.connectionState == ConnectionState.waiting) {
                count = "...";
              } else if (snapshot.hasData) {
                count = snapshot.data!.length.toString();
              }

              return _statCard(
                context,
                Icons.assignment_outlined,
                "KYC",
                count,
                "Hotel Reg",
                Colors.orange,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HotelRegistrationScreen(),
                    ),
                  );
                },
              );
            },
          ),

          // ✅ POLICE
          FutureBuilder<List<dynamic>>(
            future: service.fetchFlaggedGuests(),
            builder: (context, snapshot) {
              String count = "0";

              if (snapshot.connectionState == ConnectionState.waiting) {
                count = "...";
              } else if (snapshot.hasData) {
                count = snapshot.data!.length.toString();
              }

              return _statCard(
                context,
                Icons.security,
                "Police",
                count,
                "Alerts",
                Colors.indigo,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FlaggedUsersScreen(),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(width: 16),
        ],
      ),
    ),
  );
}

  Widget _statCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String sub,
    Color color,
    VoidCallback onTap, {
    bool isLive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sub,
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
                if (isLive) ...[const SizedBox(width: 5), _pulseDot()],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. RECENT REPORTS ---
  Widget _recentReportsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Reports",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              TextButton(onPressed: () {}, child: const Text("See More")),
            ],
          ),
          _reportTile(
            "New Hotel KYC Approved",
            "3 hours ago",
            "Covered",
            Colors.green,
            Icons.business,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HotelKycScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _reportTile(
            "Help Line Numbers",
            "15 min ago",
            "Active",
            Colors.red,
            Icons.headset_mic,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelplineScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _reportTile(
    String title,
    String time,
    String tag,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. ACTIVITY PULSE ---
  Widget _activityPulseSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pulseHeader(),
          const SizedBox(height: 15),
          Container(
            height: 280, // Taller for better district visibility
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF17192D),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Stack(
              children: [
                // 1. CHHATTISGARH DISTRICT MAP (Using local asset for reliability)
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Center(
                    child: Image.asset(
                      'assets/images/chhattisgarh_districts.png', // Add your local asset path
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            "Please add map to assets",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 2. DATA OVERLAYS (Geographically Positioned)
                // North: Bilaspur
                Positioned(
                  top: 40,
                  right: 60,
                  child: _mapPulsePoint("Bilaspur", "12 Active"),
                ),

                // Center: Raipur
                Positioned(
                  top: 120,
                  left: 100,
                  child: _mapPulsePoint("Raipur", "45 Active"),
                ),

                // South: Bastar
                Positioned(
                  bottom: 30,
                  left: 120,
                  child: _mapPulsePoint("Bastar", "05 Active"),
                ),

                // Subtle Tech Gradient Overlay
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pulseHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "District Activity",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.radar, color: Colors.green, size: 14),
              SizedBox(width: 6),
              Text(
                "LIVE: CG",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mapPulsePoint(String city, String stats) {
    return Column(
      children: [
        _pulseDot(),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Text(
                city,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stats,
                style: const TextStyle(color: Colors.greenAccent, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );
  }

  Widget _pulseDot() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(_pulseController.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _customBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelplineScreen()),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E2139),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: "Analysis",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.headset_mic),
          label: "Helpline",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_toggle_off),
          label: "Timeline",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}

class HotelKycScreen extends StatelessWidget {
  const HotelKycScreen({super.key});

  // Method to show the popup message
  void _showKycDetails(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2139),
          ),
        ),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "PROCEED",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Updated List with KYC Types
    final List<Map<String, dynamic>> kycTypes = [
      {
        "title": "OTP Based KYC",
        "subtitle": "Instant Verification",
        "icon": Icons.phonelink_ring,
        "color": Colors.blue,
        "description": "Verification via Aadhaar-linked mobile number OTP.",
      },
      {
        "title": "Biometric KYC",
        "subtitle": "Fingerprint/Iris",
        "icon": Icons.fingerprint,
        "color": Colors.green,
        "description": "Verify guest identity using a fingerprint scanner.",
      },
      {
        "title": "Offline XML",
        "subtitle": "Paperless KYC",
        "icon": Icons.file_present,
        "color": Colors.orange,
        "description": "Upload Aadhaar XML file for offline verification.",
      },
      {
        "title": "Manual Entry",
        "subtitle": "Document Upload",
        "icon": Icons.assignment_ind,
        "color": Colors.purple,
        "description": "Scan physical ID and enter details manually.",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Select KYC Method"),
        backgroundColor: const Color(0xFF1E2139),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aadhaar Verification Types",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2139),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.95, // Made cards slightly taller
                ),
                itemCount: kycTypes.length,
                itemBuilder: (context, index) {
                  final item = kycTypes[index];
                  return _buildKycCard(
                    context,
                    item["title"],
                    item["subtitle"],
                    item["icon"],
                    item["color"],
                    item["description"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKycCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showKycDetails(context, title, description),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E2139),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> helpNumbers = [
      {
        "title": "Police",
        "number": "100",
        "icon": Icons.local_police,
        "color": Colors.blue,
      },
      {
        "title": "Ambulance",
        "number": "108",
        "icon": Icons.medical_services,
        "color": Colors.red,
      },
      {
        "title": "Women Helpline",
        "number": "1091",
        "icon": Icons.woman,
        "color": Colors.pink,
      },
      {
        "title": "Tourism CG",
        "number": "1800-233-2233",
        "icon": Icons.map,
        "color": Colors.orange,
      },
      {
        "title": "Police, Fire, Medical",
        "number": "112",
        "icon": Icons.emergency_share,
        "color": Colors.blue,
      },
      {
        "title": "Cyber Financial Fraud",
        "number": "1930",
        "icon": Icons.lock_person,
        "color": Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Emergency Helplines"),
        backgroundColor: const Color(0xFF1E2139),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2139),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1, // Adjust for card height
                ),
                itemCount: helpNumbers.length,
                itemBuilder: (context, index) {
                  final item = helpNumbers[index];
                  return _buildHelplineCard(
                    item["title"],
                    item["number"],
                    item["icon"],
                    item["color"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelplineCard(
    String title,
    String number,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Add call logic here (using url_launcher)
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E2139),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- UPDATED NAVIGATION: HOTEL LIST -> DETAIL -> GUEST BUTTON ---

class AllHotelsListScreen extends StatelessWidget {
  const AllHotelsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GuestService service = GuestService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Registered Hotels"),
        backgroundColor: const Color(0xFF1e1e2d),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: service.fetchAllHotels(),
        builder: (context, snapshot) {

          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading hotels"));
          }

          // ✅ Data
          final data = snapshot.data;

          // 🔥 DEBUG (VERY IMPORTANT)
          debugPrint("HOTELS RESPONSE: $data");

          if (data == null || data.isEmpty) {
            return const Center(child: Text("No hotels found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final h = data[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.hotel_rounded, color: Colors.white),
                  ),
                  title: Text(
                    h['hotelName'] ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Owner: ${h['ownerName'] ?? 'Unknown'}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HotelDetailScreen(hotelData: h),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HotelDetailScreen extends StatelessWidget {
  final dynamic hotelData;
  const HotelDetailScreen({super.key, required this.hotelData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text(hotelData['hotelName'] ?? "Hotel Details"),
        backgroundColor: const Color(0xFF1E2139),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Full Hotel Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _detailRow(Icons.business, "Hotel Name", hotelData['hotelName']),
            _detailRow(Icons.person, "Owner Name", hotelData['ownerName']),
            _detailRow(Icons.phone, "Mobile Number", hotelData['mobileNumber']),
            _detailRow(Icons.pin, "GST Number", hotelData['gstNumber']),
            _detailRow(
              Icons.location_on,
              "Full Address",
              hotelData['hotelAddress'],
            ),
            const Divider(height: 40),
            const Text(
              "Management Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HotelRegistrationScreen(),
                ),
              ),
              icon: const Icon(Icons.person_add),
              label: const Text("REGISTER NEW GUEST"),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HotelWiseGuestSelection(),
                ),
              ),
              icon: const Icon(Icons.people),
              label: const Text("VIEW GUEST LIST"),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelWiseGuestSelection extends StatelessWidget {
  const HotelWiseGuestSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final GuestService service = GuestService();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Guest Monitoring"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: service
            .fetchGuestsRaw(), // Ensure this calls the /api/Guest/all-guests endpoint
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No guests registered yet."));
          }
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final g = data[index];
              return _buildListTile(
                context,
                g['guestName'] ?? "Unknown Guest",
                "Hotel: ${g['hotelName']} | Room: ${g['roomNumber']}",
                Icons.person,
                Colors.green,
                () {
                  _showDetails(context, "Detailed Guest Profile", [
                    _detailRow(Icons.person, "Guest Name", g['guestName']),
                    _detailRow(Icons.hotel, "Hotel Name", g['hotelName']),
                    _detailRow(Icons.meeting_room, "Room No", g['roomNumber']),
                    _detailRow(Icons.phone, "Mobile No", g['mobileNumber']),
                    _detailRow(
                      Icons.fingerprint,
                      "Identity",
                      "[Aadhaar Redacted]",
                    ),
                    _detailRow(Icons.login, "Check-In", g['checkIn']),
                    _detailRow(
                      Icons.logout,
                      "Check-Out",
                      g['checkOut'] ?? "Present",
                    ),
                  ]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FlaggedUsersScreen extends StatelessWidget {
  const FlaggedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GuestService service = GuestService();
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5), // Light red tint for alert feel
      appBar: AppBar(
        title: const Text("Security Alerts"),
        backgroundColor: Colors.indigo[900], // Darker indigo for authority
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: service.fetchFlaggedGuests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text("No security alerts at this time."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final g = data[index];
              return _buildListTile(
                context,
                g['guestName'] ?? "Unknown Suspect",
                "Alert: ${g['policeRemarks']}",
                Icons.gpp_maybe,
                Colors.red,
                () {
                  _showDetails(context, "Police Security Alert", [
                    // --- Status Badge ---
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "HIGH PRIORITY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Police Details ---
                    _detailRow(
                      Icons.warning_amber_rounded,
                      "Incident",
                      g['policeRemarks'],
                      color: Colors.red,
                    ),
                    _detailRow(
                      Icons.local_police,
                      "Reporting Station",
                      g['policeStation'] ?? "Raipur Central",
                    ),
                    _detailRow(
                      Icons.person_search,
                      "Officer",
                      g['assignedOfficer'] ?? "Inspector S. Dewangan",
                    ),
                    _detailRow(Icons.hotel, "Current Location", g['hotelName']),
                    _detailRow(
                      Icons.calendar_month,
                      "Flagged Date",
                      g['flaggedDate'] ?? "11-04-2026",
                    ),
                    _detailRow(
                      Icons.fingerprint,
                      "Aadhaar Identity",
                      "[Aadhaar Redacted]",
                      color: Colors.blueGrey,
                    ),
                    const Divider(height: 30),
                    const Text(
                      "Required Action: Contact local authorities immediately and do not permit check-out.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
// --- SHARED UI HELPERS ---

Widget _buildListTile(
  BuildContext context,
  String title,
  String sub,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        sub,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    ),
  );
}

void _showDetails(BuildContext context, String title, List<Widget> details) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 30),
          ...details,
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1e1e2d),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CLOSE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _detailRow(
  IconData icon,
  String label,
  dynamic value, {
  Color color = Colors.indigo,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 15),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value?.toString() ?? "N/A",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
