import 'package:flutter/material.dart';
import '/Screens/transaction/add_transaction_page.dart';
import '/Screens/transaction/transaction_list_page.dart';
import 'package:flutter_quanlythuchi/Screens/Profile/profile_page.dart';
import '/Screens/thongke/report_screen.dart';
import '/Screens/login.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                color: Colors.blue.shade900,
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Text(
                    'Quản lý chi tiêu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Tháng 6',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // Thu - Chi - Dư
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 200),
                      child: _InfoColumn(label: 'Thu', value: '50.000VND'),
                    ),
                    const _InfoColumn(label: 'Chi', value: '30.000VND'),
                    const Padding(
                      padding: EdgeInsets.only(right: 200),
                      child: _InfoColumn(label: 'Dư', value: '20.000VND'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildLargeButton(context, 'Thêm giao dịch'),
                  _buildLargeButton(context, 'Báo cáo thống kê'),
                  _buildLargeButton(context, 'Danh sách giao dịch'),
                  _buildLargeButton(context, 'Cài đặt cá nhân'),
                  _buildLargeButton(context, 'Danh mục chi tiêu'),
                  _buildLargeButton(context, 'Đăng xuất'),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildLargeButton(BuildContext context, String title) {
  return SizedBox(
    width: 400,
    height: 150,
    child: OutlinedButton(
      onPressed: () {
        if (title == 'Thêm giao dịch') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
        } else if (title == 'Báo cáo thống kê') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReportScreen()),
          );
        } else if (title == 'Danh sách giao dịch') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransactionListPage()),
          );
        } else if (title == 'Cài đặt cá nhân') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        } else if (title == 'Đăng xuất') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
        } else {
          // TODO: Xử lý các mục còn lại
        }
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: const BorderSide(color: Colors.black),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}