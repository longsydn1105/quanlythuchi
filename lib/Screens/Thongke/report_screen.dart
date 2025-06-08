import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:flutter_quanlythuchi/screens/Thongke/report_screen.dart';

class ReportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {'amount': 200000, 'category': 'Ăn uống'},
    {'amount': 500000, 'category': 'Giải trí'},
    {'amount': 300000, 'category': 'Di chuyển'},
    {'amount': 100000, 'category': 'Ăn uống'},
    {'amount': 150000, 'category': 'Giải trí'},
    {'amount': 1000000, 'category': 'Lương'},
    {'amount': 400000, 'category': 'Mua sắm'},
    {'amount': 50000, 'category': 'Khác'},
  ];

  ReportScreen({super.key});

  final Map<String, Color> categoryColors = {
    'Ăn uống': Colors.orange,
    'Di chuyển': Colors.blue,
    'Giải trí': Colors.purple,
    'Lương': Colors.green,
    'Mua sắm': Colors.teal,
    'Khác': Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    // Gom nhóm theo danh mục
    Map<String, double> groupedData = {
      'Ăn uống': 0,
      'Di chuyển': 0,
      'Giải trí': 0,
      'Lương': 0,
      'Mua sắm': 0,
      'Khác': 0,
    };

    for (var transaction in transactions) {
      String category = transaction['category'];
      double amount = transaction['amount'].toDouble();
      if (groupedData.containsKey(category)) {
        groupedData[category] = groupedData[category]! + amount;
      } else {
        groupedData['Khác'] = groupedData['Khác']! + amount;
      }
    }

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo chi tiêu'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                  sections:
                      groupedData.entries.where((e) => e.value > 0).map((
                        entry,
                      ) {
                        final category = entry.key;
                        final amount = entry.value;
                        final color = categoryColors[category] ?? Colors.grey;
                        final total = groupedData.values.reduce(
                          (a, b) => a + b,
                        );
                        final percentage = (amount / total * 100)
                            .toStringAsFixed(1);

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
                      }).toList(),
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
                children:
                    groupedData.entries.where((e) => e.value > 0).map((entry) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              categoryColors[entry.key] ?? Colors.grey,
                        ),
                        title: Text(entry.key),
                        trailing: Text(currencyFormat.format(entry.value)),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
