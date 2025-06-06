import 'package:flutter/material.dart';
import '../controllers/expense_controller.dart';

class DashboardScreen extends StatefulWidget {
  final ExpenseController expenseController;

  const DashboardScreen({Key? key, required this.expenseController}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _income = 0;
  double _expense = 0;
  double _balance = 0;
  int userId = 1; // Tạm hard-code ID user

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final income = await widget.expenseController.getTotalByType(userId, 'thu');
    final expense = await widget.expenseController.getTotalByType(userId, 'chi' );
    final balance = income - expense;

    setState(() {
      _income = income;
      _expense = expense;
      _balance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điều khiển'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard('Thu nhập', _income, Colors.green),
            _buildCard('Chi tiêu', _expense, Colors.red),
            _buildCard('Số dư', _balance, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: color),
        title: Text(title),
        trailing: Text('${amount.toStringAsFixed(0)} đ', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
