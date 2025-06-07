// lib/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_quanlythuchi/Screens/login.dart';
import 'package:flutter_quanlythuchi/Controllers/user_controller.dart';
import 'package:flutter_quanlythuchi/db/repositories/user_repository.dart';

class RegisterPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserController userController = UserController(UserRepository());

  RegisterPage({super.key});

  void register(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng Ký')),
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
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text.trim();
                String password = _passwordController.text.trim();
                String confirmPassword = _confirmPasswordController.text.trim();

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mật khẩu và xác nhận mật khẩu không khớp')),
                  );
                  return;
                }

                try {
                  int userId = await userController.registerUser(username, password);
                  if (userId >= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đăng ký thành công')),
                    );
                    Navigator.pop(context); // Quay lại Login
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
