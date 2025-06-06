import '../database_helper.dart';
import '../../models/user.dart';

class UserRepository {
  // Thêm user mới vào database, trả về id nếu thành công hoặc -1 nếu thất bại
  Future<int> insertUser(User user) async {
    try {
      final db = await DatabaseHelper.database;
      return await db.insert('users', user.toMap());
    } catch (e) {
      print('Lỗi khi thêm user: $e');
      return -1;
    }
  }

  // Lấy toàn bộ danh sách users từ database
  Future<List<User>> getAllUsers() async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('users');
      return maps.map((e) => User.fromMap(e)).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách users: $e');
      return [];
    }
  }
}