class User {
  int? id; // Có thể null khi tạo mới
  final String username;
  final String password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Chuyển đổi từ Map (khi đọc từ SharedPreferences)
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

  // Chuyển đổi sang Map (khi lưu vào SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, password: ****}';
  }

  // Tạo bản sao với các thay đổi
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