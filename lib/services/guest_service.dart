// import 'dart:convert';
// import 'package:flutter/foundation.dart'; // Required for debugPrint
// import 'package:http/http.dart' as http;
// import '../models/guest_model.dart';
// import 'api_service.dart';

// class GuestService {
//   // Use localhost for Chrome. Change to 10.0.2.2 for Android Emulator.
//   // static const String baseUrl = "https://localhost:7295/api/Guest";
// final url = Uri.parse("${ApiService.baseUrl}/Guest");

//   // --- 1. REGISTER GUEST (POST) ---
//   Future<http.Response> registerGuest(Map<String, dynamic> data) async {
//     try {
//       return await http.post(
//         Uri.parse('$baseUrl/register-guest'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );
//     } catch (e) {
//       debugPrint("Register Guest Error: $e");
//       return http.Response(jsonEncode({"message": "Error: $e"}), 500);
//     }
//   }

//   // --- 2. FETCH FLAGGED GUESTS (GET) ---
//   Future<List<dynamic>> fetchFlaggedGuests() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/flagged-guests'));
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       return [];
//     } catch (e) {
//       debugPrint("Flagged Fetch Error: $e");
//       return [];
//     }
//   }

//   // --- 3. FETCH ALL HOTELS (GET) ---
//   Future<List<dynamic>> fetchAllHotels() async {
//     try {
//       // Corrected URL: Removed extra "/Guest"
//       final response = await http.get(
//         Uri.parse('$baseUrl/all-registered-hotels'),
//       );
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       return [];
//     } catch (e) {
//       debugPrint("Hotel Fetch Error: $e");
//       return [];
//     }
//   }

//   // --- 4. FETCH GUESTS BY SPECIFIC HOTEL (GET) ---
//   Future<List<dynamic>> fetchGuestsByHotel(int hotelId) async {
//     try {
//       // Corrected URL: Removed extra "/Guest"
//       final response = await http.get(
//         Uri.parse('$baseUrl/hotel-guests/$hotelId'),
//       );
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       return [];
//     } catch (e) {
//       debugPrint("Fetch Guests by Hotel Error: $e");
//       return [];
//     }
//   }

//   // --- 5. FETCH ALL GUESTS RAW (DIRECT LIST) ---
//   Future<List<dynamic>> fetchGuestsRaw() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/all-guests'));
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       return [];
//     } catch (e) {
//       debugPrint("Fetch Guests Raw Error: $e");
//       return [];
//     }
//   }

//   // --- 6. FETCH ALL GUESTS (MODEL MAPPED) ---
//   Future<List<Guest>> fetchGuests() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/all-guests'));
//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);
//         return jsonResponse.map((data) => Guest.fromJson(data)).toList();
//       }
//       return [];
//     } catch (e) {
//       debugPrint("Fetch Guests Error: $e");
//       return [];
//     }
//   }
// }

// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // // Make sure this path points to your guest_model.dart file
// // import '../models/guest_model.dart';

// // class GuestService {
// //   // Use localhost for Chrome. If testing on Android Emulator later, change to 10.0.2.2
// //   static const String baseUrl = "https://localhost:7295/api/Guest";

// //   // POST: Register Guest
// //   Future<http.Response> registerGuest(Map<String, dynamic> data) async {
// //     try {
// //       return await http.post(
// //         Uri.parse('$baseUrl/register-guest'),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode(data),
// //       );
// //     } catch (e) {
// //       return http.Response(jsonEncode({"message": "Error: $e"}), 500);
// //     }
// //   }

// //   Future<List<dynamic>> fetchFlaggedGuests() async {
// //     try {
// //       // Flagged guests ka naya endpoint
// //       final response = await http.get(Uri.parse('$baseUrl/flagged-guests'));
// //       if (response.statusCode == 200) {
// //         return json.decode(response.body);
// //       }
// //       return [];
// //     } catch (e) {
// //       print("Flagged Fetch Error: $e");
// //       return [];
// //     }
// //   }

// //   Future<List<dynamic>> fetchAllHotels() async {
// //     final response = await http.get(
// //       Uri.parse('$baseUrl/Guest/all-registered-hotels'),
// //     );
// //     if (response.statusCode == 200) {
// //       return json.decode(response.body);
// //     }
// //     return [];
// //   }

