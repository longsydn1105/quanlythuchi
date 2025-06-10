import 'package:flutter/material.dart';
import 'package:flutter_quanlythuchi/Screens/Profile/edit_account_page.dart';
import 'package:flutter_quanlythuchi/controllers/user_controller.dart';
import 'package:flutter_quanlythuchi/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = UserController();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userController.getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ người dùng"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Avatar + tên
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/main_top.png',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _currentUser?.username ?? "Không có tên",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Quản lý tài chính cá nhân",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Nút điều hướng: Đổi tên và mật khẩu
                    buildActionButton(
                      context,
                      icon: Icons.lock_person,
                      label: "Đổi tên & mật khẩu",
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditAccountPage(),
                          ),
                        );
                        _loadUser(); // Reload dữ liệu sau khi quay lại
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
    );
  }

  Widget buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade600),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
