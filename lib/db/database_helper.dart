// lib/db/database_helper.dart
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const _dbName = 'chi_tieu'; // Tên box trong Hive
  static const _userBoxName = 'users';
  static const _expenseBoxName = 'expenses';

  Box? _userBox;
  Box? _expenseBox;

  Future<Box> get userBox async {
    _userBox ??= await instance._initBox(_userBoxName);
    return _userBox!;
  }

  Future<Box> get expenseBox async {
    _expenseBox ??= await instance._initBox(_expenseBoxName);
    return _expenseBox!;
  }

  Future<Box> _initBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(join(directory.path, _dbName));
      
      // Đăng ký adapter nếu cần (phải tạo adapter trước)
      // Hive.registerAdapter(UserAdapter());
      // Hive.registerAdapter(ExpenseAdapter());
      
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  // Tương đương với _onCreate trong sqflite
  Future<void> initialize() async {
    await _initBox(_userBoxName);
    await _initBox(_expenseBoxName);
  }

  // Đóng kết nối database khi không dùng
  Future<void> close() async {
    await _userBox?.close();
    await _expenseBox?.close();
    _userBox = null;
    _expenseBox = null;
  }
}