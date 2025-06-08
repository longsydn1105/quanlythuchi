// lib/screens/login.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/user_controller.dart';
import '../db/repositories/user_repository.dart';
import '../screens/dashboard_screen.dart';
import '../screens/signup.dart';
import '../db/database_helper.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController userController = UserController(UserRepository());

  LoginPage({super.key});

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
                'Đăng Nhập',
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
                    bool isValid = await userController.authenticate(username, password);

                    if (isValid) {
                      await SharedService.saveLogin(username);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => DashboardScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
                      );
                    }
                  },
                  child: Text(
                    'Đăng nhập',
                    style: GoogleFonts.josefinSans(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                },
                child: const Text('Chưa có tài khoản? Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
