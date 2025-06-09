import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/expense.dart';
import 'dart:convert';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Key lưu trữ trong SharedPreferences
  static const _usersKey = 'users';
  static const _expensesKey = 'expenses';
  static const _currentUserIdKey = 'current_user_id';

  late SharedPreferences _prefs;

  // Khởi tạo SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== QUẢN LÝ USER ========== //
  
  // Lấy ID user hiện tại
  Future<int?> getCurrentUserId() async {
    return _prefs.getInt(_currentUserIdKey);
  }

  // Lưu ID user hiện tại
  Future<void> setCurrentUserId(int userId) async {
    await _prefs.setInt(_currentUserIdKey, userId);
  }

  // Xóa user hiện tại (đăng xuất)
  Future<void> clearCurrentUser() async {
    await _prefs.remove(_currentUserIdKey);
  }

  // Lấy danh sách tất cả user
  Future<List<User>> getUsers() async {
    final usersString = _prefs.getString(_usersKey);
    if (usersString == null) return [];
    
    try {
      final List<dynamic> usersJson = json.decode(usersString);
      return usersJson.map((userJson) => User.fromMap(userJson)).toList();
    } catch (e) {
      debugPrint('Lỗi đọc danh sách user: $e');
      return [];
    }
  }

  // Lấy user theo ID
  Future<User?> getUser(int id) async {
    final users = await getUsers();
    return users.where((user) => user.id == id).firstOrNull;
  }

  // Lấy user theo username
  Future<User?> getUserByUsername(String username) async {
    final users = await getUsers();
    return users.where((user) => user.username == username).firstOrNull;
  }

  // Lưu user (thêm mới hoặc cập nhật)
  Future<int> saveUser(User user) async {
    final users = await getUsers();
    final existingIndex = users.indexWhere((u) => u.id == user.id);

    User userToSave;
    int newId;

    if (existingIndex >= 0) {
      // Cập nhật user có sẵn
      userToSave = user;
      newId = user.id!;
      users[existingIndex] = user;
    } else {
      // Thêm user mới
      newId = users.isEmpty ? 1 : (users.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      userToSave = user.copyWith(id: newId);
      users.add(userToSave);
    }

    await _saveUsers(users);
    return newId;
  }

  // Xóa user
  Future<bool> deleteUser(int id) async {
    final users = await getUsers();
    users.removeWhere((user) => user.id == id);
    return await _saveUsers(users);
  }

  // Lưu danh sách user
  Future<bool> _saveUsers(List<User> users) async {
    final usersJson = users.map((user) => user.toMap()).toList();

    debugPrint('Đang lưu users: ${users.length} users'); //debug log
    debugPrint('Nội dung JSON: ${json.encode(usersJson)}'); //debug log

    return await _prefs.setString(_usersKey, json.encode(usersJson));
  }

  // ========== QUẢN LÝ EXPENSE ========== //
  
  // Lấy danh sách expense của user
  Future<List<Expense>> getExpenses(int userId) async {
    final expensesString = _prefs.getString(_expensesKey);
    if (expensesString == null) return [];
    
    try {
      final List<dynamic> expensesJson = json.decode(expensesString);
      return expensesJson
          .map((expenseJson) => Expense.fromMap(expenseJson))
          .where((expense) => expense.userId == userId)
          .toList();
    } catch (e) {
      debugPrint('Lỗi đọc danh sách expense: $e');
      return [];
    }
  }

  // Lấy expense theo ID
  Future<Expense?> getExpense(int id) async {
    final expensesString = _prefs.getString(_expensesKey);
    if (expensesString == null) return null;
    
    try {
      final List<dynamic> expensesJson = json.decode(expensesString);
      final expenseMap = expensesJson.firstWhere(
        (expense) => (expense as Map<String, dynamic>)['id'] == id,
        orElse: () => null,
      );
      return expenseMap != null ? Expense.fromMap(expenseMap) : null;
    } catch (e) {
      debugPrint('Lỗi lấy expense: $e');
      return null;
    }
  }

  // Lưu expense (thêm mới hoặc cập nhật)
  Future<int> saveExpense(Expense expense) async {
    final expensesString = _prefs.getString(_expensesKey);
    List<Map<String, dynamic>> expenses = [];

    if (expensesString != null) {
      expenses = List<Map<String, dynamic>>.from(json.decode(expensesString));
    }

    Expense expenseToSave;
    int newId;

    if (expense.id != null) {
      // Cập nhật expense có sẵn
      final index = expenses.indexWhere((e) => e['id'] == expense.id);
      if (index >= 0) {
        expenseToSave = expense;
        newId = expense.id!;
        expenses[index] = expenseToSave.toMap();
      } else {
        // ID tồn tại nhưng không tìm thấy - xử lý như thêm mới
        newId = expenses.isEmpty ? 1 : (expenses.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1);
        expenseToSave = expense.copyWith(id: newId);
        expenses.add(expenseToSave.toMap());
      }
    } else {
      // Thêm expense mới
      newId = expenses.isEmpty ? 1 : (expenses.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1);
      expenseToSave = expense.copyWith(id: newId);
      expenses.add(expenseToSave.toMap());
    }

    await _prefs.setString(_expensesKey, json.encode(expenses));
    return newId;
  }

  // Xóa expense
  Future<bool> deleteExpense(int id) async {
    final expensesString = _prefs.getString(_expensesKey);
    if (expensesString == null) return false;
    
    try {
      final List<dynamic> expensesJson = json.decode(expensesString);
      expensesJson.removeWhere((expense) => (expense as Map<String, dynamic>)['id'] == id);
      return await _prefs.setString(_expensesKey, json.encode(expensesJson));
    } catch (e) {
      debugPrint('Lỗi xóa expense: $e');
      return false;
    }
  }

  // Lấy expense theo category
  Future<List<Expense>> getExpensesByCategory(int userId, String category) async {
    final allExpenses = await getExpenses(userId);
    return allExpenses.where((expense) => expense.category == category).toList();
  }

  // Lấy expense theo khoảng thời gian
  Future<List<Expense>> getExpensesByDateRange(int userId, DateTime start, DateTime end) async {
    final allExpenses = await getExpenses(userId);
    return allExpenses.where((expense) => 
      expense.date.isAfter(start.subtract(const Duration(days: 1))) && 
      expense.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }
}