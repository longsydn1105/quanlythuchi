import 'package:flutter/material.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(
    text: "Nguyễn Văn A",
  );
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _unlocked = false; // Đã nhập đúng mật khẩu cũ chưa

  void _checkOldPassword() {
    if (_oldPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập mật khẩu cũ")),
      );
      return;
    }

    setState(() {
      _unlocked = true;
    });
  }

  void _resetState() {
    setState(() {
      _unlocked = false;
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Thành công"),
              content: const Text("Thông tin đã được cập nhật!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // đóng popup
                    _resetState(); // quay lại trạng thái nhập mật khẩu cũ
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi tên & mật khẩu"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!_unlocked) ...[
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Nhập mật khẩu cũ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _checkOldPassword,
                  child: const Text("Tiếp tục"),
                ),
              ] else ...[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Tên mới",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu mới",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Mật khẩu phải có ít nhất 6 ký tự";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Xác nhận mật khẩu mới",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return "Mật khẩu xác nhận không khớp";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Xác nhận"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
