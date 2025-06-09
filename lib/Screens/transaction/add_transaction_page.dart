import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/expense_controller.dart';
import '/controllers/user_controller.dart';
import 'package:get/get.dart';
import '/models/transaction.dart';

class AddTransactionPage extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionPage({super.key, this.transaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final expenseController = Get.find<ExpenseController>();
  final userController = Get.find<UserController>();
  double? _amount;
  String _note = '';

  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'Chi';
  String _selectedCategory = 'Ăn uống';

  // Danh mục riêng cho Thu và Chi
  final List<String> _incomeCategories = [
    'Lương',
    'Thưởng',
    'Đầu tư',
    'Khác',
  ];
  final List<String> _expenseCategories = [
    'Ăn uống',
    'Di chuyển',
    'Giải trí',
    'Mua sắm',
    'Khác',
  ];

  List<String> get _categories =>
      _transactionType == 'Thu' ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    if (tx != null) {
      _amount = tx.amount;
      _note = tx.note;
      _selectedDate = tx.date;
      _transactionType = tx.type;
      _selectedCategory = tx.category;
    } else {
      _selectedCategory = _categories.first;
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Chọn ngày giao dịch',
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    final amount = _amount;
    final note = _note;

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')));
      return;
    }

    try {
      await expenseController.addExpense(
        amount,
        _transactionType,
        _selectedCategory,
        _selectedDate,
        note,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi lưu giao dịch: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa Giao Dịch' : 'Thêm Giao Dịch'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Số tiền
                  TextFormField(
                    initialValue: _amount?.toString(),
                    decoration: InputDecoration(
                      labelText: 'Số tiền',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _amount = double.tryParse(value),
                  ),
                  const SizedBox(height: 16),
                  // Loại giao dịch
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _transactionType,
                          decoration: InputDecoration(
                            labelText: 'Loại',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(
                              _transactionType == 'Thu' ? Icons.trending_up : Icons.trending_down,
                              color: _transactionType == 'Thu' ? Colors.green : Colors.red,
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Thu',
                              child: Row(
                                children: [
                                  Icon(Icons.trending_up, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text('Thu nhập'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Chi',
                              child: Row(
                                children: [
                                  Icon(Icons.trending_down, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text('Chi tiêu'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _transactionType = value;
                                _selectedCategory = _categories.first;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Danh mục',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: _categories
                              .map((cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedCategory = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Ghi chú
                  TextFormField(
                    initialValue: _note,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                      prefixIcon: Icon(Icons.note_alt, color: Colors.amber[800]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    maxLines: 2,
                    onChanged: (value) => _note = value,
                  ),
                  const SizedBox(height: 16),
                  // Ngày giao dịch
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          Text(
                            'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            'Chọn ngày',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Nút lưu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(isEditing ? Icons.save_as : Icons.save),
                      label: Text(isEditing ? 'LƯU THAY ĐỔI' : 'LƯU GIAO DỊCH'),
                      onPressed: _saveTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}