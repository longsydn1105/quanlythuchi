import 'package:flutter/material.dart';
import 'package:flutter_quanlythuchi/controllers/user_controller.dart';
import 'package:intl/intl.dart';

class SpendingLimitPage extends StatefulWidget {
  const SpendingLimitPage({super.key});

  @override
  State<SpendingLimitPage> createState() => _SpendingLimitPageState();
}

class _SpendingLimitPageState extends State<SpendingLimitPage> {
  final TextEditingController _limitController = TextEditingController();
  final UserController _userController = UserController();

  double? _currentLimit;

  final currencyFormatter = NumberFormat("#,##0", "vi_VN");

  @override
  void initState() {
    super.initState();
    _loadLimit();
  }

  Future<void> _loadLimit() async {
    final limit = await _userController.getLimit();
    setState(() {
      _currentLimit = limit;
      // ❌ KHÔNG gán lại vào ô nhập nữa
    });
  }

  Future<void> _saveLimit() async {
    final input = _limitController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền giới hạn')),
      );
      return;
    }

    final amount = double.tryParse(input);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    double newLimit;
    if (_currentLimit != null) {
      newLimit = _currentLimit! + amount;
    } else {
      newLimit = amount;
    }

    await _userController.setLimit(newLimit);
    setState(() {
      _currentLimit = newLimit;
      _limitController.clear(); // ✅ Xóa giá trị
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật giới hạn chi tiêu')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đặt giới hạn chi tiêu"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentLimit != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Giới hạn hiện tại: ${currencyFormatter.format(_currentLimit)} VND',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nhập giới hạn mới',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveLimit,
              icon: const Icon(Icons.save),
              label: const Text('Lưu giới hạn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
