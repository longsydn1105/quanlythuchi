import 'package:flutter/material.dart';
import 'package:flutter_quanlythuchi/Screens/signup.dart';
import 'package:flutter_quanlythuchi/Screens/dashboard_screen.dart';
import 'package:flutter_quanlythuchi/controllers/user_controller.dart';
import 'package:flutter_quanlythuchi/db/repositories/user_repository.dart';

final UserController userController = UserController(UserRepository());

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController userController = UserController(UserRepository());

  LoginPage({super.key});

  void login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng Nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text.trim();
                String password = _passwordController.text.trim();
                bool isValid = await userController.authenticate(username, password);

                if (isValid) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
                  );
                }
              },
              child: Text('Đăng nhập'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterPage()),
                );
              },
              child: Text('Chưa có tài khoản? Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
