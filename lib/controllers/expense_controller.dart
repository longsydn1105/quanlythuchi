import '/models/expense.dart';
import '../db/database_helper.dart';

class ExpenseController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Lấy danh sách expense của user hiện tại
  Future<List<Expense>> getUserExpenses() async {
    final userId = await _dbHelper.getCurrentUserId();
    if (userId == null) return [];
    return await _dbHelper.getExpenses(userId);
  }

  // Thêm expense mới
  Future<int> addExpense(
    double amount,
    String type,
    String category,
    DateTime date,
    String note,
  ) async {
    final userId = await _dbHelper.getCurrentUserId();
    if (userId == null) throw Exception('Chưa đăng nhập');

    final expense = Expense(
      userId: userId,
      amount: amount,
      type: type,
      category: category,
      date: date,
      note: note,
    );

    return await _dbHelper.saveExpense(expense);
  }

  // Cập nhật expense
  Future<bool> updateExpense(Expense expense) async {
    final userId = await _dbHelper.getCurrentUserId();
    if (userId == null || expense.userId != userId) return false;

    await _dbHelper.saveExpense(expense);
    return true;
  }

  // Xóa expense
  Future<bool> deleteExpense(int expenseId) async {
    final userId = await _dbHelper.getCurrentUserId();
    if (userId == null) return false;

    final expense = await _dbHelper.getExpense(expenseId);
    if (expense == null || expense.userId != userId) return false;

    return await _dbHelper.deleteExpense(expenseId);
  }

  // Đặt giới hạn chi tiêu
  Future<double> getMonthlyExpenseTotal() async {
    final userId = await _dbHelper.getCurrentUserId();
    if (userId == null) return 0.0;

    final now = DateTime.now();
    final expenses = await _dbHelper.getExpenses(userId);

    final filtered = expenses.where(
      (e) =>
          e.type == 'Chi' &&
          e.date.year == now.year &&
          e.date.month == now.month,
    );

    double sum = 0.0;
    for (var e in filtered) {
      final amount = e.amount; // hoặc e.amount nếu không phải Future
      sum += amount ?? 0.0;
    }

    return sum;
  }
}
