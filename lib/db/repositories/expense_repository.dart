import '../database_helper.dart';
import '../../models/expense.dart';

class ExpenseRepository {

  
  // Thêm một expense mới vào database
  // Trả về ID của bản ghi mới nếu thành công, -1 nếu thất bại
  Future<int> insertExpense(Expense expense) async {
    try {
      final db = await DatabaseHelper.database;
      return await db.insert('expenses', expense.toMap());
    } catch (e) {
      return -1; // Trả về -1 nếu thất bại
    }
  }

  // Lấy tất cả expenses từ database
  // Trả về danh sách Expense nếu thành công, list rỗng nếu có lỗi
  Future<List<Expense>> getAllExpenses() async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('expenses');
      return maps.map((e) => Expense.fromMap(e)).toList();
    } catch (e) {
      return []; // Trả về list rỗng nếu có lỗi
    }
  }

  // Lấy tất cả expenses của một user cụ thể theo userId
  // Trả về danh sách Expense nếu thành công, list rỗng nếu có lỗi
  Future<List<Expense>> getExpensesByUserId(int userId) async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'expenses',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      return maps.map((e) => Expense.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Cập nhật thông tin expense trong database
  // Trả về số bản ghi được cập nhật (thường là 1), 0 nếu có lỗi
  Future<int> updateExpense(Expense expense) async {
    try {
      final db = await DatabaseHelper.database;
      return await db.update(
        'expenses',
        expense.toMap(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    } catch (e) {
      return 0; // Số bản ghi được cập nhật = 0 nếu lỗi
    }
  }

  // Xóa một expense khỏi database theo id
  // Trả về số bản ghi bị xóa (thường là 1), 0 nếu có lỗi
  Future<int> deleteExpense(int id) async {
    try {
      final db = await DatabaseHelper.database;
      return await db.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0; // Số bản ghi được xóa = 0 nếu lỗi
    }
  }

  // Tính tổng số tiền (amount) của tất cả expenses trong một category cụ thể
  // Trả về tổng số tiền dưới dạng double, 0.0 nếu có lỗi hoặc không có dữ liệu
  Future<double> getTotalExpensesByCategory(String category) async {
    try {
      final db = await DatabaseHelper.database;
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM expenses WHERE category = ?',
        [category],
      );
      final total = result.first['total'];
      if (total == null) return 0.0;
      return (total as num).toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getTotalByType(String type, int userId, DateTime startOfMonth, DateTime endOfMonth) async {
  final db = await DatabaseHelper.database;
  
  final result = await db.rawQuery('''
    SELECT SUM(amount) as total FROM expenses
    WHERE type = ? AND user_id = ? AND date BETWEEN ? AND ?
  ''', [type, userId, startOfMonth.toIso8601String(), endOfMonth.toIso8601String()]);

  return result.first['total'] == null ? 0.0 : result.first['total'] as double;
  }

}