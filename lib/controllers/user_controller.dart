import '../db/repositories/user_repository.dart';
import '../models/user.dart';

class UserController {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  Future<int> registerUser(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Username và password không được để trống');
      }

      if (await isUsernameTaken(username)) {
        throw Exception('Username đã được sử dụng');
      }

      final user = User(username: username, password: password);
      return await _userRepository.insertUser(user);
    } catch (e) {
      print('Lỗi khi đăng ký user: $e');
      rethrow;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      return await _userRepository.getAllUsers();
    } catch (e) {
      print('Lỗi khi lấy danh sách users: $e');
      rethrow;
    }
  }

  Future<bool> authenticate(String username, String password) async {
    try {
      final users = await _userRepository.getAllUsers();
      return users.any((user) =>
          user.username == username && user.password == password);
    } catch (e) {
      print('Lỗi xác thực: $e');
      return false;
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    try {
      final users = await _userRepository.getAllUsers();
      return users.any((user) => user.username == username);
    } catch (e) {
      print('Lỗi kiểm tra username: $e');
      return true;
    }
  }
}
