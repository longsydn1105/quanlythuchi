import 'package:flutter/material.dart';
import 'controllers/expense_controller.dart';
import 'db/repositories/expense_repository.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ExpenseController _expenseController =
      ExpenseController(ExpenseRepository());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý thu chi',
      theme: ThemeData(primarySwatch: Colors.green),
      home: DashboardScreen(expenseController: _expenseController),
      debugShowCheckedModeBanner: false,
    );
  }
}