// //   Future<List<dynamic>> fetchGuestsByHotel(int hotelId) async {
// //     final response = await http.get(
// //       Uri.parse('$baseUrl/Guest/hotel-guests/$hotelId'),
// //     );
// //     if (response.statusCode == 200) {
// //       return json.decode(response.body);
// //     }
// //     return [];
// //   }

// //   // guest_service.dart mein add karein
// //   Future<List<dynamic>> fetchGuestsRaw() async {
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/all-guests'));
// //       if (response.statusCode == 200) {
// //         return json.decode(response.body); // Direct List return karein
// //       }
// //       return [];
// //     } catch (e) {
// //       return [];
// //     }
// //   }

// //   // GET: Fetch all guests for Admin Dashboard
// //   Future<List<Guest>> fetchGuests() async {
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/all-guests'));
// //       if (response.statusCode == 200) {
// //         List jsonResponse = json.decode(response.body);
// //         return jsonResponse.map((data) => Guest.fromJson(data)).toList();
// //       } else {
// //         return [];
// //       }
// //     } catch (e) {
// //       print("Fetch Guests Error: $e");
// //       return [];
// //     }
// //   }
// // }
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/guest_model.dart';
import 'api_service.dart';

class GuestService {

  // ✅ Guest API
  static const String guestBaseUrl =
      "https://hotel-kyc-api22.onrender.com/api/Guest";

  // ✅ Hotel API (NEW - required for hotels)
  static const String hotelBaseUrl =
      "https://hotel-kyc-api22.onrender.com/api/Hotel";

  // --- 1. REGISTER GUEST (POST) ---
  Future<http.Response> registerGuest(Map<String, dynamic> data) async {
    try {
      return await http.post(
        Uri.parse('$guestBaseUrl/register-guest'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      debugPrint("Register Guest Error: $e");
      return http.Response(jsonEncode({"message": "Error: $e"}), 500);
    }
  }

  // --- 2. FETCH FLAGGED GUESTS (GET) ---
  Future<List<dynamic>> fetchFlaggedGuests() async {
    try {
      final response = await http.get(
        Uri.parse('$guestBaseUrl/flagged-guests'),
      );

      debugPrint("Flagged Guests Status: ${response.statusCode}");
      debugPrint("Flagged Guests Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Flagged Fetch Error: $e");
      return [];
    }
  }

  // --- 3. FETCH ALL HOTELS (FIXED 🔥) ---
  Future<List<dynamic>> fetchAllHotels() async {
    try {
      final response = await http.get(
        Uri.parse('$hotelBaseUrl/all'), // ✅ FIXED API
      );

      debugPrint("Hotels Status: ${response.statusCode}");
      debugPrint("Hotels Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Hotel Fetch Error: $e");
      return [];
    }
  }

  // --- 4. FETCH GUESTS BY HOTEL ---
  Future<List<dynamic>> fetchGuestsByHotel(int hotelId) async {
    try {
      final response = await http.get(
        Uri.parse('$guestBaseUrl/by-hotel/$hotelId'),
      );

      debugPrint("Guests By Hotel Status: ${response.statusCode}");
      debugPrint("Guests By Hotel Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Fetch Guests by Hotel Error: $e");
      return [];
    }
  }

  // --- 5. FETCH ALL GUESTS RAW ---
  Future<List<dynamic>> fetchGuestsRaw() async {
    try {
      final response = await http.get(
        Uri.parse('$guestBaseUrl/all-guests'),
      );

      debugPrint("Guests Raw Status: ${response.statusCode}");
      debugPrint("Guests Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Fetch Guests Raw Error: $e");
      return [];
    }
  }

  // --- 6. FETCH ALL GUESTS (MODEL) ---
  Future<List<Guest>> fetchGuests() async {
    try {
      final response = await http.get(
        Uri.parse('$guestBaseUrl/all-guests'),
      );

      debugPrint("Guests Status: ${response.statusCode}");
      debugPrint("Guests Response: ${response.body}");

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Guest.fromJson(data)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Fetch Guests Error: $e");
      return [];
    }
  }
}