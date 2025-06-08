
import '../db/repositories/expense_repository.dart';
import '../models/expense.dart';
import '/models/transaction.dart';


class ExpenseController {
  final ExpenseRepository _expenseRepository;

  // Khởi tạo controller với một ExpenseRepository
  ExpenseController(this._expenseRepository);
  // Removed duplicate addTransaction method to resolve naming conflict
  // Thêm một khoản chi tiêu mới
  // - Kiểm tra số tiền (amount) phải > 0
  // - Gọi repository để thêm vào database
  // - Trả về ID của bản ghi mới nếu thành công
  // - Ném exception nếu có lỗi
  Future<int> addExpense(Expense expense) async {
    try {
      if (expense.amount <= 0) {
        throw Exception('Số tiền phải lớn hơn 0');
      }
      return await _expenseRepository.insertExpense(expense);
    } catch (e) {
      print('Lỗi khi thêm expense: $e');
      rethrow;
    }
  }
  Future<void> addTransaction(Transaction transaction) async {
  // TODO: Thêm logic lưu transaction vào database hoặc danh sách
}

  // Lấy danh sách các khoản chi tiêu của một người dùng cụ thể
  // - Nhận userId làm tham số
  // - Trả về List<Expense> nếu thành công
  // - Trả về danh sách rỗng nếu có lỗi
  Future<List<Expense>> getUserExpenses(int userId) async {
    try {
      return await _expenseRepository.getExpensesByUserId(userId);
    } catch (e) {
      print('Lỗi khi lấy expenses: $e');
      return [];
    }
  }

  // Cập nhật thông tin một khoản chi tiêu
  // - Nhận đối tượng Expense cần cập nhật
  // - Trả về số bản ghi được cập nhật (thường là 1)
  // - Trả về 0 nếu có lỗi
  Future<bool> updateExpense(Expense expense) async {
    try {
      return await _expenseRepository.updateExpense(expense);
    } catch (e) {
      print('Lỗi khi cập nhật expense: $e');
      return false;
    }
  }

  // Xóa một khoản chi tiêu
  // - Nhận expenseId làm tham số
  // - Trả về số bản ghi bị xóa (thường là 1)
  // - Trả về 0 nếu có lỗi
  Future<bool> deleteExpense(int expenseId) async {
    try {
      return await _expenseRepository.deleteExpense(expenseId);
    } catch (e) {
      print('Lỗi khi xóa expense: $e');
      return false;
    }
  }

  // Tính tổng số tiền chi tiêu theo danh mục
  // - Nhận userId và category làm tham số
  // - Trả về tổng số tiền (double) của category
  // - Trả về 0.0 nếu có lỗi
  Future<double> getCategoryTotal(int userId, String category) async {
    try {
      return await _expenseRepository.getTotalExpensesByCategory(category);
    } catch (e) {
      print('Lỗi khi tính tổng theo category: $e');
      return 0.0;
    }
  }


Future<double> getTotalByType(int userId, String type) async {
  try {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return await _expenseRepository.getTotalByType(type, userId, startOfMonth, endOfMonth);
  } catch (e) {
    print('Lỗi khi tính tổng theo loại: $e');
    return 0.0;
  }
}

}