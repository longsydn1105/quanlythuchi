// lib/screens/signup.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/user_controller.dart';
import '../db/repositories/user_repository.dart';

class RegisterPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserController userController = UserController(UserRepository());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Đăng Ký',
                style: GoogleFonts.josefinSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff7C4DFF),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF7C4DFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    String username = _usernameController.text.trim();
                    String password = _passwordController.text.trim();
                    String confirmPassword = _confirmPasswordController.text.trim();

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mật khẩu không khớp')),
                      );
                      return;
                    }

                    try {
                      int userId = await userController.registerUser(username, password);
                      if (userId >= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đăng ký thành công')),
                        );
                        Navigator.pop(context); // Quay lại LoginPage
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: Text(
                    'Đăng ký',
                    style: GoogleFonts.josefinSans(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
