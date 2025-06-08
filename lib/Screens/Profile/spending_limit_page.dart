import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpendingLimitPage extends StatefulWidget {
  const SpendingLimitPage({super.key});

  @override
  State<SpendingLimitPage> createState() => _SpendingLimitPageState();
}

class _SpendingLimitPageState extends State<SpendingLimitPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  DateTime? _selectedMonth;
  final List<Map<String, dynamic>> _limits = [];

  void _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      helpText: "Chọn tháng",
      fieldLabelText: "Tháng/Năm",
      builder: (context, child) {
        return Theme(data: ThemeData.light(), child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  void _addLimit() {
    if (_formKey.currentState!.validate() && _selectedMonth != null) {
      String monthKey = DateFormat('MM/yyyy').format(_selectedMonth!);

      bool alreadyExists = _limits.any((entry) => entry['month'] == monthKey);

      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tháng này đã được đặt hạn mức")),
        );
        return;
      }

      if (_limits.length >= 13) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Chỉ được đặt hạn mức tối đa cho 13 tháng"),
          ),
        );
        return;
      }

      setState(() {
        _limits.add({
          'month': monthKey,
          'amount': double.parse(_amountController.text),
        });
        _amountController.clear();
        _selectedMonth = null;
      });
    }
  }

  void _removeLimit(int index) {
    setState(() {
      _limits.removeAt(index);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới hạn chi tiêu tháng"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Hạn mức (VNĐ)",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng nhập hạn mức";
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return "Hạn mức không hợp lệ";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _pickMonth,
                        child: const Text("Chọn tháng"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (_selectedMonth != null)
                        Text(
                          "Tháng đã chọn: ${DateFormat('MM/yyyy').format(_selectedMonth!)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _addLimit,
                        child: const Text("Thêm"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _limits.isEmpty
                      ? const Center(child: Text("Chưa có hạn mức nào"))
                      : ListView.builder(
                        itemCount: _limits.length,
                        itemBuilder: (context, index) {
                          final item = _limits[index];
                          return Card(
                            child: ListTile(
                              title: Text("Tháng ${item['month']}"),
                              subtitle: Text(
                                "Hạn mức: ${item['amount'].toStringAsFixed(0)} VNĐ",
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeLimit(index),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
