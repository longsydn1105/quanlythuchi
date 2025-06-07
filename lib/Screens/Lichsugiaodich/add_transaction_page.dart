import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_list_page.dart';

class AddTransactionPage extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionPage({Key? key, this.transaction}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'Chi';
  String _selectedCategory = 'Ăn uống';

  final List<String> _categories = [
    'Ăn uống',
    'Di chuyển',
    'Lương',
    'Giải trí',
    'Mua sắm',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    if (tx != null) {
      _amountController.text = tx.amount.toString();
      _noteController.text = tx.note;
      _selectedDate = tx.date;
      _transactionType = tx.type;
      _selectedCategory = tx.category;
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() {
    final amount = double.tryParse(_amountController.text.trim());
    final note = _noteController.text.trim();

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    final newTransaction = Transaction(
      amount: amount,
      type: _transactionType,
      category: _selectedCategory,
      note: note,
      date: _selectedDate,
    );

    Navigator.pop(context, newTransaction);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Chỉnh sửa Giao Dịch' : 'Thêm Giao Dịch')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Số tiền',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _transactionType,
              decoration: InputDecoration(
                labelText: 'Loại',
                border: OutlineInputBorder(),
              ),
              items: ['Thu', 'Chi'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _transactionType = value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Danh mục',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Ghi chú',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today),
                  label: Text('Chọn ngày'),
                  onPressed: _selectDate,
                )
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(isEditing ? Icons.save_as : Icons.save),
              label: Text(isEditing ? 'LƯU THAY ĐỔI' : 'LƯU'),
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
