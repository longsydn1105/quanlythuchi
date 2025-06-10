import 'package:shared_preferences/shared_preferences.dart';

import '../db/database_helper.dart';
import '/models/user.dart';

class UserController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Đăng ký tài khoản mới
  Future<({bool success, String message})> register(
    String username,
    String password,
    String confirmPassword,
  ) async {
    try {
      // Validate input
      if (username.isEmpty || password.isEmpty) {
        return (
          success: false,
          message: 'Tên đăng nhập và mật khẩu không được để trống',
        );
      }

      if (password != confirmPassword) {
        return (success: false, message: 'Mật khẩu xác nhận không khớp');
      }

      if (password.length < 6) {
        return (success: false, message: 'Mật khẩu phải có ít nhất 6 ký tự');
      }

      // Kiểm tra username đã tồn tại chưa
      final existingUser = await _dbHelper.getUserByUsername(username);
      if (existingUser != null) {
        return (success: false, message: 'Tên đăng nhập đã được sử dụng');
      }

      // Tạo user mới
      final user = User(username: username, password: password);
      await _dbHelper.saveUser(user);

      return (success: true, message: 'Đăng ký thành công');
    } catch (e) {
      return (success: false, message: 'Lỗi hệ thống: ${e.toString()}');
    }
  }

  // Đăng nhập
  Future<({bool success, String message, User? user})> login(
    String username,
    String password,
  ) async {
    try {
      // Validate input
      if (username.isEmpty || password.isEmpty) {
        return (
          success: false,
          message: 'Tên đăng nhập và mật khẩu không được để trống',
          user: null,
        );
      }

      // Tìm user theo username
      final user = await _dbHelper.getUserByUsername(username);
      if (user == null) {
        return (
          success: false,
          message: 'Tên đăng nhập không tồn tại',
          user: null,
        );
      }

      // Kiểm tra mật khẩu
      if (user.password != password) {
        return (
          success: false,
          message: 'Mật khẩu không chính xác',
          user: null,
        );
      }

      // Lưu trạng thái đăng nhập
      await _dbHelper.setCurrentUserId(user.id!);

      return (success: true, message: 'Đăng nhập thành công', user: user);
    } catch (e) {
      return (
        success: false,
        message: 'Lỗi hệ thống: ${e.toString()}',
        user: null,
      );
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _dbHelper.clearCurrentUser();
  }

  // Lấy thông tin user hiện tại
  Future<User?> getCurrentUser() async {
    final userId = await _dbHelper.getCurrentUserId();
    if (userId == null) return null;
    return await _dbHelper.getUser(userId);
  }

  // Cập nhật tên user
  Future<({bool success, String message})> updateNameAndPassword({
    required String currentPassword,
    String? newName,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        return (success: false, message: 'Bạn chưa đăng nhập');
      }

      if (user.password != currentPassword) {
        return (success: false, message: 'Mật khẩu hiện tại không chính xác');
      }

      if ((newPassword != null && newPassword.isNotEmpty) ||
          (confirmPassword != null && confirmPassword.isNotEmpty)) {
        if (newPassword!.length < 6) {
          return (
            success: false,
            message: 'Mật khẩu mới phải có ít nhất 6 ký tự',
          );
        }
        if (newPassword != confirmPassword) {
          return (success: false, message: 'Mật khẩu xác nhận không khớp');
        }
      }

      final updatedUser = user.copyWith(
        username: newName?.isNotEmpty == true ? newName : user.username,
        password: newPassword?.isNotEmpty == true ? newPassword : user.password,
      );

      await _dbHelper.saveUser(updatedUser);
      return (success: true, message: 'Cập nhật thành công');
    } catch (e) {
      return (success: false, message: 'Lỗi hệ thống: ${e.toString()}');
    }
  }

  // Đổi mật khẩu
  Future<({bool success, String message})> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        return (success: false, message: 'Bạn chưa đăng nhập');
      }

      if (user.password != currentPassword) {
        return (success: false, message: 'Mật khẩu hiện tại không chính xác');
      }

      if (newPassword.length < 6) {
        return (
          success: false,
          message: 'Mật khẩu mới phải có ít nhất 6 ký tự',
        );
      }

      if (newPassword != confirmPassword) {
        return (success: false, message: 'Mật khẩu xác nhận không khớp');
      }

      // Cập nhật mật khẩu mới
      final updatedUser = user.copyWith(password: newPassword);
      await _dbHelper.saveUser(updatedUser);

      return (success: true, message: 'Đổi mật khẩu thành công');
    } catch (e) {
      return (success: false, message: 'Lỗi hệ thống: ${e.toString()}');
    }
  }

  // Xóa tài khoản
  Future<({bool success, String message})> deleteAccount(
    String password,
  ) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        return (success: false, message: 'Bạn chưa đăng nhập');
      }

      if (user.password != password) {
        return (success: false, message: 'Mật khẩu không chính xác');
      }

      // Xóa user
      await _dbHelper.deleteUser(user.id!);
      await logout();

      return (success: true, message: 'Đã xóa tài khoản thành công');
    } catch (e) {
      return (success: false, message: 'Lỗi hệ thống: ${e.toString()}');
    }
  }

  // Đặt giới hạn chi tiêu cho mỗi user
  Future<void> setLimit(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('spending_limit', amount);
  }

  Future<double?> getLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('spending_limit');
  }
}
