import 'package:hive/hive.dart';

part 'user.g.dart'; // File sẽ được generate tự động

@HiveType(typeId: 0) // typeId phải khác với Expense (đã dùng 1)
class User extends HiveObject {
  @HiveField(0)
  int? id; // Non-final để Hive có thể tự gán ID
  
  @HiveField(1)
  final String username;
  
  @HiveField(2)
  final String password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Chuyển đổi từ Map (hữu ích khi cần tích hợp API hoặc SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    if (map['username'] == null || map['password'] == null) {
      throw FormatException('Invalid user data: missing username or password');
    }
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Override toString để tiện debug
  @override
  String toString() {
    return 'User{id: $id, username: $username, password: ****}';
  }

  // Phương thức copyWith để tạo bản sao với thay đổi
  User copyWith({
    int? id,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  // Phương thức kiểm tra equality (tuỳ chọn)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          password == other.password;

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ password.hashCode;
}