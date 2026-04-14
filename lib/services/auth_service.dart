// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   // Use your computer's IP or localhost for Chrome
//   // static const String baseUrl = "https://localhost:7295/api/Auth";
//  final url = Uri.parse("${ApiService.baseUrl}/Auth/login");

//   Future<http.Response> register(String name, String email, String password, String phone) async {
//     return await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "fullName": name,
//         "email": email,
//         "password": password, 
//         "phoneNumber": phone,
//       }),
//     );
//   }

// // lib/services/auth_service.dart
// Future<http.Response> login(String username, String password) async {
//   return await http.post(
//     Uri.parse('$baseUrl/login'),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "fullName": username, // This must match the C# property name
//       "password": password,
//     }),
//   );
// }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      "https://hotel-kyc-api22.onrender.com/api/Auth";

  // ✅ REGISTER
  Future<http.Response> register(
    String name,
    String email,
    String password,
    String phone,
    String role,
  ) async {
    return await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": name,
        "email": email,
        "password": password,
        "phoneNumber": phone,
        "role": role, // ✅ CORRECT
      }),
    );
  }

  // ✅ LOGIN
  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
  }
}