import 'package:flutter/material.dart';
import 'package:flutter_quanlythuchi/Screens/Profile/edit_account_page.dart';
import 'package:flutter_quanlythuchi/Screens/Profile/spending_limit_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      body: Container(
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
                    backgroundImage: AssetImage('assets/images/main_top.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nguyễn Văn A",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditAccountPage()),
                );
              },
            ),

            // Nút điều hướng: Giới hạn chi tiêu
            buildActionButton(
              context,
              icon: Icons.savings,
              label: "Đặt giới hạn chi tiêu tháng",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SpendingLimitPage()),
                );
              },
            ),

            const Spacer(),

            // Đăng xuất
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Logic đăng xuất
                },
                icon: const Icon(Icons.logout),
                label: const Text("Đăng xuất"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
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
