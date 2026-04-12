// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'api_service.dart';

// class AuthService {
//   // Update this to your API URL
//   // static const String baseUrl = "https://10.0.2.2:7295/api/Auth";
//   // static const String baseUrl = "https://hotel-kyc-api.onrender.com";
//     static const String baseUrl =
//       "https://hotel-kyc-api22.onrender.com/api";


//   Future<http.Response> register(
//     String name,
//     String email,
//     String password,
//     String phone,
//   ) async {
//     return await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "fullName": name,
//         "email": email,
//         "password": password, // Must match your C# RegisterRequest property
//         "phoneNumber": phone,
//       }),
//     );
//   }

//   Future<http.Response> login(String email, String password) async {
//     return await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//   }
// }
  








  import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ApiService {
  // NEW (Render backend)
  static const String baseUrl =
      "https://hotel-kyc-api22.onrender.com/api";

  Future<http.Response> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    return await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": name,
        "email": email,
        "password": password, // Must match your C# RegisterRequest property
        "phoneNumber": phone,
      }),
    );
  }

  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }
}
