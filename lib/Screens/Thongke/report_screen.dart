import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/expense_controller.dart';
import '/models/expense.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ExpenseController _expenseController = ExpenseController();

  final Map<String, Color> categoryColors = {
    'Ăn uống': Colors.orange,
    'Di chuyển': Colors.blue,
    'Giải trí': Colors.purple,
    'Lương': Colors.green,
    'Mua sắm': Colors.teal,
    'Khác': Colors.grey,
  };

  Future<Map<String, double>> _loadGroupedData() async {
    final expenses = await _expenseController.getUserExpenses();
    Map<String, double> groupedData = {
      'Ăn uống': 0,
      'Di chuyển': 0,
      'Giải trí': 0,
      'Lương': 0,
      'Mua sắm': 0,
      'Khác': 0,
    };
    for (var tx in expenses) {
      if (groupedData.containsKey(tx.category)) {
        groupedData[tx.category] = groupedData[tx.category]! + tx.amount;
      } else {
        groupedData['Khác'] = groupedData['Khác']! + tx.amount;
      }
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo chi tiêu'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _loadGroupedData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final groupedData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Biểu đồ hình tròn theo danh mục',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: groupedData.entries.where((e) => e.value > 0).map(
                        (entry) {
                          final category = entry.key;
                          final amount = entry.value;
                          final color = categoryColors[category] ?? Colors.grey;
                          final total = groupedData.values.reduce((a, b) => a + b);
                          final percentage = (amount / total * 100).toStringAsFixed(1);

                          return PieChartSectionData(
                            value: amount,
                            title: '$percentage%',
                            color: color,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chi tiết danh mục',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: groupedData.entries.where((e) => e.value > 0).map((entry) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: categoryColors[entry.key] ?? Colors.grey,
                        ),
                        title: Text(entry.key),
                        trailing: Text(currencyFormat.format(entry.value)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}