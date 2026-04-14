// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../widgets/wave_painter.dart'; // Only import from widgets

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _authService = AuthService();
//   bool _isLoading = false;

//   void _handleRegister() async {
//     setState(() => _isLoading = true);
//     try {
//       final response = await _authService.register(
//         _nameController.text.trim(),
//         _emailController.text.trim(),
//         _passController.text.trim(),
//         _phoneController.text.trim(),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful! Please Login.")),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Failed. Try again.")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomPaint(
//         painter: WavePainter(), // Uses the imported class from widgets folder
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 40.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 150),
//               const Text(
//                 "REGISTER",
//                 style: TextStyle(
//                   fontSize: 32, 
//                   fontWeight: FontWeight.bold, 
//                   color: Color(0xFF4A90E2), 
//                   letterSpacing: 1.5
//                 ),
//               ),
//               const SizedBox(height: 30),
//               TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
//               const SizedBox(height: 10),
//               TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
//               const SizedBox(height: 10),
//               TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
//               const SizedBox(height: 10),
//               TextField(controller: _passController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
//               const SizedBox(height: 50),
//               Center(
//                 child: Column(
//                   children: [
//                     _isLoading 
//                       ? const CircularProgressIndicator() 
//                       : SizedBox(
//                           width: 220,
//                           height: 50,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orangeAccent,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                               elevation: 4,
//                             ),
//                             onPressed: _handleRegister, 
//                             child: const Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
//                           ),
//                         ),
//                     const SizedBox(height: 10),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Already have an account? Login", style: TextStyle(color: Color(0xFF4A90E2))),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// my old codes
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/wave_painter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  String _selectedRole = "Select Role";

  // 🔥 ROLE PICKER (POPUP LIKE YOUR IMAGE)
  void _showRolePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Admin"),
                onTap: () {
                  setState(() => _selectedRole = "Admin");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Police"),
                onTap: () {
                  setState(() => _selectedRole = "Police");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Hotel"),
                onTap: () {
                  setState(() => _selectedRole = "Hotel");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleRegister() async {
    if (_selectedRole == "Select Role") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select role")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passController.text.trim(),
        _phoneController.text.trim(),
        _selectedRole,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful! Please Login.")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Failed. Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomPaint(
        painter: WavePainter(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              const Text(
                "REGISTER",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _passController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // 🔥 ROLE SELECT FIELD (CLICKABLE LIKE INPUT)
              GestureDetector(
                onTap: _showRolePicker,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: UnderlineInputBorder(),
                  ),
                  child: Text(
                    _selectedRole,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: Column(
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: 220,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              onPressed: _handleRegister,
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Color(0xFF4A90E2)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}