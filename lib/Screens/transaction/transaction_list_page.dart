import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_transaction_page.dart';
import '/models/transaction.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final List<Transaction> _transactions = [];
  
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  void _navigateToAddTransaction({Transaction? existingTransaction, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionPage(transaction: existingTransaction),
      ),
    );

    if (result != null && result is Transaction) {
      setState(() {
        if (index != null) {
          // Chỉnh sửa
          _transactions[index] = result;
        } else {
          // Thêm mới
          _transactions.add(result);
        }
      });
    }
  }

  void _deleteTransaction(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa giao dịch này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _transactions.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa giao dịch')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng thu nhập và tổng chi tiêu
    double totalIncome = 0;
    double totalExpense = 0;

    for (var tx in _transactions) {
      if (tx.type == 'Thu') {
        totalIncome += tx.amount;
      } else if (tx.type == 'Chi') {
        totalExpense += tx.amount;
      }
    }

    final formattedIncome = _currencyFormat.format(totalIncome);
    final formattedExpense = _currencyFormat.format(totalExpense);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử giao dịch'),
      ),
      body: Column(
        children: [
          // Phần tổng thu nhập & chi tiêu
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

          // Danh sách giao dịch
          Expanded(
            child: _transactions.isEmpty
                ? Center(child: Text('Chưa có giao dịch nào'))
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$formattedAmount đ',
                                style: TextStyle(
                                  color: tx.type == 'Thu' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.teal),
                                onPressed: () => _navigateToAddTransaction(
                                  existingTransaction: tx,
                                  index: index,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTransaction(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTransaction(),
        icon: Icon(Icons.add),
        label: Text('Thêm'),
      ),
    );
  }
}
