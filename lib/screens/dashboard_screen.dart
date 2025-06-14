import 'package:flutter/material.dart';
import 'package:flutter_quanlythuchi/Screens/Profile/spending_limit_page.dart';
import '/Screens/transaction/add_transaction_page.dart';
import '/Screens/transaction/transaction_list_page.dart';
import 'package:flutter_quanlythuchi/Screens/Profile/profile_page.dart';
import '/Screens/thongke/report_screen.dart';
import '/Screens/login.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExpenseController _expenseController = Get.find<ExpenseController>();
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  double _totalIncome = 0;
  double _totalExpense = 0;
  double _balance = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  Future<void> _loadTotals() async {
    setState(() => _loading = true);
    final expenses = await _expenseController.getUserExpenses();
    double income = 0;
    double expense = 0;
    for (var tx in expenses) {
      if (tx.type == 'Thu') {
        income += tx.amount;
      } else if (tx.type == 'Chi') {
        expense += tx.amount;
      }
    }
    setState(() {
      _totalIncome = income;
      _totalExpense = expense;
      _balance = income - expense;
      _loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTotals();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      backgroundColor: Colors.blue.shade900,
      title: const Text(
        'Quản lý chi tiêu',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white, size: 30),
          tooltip: 'Cài đặt cá nhân',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.red, size: 30),
          tooltip: 'Đăng xuất',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          },
        ),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tổng quan tháng 6',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _loading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _InfoTile(
                              icon: Icons.arrow_downward,
                              label: 'Thu',
                              value:
                                  '${_currencyFormat.format(_totalIncome)} đ',
                              color: Colors.green,
                            ),
                            _InfoTile(
                              icon: Icons.arrow_upward,
                              label: 'Chi',
                              value:
                                  '${_currencyFormat.format(_totalExpense)} đ',
                              color: Colors.red,
                            ),
                            _InfoTile(
                              icon: Icons.account_balance_wallet,
                              label: 'Dư',
                              value: '${_currencyFormat.format(_balance)} đ',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildLargeButton(context, 'Thêm giao dịch', Icons.add),
                _buildLargeButton(context, 'Báo cáo thống kê', Icons.bar_chart),
                _buildLargeButton(context, 'Danh sách giao dịch', Icons.list),
                _buildLargeButton(
                    context, 'Đặt giới hạn chi tiêu', Icons.lock_clock),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildLargeButton(BuildContext context, String title, IconData icon) {
  return SizedBox(
    width: 400,
    height: 150,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          if (title == 'Thêm giao dịch') {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionPage()),
            );
            _loadTotals();
          } else if (title == 'Báo cáo thống kê') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReportScreen()),
            );
          } else if (title == 'Lịch sử giao dịch') {
            // Placeholder
          } else if (title == 'Đặt giới hạn chi tiêu') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SpendingLimitPage()),
            );
          } else if (title == 'Danh sách giao dịch') {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionListPage()),
            );
            _loadTotals();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue.shade800),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
