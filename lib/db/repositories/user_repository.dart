import '../database_helper.dart';
import '../../../models/user.dart';

class UserRepository {
  // Thêm user mới vào database, trả về id nếu thành công hoặc -1 nếu thất bại
  Future<int> insertUser(User user) async {
    try {
      final box = await DatabaseHelper.instance.userBox;
      await box.put(user.id, user.toMap());
      return user.id ?? -1; // Trả về id của user hoặc -1 nếu null
    } catch (e) {
      print('Lỗi khi thêm user: $e');
      return -1;
    }
  }

  // Lấy toàn bộ danh sách users từ database
  Future<List<User>> getAllUsers() async {
    try {
      final box = await DatabaseHelper.instance.userBox;
      final users = box.values.toList();
      return users.map((e) => User.fromMap(e)).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách users: $e');
      return [];
    }
  }

  // Lấy user theo id
  Future<User?> getUserById(int id) async {
    try {
      final box = await DatabaseHelper.instance.userBox;
      final userData = box.get(id);
      return userData != null ? User.fromMap(userData) : null;
    } catch (e) {
      print('Lỗi khi lấy user: $e');
      return null;
    }
  }

  // Cập nhật user
  Future<bool> updateUser(User user) async {
    try {
      final box = await DatabaseHelper.instance.userBox;
      await box.put(user.id, user.toMap());
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật user: $e');
      return false;
    }
  }

  // Xóa user
  Future<bool> deleteUser(int id) async {
    try {
      final box = await DatabaseHelper.instance.userBox;
      await box.delete(id);
      return true;
    } catch (e) {
      print('Lỗi khi xóa user: $e');
      return false;
    }
  }
}