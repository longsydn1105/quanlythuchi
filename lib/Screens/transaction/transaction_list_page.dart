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
        title: Text('Lịch sử giao dịch'),
      ),
      body: FutureBuilder<List<Expense>>(
        future: _loadExpenses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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
                margin: EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Tổng thu nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text(
                            '$formattedIncome đ',
                            style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Tổng chi tiêu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text(
                            '$formattedExpense đ',
                            style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: expenses.isEmpty
                    ? Center(child: Text('Chưa có giao dịch nào'))
                    : ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final tx = expenses[index];
                          final formattedAmount = _currencyFormat.format(tx.amount);
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.type == 'Thu' ? Colors.green : Colors.red,
                                child: Icon(
                                  tx.type == 'Thu' ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                '${tx.category} - ${tx.type}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('${tx.note}\nNgày: ${DateFormat('dd/MM/yyyy').format(tx.date)}'),
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
        icon: Icon(Icons.add),
        label: Text('Thêm'),
      ),
    );
  }
}