import '../../db/repositories/user_repository.dart';
import '../models/user.dart';

class UserController {
  final UserRepository _userRepository;

  // Khởi tạo controller với một UserRepository
  UserController(this._userRepository);

  // Đăng ký user mới với username và password
  // - Kiểm tra username/password không trống
  // - Kiểm tra username chưa tồn tại
  // - Tạo user mới và lưu vào database
  // - Trả về ID của user mới nếu thành công
  // - Ném exception nếu có lỗi
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
      rethrow; // Hoặc return -1 để biểu thị lỗi
    }
  }

  // Lấy danh sách tất cả users từ database
  // - Trả về List<User> nếu thành công
  // - Ném exception nếu có lỗi
  Future<List<User>> getAllUsers() async {
    try {
      return await _userRepository.getAllUsers();
    } catch (e) {
      print('Lỗi khi lấy danh sách users: $e');
      rethrow;
    }
  }

  // Xác thực user bằng username và password
  // - Kiểm tra xem có user nào khớp username/password không
  // - Trả về true nếu xác thực thành công, false nếu thất bại
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

  // Kiểm tra username đã tồn tại chưa
  // - Trả về true nếu username đã tồn tại
  // - Trả về false nếu username chưa tồn tại
  // - Trả về true nếu có lỗi (coi như đã tồn tại để tránh tạo trùng)
  Future<bool> isUsernameTaken(String username) async {
    try {
      final users = await _userRepository.getAllUsers();
      return users.any((user) => user.username == username);
    } catch (e) {
      print('Lỗi kiểm tra username: $e');
      return true; // Coi như đã tồn tại để tránh tạo trùng
    }
  }
}