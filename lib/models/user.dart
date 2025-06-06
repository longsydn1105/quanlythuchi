class User {
  final int? id;
  final String username;
  final String password;

  User({this.id, required this.username, required this.password});

  // Convert từ Map (Database) => User object
  factory User.fromMap(Map<String, dynamic> json) {
    if (json['username'] == null || json['password'] == null) {
      throw FormatException('Invalid user data');
    }
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }
  // Convert từ User object => Map (Database)
  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
      };
}
