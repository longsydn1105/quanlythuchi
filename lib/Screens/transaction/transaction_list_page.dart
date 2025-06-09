import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/expense_controller.dart';
import '/models/expense.dart';
import 'add_transaction_page.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final ExpenseController _expenseController = ExpenseController();
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  Future<List<Expense>> _loadExpenses() async {
    return await _expenseController.getUserExpenses();
  }

  void _navigateToAddTransaction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionPage(),
      ),
    );
    setState(() {}); // Để reload lại danh sách khi quay về
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử giao dịch'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Expense>>(
        future: _loadExpenses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final expenses = snapshot.data!;
          double totalIncome = 0;
          double totalExpense = 0;
          for (var tx in expenses) {
            if (tx.type == 'Thu') {
              totalIncome += tx.amount;
            } else if (tx.type == 'Chi') {
              totalExpense += tx.amount;
            }
          }
          final formattedIncome = _currencyFormat.format(totalIncome);
          final formattedExpense = _currencyFormat.format(totalExpense);

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoTile(
                        icon: Icons.arrow_downward,
                        label: 'Tổng thu nhập',
                        value: '$formattedIncome đ',
                        color: Colors.green,
                      ),
                      _InfoTile(
                        icon: Icons.arrow_upward,
                        label: 'Tổng chi tiêu',
                        value: '$formattedExpense đ',
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: expenses.isEmpty
                    ? const Center(
                        child: Text(
                          'Chưa có giao dịch nào',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      )
                    : ListView.separated(
                        itemCount: expenses.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final tx = expenses[index];
                          final formattedAmount = _currencyFormat.format(tx.amount);
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.type == 'Thu' ? Colors.green : Colors.red,
                                child: Icon(
                                  tx.type == 'Thu' ? Icons.trending_up : Icons.trending_down,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                tx.category,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.type == 'Thu' ? 'Thu nhập' : 'Chi tiêu',
                                    style: TextStyle(
                                      color: tx.type == 'Thu' ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (tx.note.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        tx.note,
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      'Ngày: ${DateFormat('dd/MM/yyyy').format(tx.date)}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: Text(
                                '$formattedAmount đ',
                                style: TextStyle(
                                  color: tx.type == 'Thu' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTransaction,
        icon: const Icon(Icons.add),
        label: const Text('Thêm'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}