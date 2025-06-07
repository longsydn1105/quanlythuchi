import '../database_helper.dart';
import '../../models/expense.dart';

class ExpenseRepository {
  // Thêm một expense mới vào database
  // Trả về ID của bản ghi mới nếu thành công, -1 nếu thất bại
  Future<int> insertExpense(Expense expense) async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      await box.add(expense);
      return expense.key; // Trong Hive, key được tự động gán khi add
    } catch (e) {
      return -1;
    }
  }

  // Lấy tất cả expenses từ database
  Future<List<Expense>> getAllExpenses() async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      return box.values.cast<Expense>().toList();
    } catch (e) {
      return [];
    }
  }

  // Lấy tất cả expenses của một user cụ thể theo userId
  Future<List<Expense>> getExpensesByUserId(int userId) async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      return box.values
          .cast<Expense>()
          .where((expense) => expense.userId == userId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Cập nhật thông tin expense trong database
  // Trả về true nếu thành công, false nếu thất bại
  Future<bool> updateExpense(Expense expense) async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      await box.put(expense.key, expense);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Xóa một expense khỏi database theo key
  // Trả về true nếu thành công, false nếu thất bại
  Future<bool> deleteExpense(int key) async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      await box.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Tính tổng số tiền (amount) của tất cả expenses trong một category cụ thể
  Future<double> getTotalExpensesByCategory(String category) async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      return box.values
          .cast<Expense>()
          .where((expense) => expense.category == category)
          .fold<double>(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getTotalByType(String type, int userId, DateTime startOfMonth, DateTime endOfMonth) async {
    try {
      final box = await DatabaseHelper.instance.expenseBox;
      return box.values
          .cast<Expense>()
          .where((expense) =>
              expense.type == type &&
              expense.userId == userId &&
              expense.date.isAfter(startOfMonth) &&
              expense.date.isBefore(endOfMonth))
          .fold<double>(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      return 0.0;
    }
  }
}