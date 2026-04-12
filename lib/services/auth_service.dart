import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Use your computer's IP or localhost for Chrome
  static const String baseUrl = "https://localhost:7295/api/Auth";

  Future<http.Response> register(String name, String email, String password, String phone) async {
    return await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": name,
        "email": email,
        "password": password, 
        "phoneNumber": phone,
      }),
    );
  }

// lib/services/auth_service.dart
Future<http.Response> login(String username, String password) async {
  return await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "fullName": username, // This must match the C# property name
      "password": password,
    }),
  );
}
}