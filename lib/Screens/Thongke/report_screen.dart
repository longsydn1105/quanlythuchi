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
    'Thưởng': Colors.lightGreen,
    'Đầu tư': Colors.indigo,
    'Khác': Colors.grey,
  };

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _selectedTab = 'Chi'; // 'Chi' hoặc 'Thu'

  Future<Map<String, Map<String, double>>> _loadGroupedData() async {
    final expenses = await _expenseController.getUserExpenses();
    // Lọc theo tháng/năm
    final filtered = expenses.where((e) =>
        e.date.month == _selectedMonth && e.date.year == _selectedYear);

    Map<String, double> income = {};
    Map<String, double> expense = {};

    for (var tx in filtered) {
      if (tx.type == 'Thu') {
        income[tx.category] = (income[tx.category] ?? 0) + tx.amount;
      } else if (tx.type == 'Chi') {
        expense[tx.category] = (expense[tx.category] ?? 0) + tx.amount;
      }
    }
    return {
      'Thu': income,
      'Chi': expense,
    };
  }

  List<DropdownMenuItem<int>> _monthItems() => List.generate(
        12,
        (i) => DropdownMenuItem(
          value: i + 1,
          child: Text('Tháng ${i + 1}'),
        ),
      );

  List<DropdownMenuItem<int>> _yearItems() {
    int now = DateTime.now().year;
    return List.generate(
        5,
        (i) => DropdownMenuItem(
              value: now - i,
              child: Text('${now - i}'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo chi tiêu'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Bộ lọc tháng/năm
          Container(
            color: Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              children: [
                DropdownButton<int>(
                  value: _selectedMonth,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  items: _monthItems(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedMonth = v);
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: _selectedYear,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  items: _yearItems(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedYear = v);
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => setState(() {}),
                  tooltip: 'Làm mới',
                ),
              ],
            ),
          ),
          // Nút chuyển đổi giữa Chi tiêu và Thu nhập
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _selectedTab == 'Chi' ? Colors.red.shade400 : Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedTab = 'Chi';
                          });
                        },
                        child: Text(
                          'Chi tiêu',
                          style: TextStyle(
                            color: _selectedTab == 'Chi' ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _selectedTab == 'Thu' ? Colors.green.shade400 : Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedTab = 'Thu';
                          });
                        },
                        child: Text(
                          'Thu nhập',
                          style: TextStyle(
                            color: _selectedTab == 'Thu' ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<Map<String, Map<String, double>>>(
              future: _loadGroupedData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final incomeData = snapshot.data!['Thu']!;
                final expenseData = snapshot.data!['Chi']!;

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    if (_selectedTab == 'Chi')
                      _buildSection(
                        title: 'Biểu đồ Chi tiêu',
                        data: expenseData,
                        currencyFormat: currencyFormat,
                        colorMap: categoryColors,
                        icon: Icons.trending_down,
                        color: Colors.red.shade400,
                      ),
                    if (_selectedTab == 'Thu')
                      _buildSection(
                        title: 'Biểu đồ Thu nhập',
                        data: incomeData,
                        currencyFormat: currencyFormat,
                        colorMap: categoryColors,
                        icon: Icons.trending_up,
                        color: Colors.green.shade400,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Map<String, double> data,
    required NumberFormat currencyFormat,
    required Map<String, Color> colorMap,
    required IconData icon,
    required Color color,
  }) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 8),
              Text('Không có dữ liệu $title', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }
    final total = data.values.fold(0.0, (a, b) => a + b);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                  ),
                  const Spacer(),
                  Text(
                    currencyFormat.format(total),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: data.entries.map((entry) {
                      final percent = (entry.value / total * 100).toStringAsFixed(1);
                      return PieChartSectionData(
                        value: entry.value,
                        title: '$percent%',
                        color: colorMap[entry.key] ?? Colors.grey,
                        radius: 70,
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
              ...data.entries.map((entry) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (colorMap[entry.key] ?? Colors.grey).withOpacity(0.8),
                        child: Icon(Icons.label, color: Colors.white, size: 20),
                      ),
                      title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Text(
                        currencyFormat.format(entry.value),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}