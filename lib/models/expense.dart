
class Expense {
  final int? id;
  final int userId;
  final double amount;
  final String type;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.note,
  });

  // Chuyển đổi thành Map để lưu trữ trong SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(), // Chuyển DateTime thành String
      'note': note,
    };
  }

  // Tạo Expense từ Map (khi đọc từ SharedPreferences)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      userId: map['userId'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      date: DateTime.parse(map['date']), // Chuyển ngược String thành DateTime
      note: map['note'],
    );
  }

  // Phương thức để debug
  @override
  String toString() {
    return 'Expense{id: $id, userId: $userId, amount: $amount, type: $type, category: $category, date: $date, note: $note}';
  }

  // Phương thức copyWith để dễ dàng tạo bản sao với các thay đổi
  Expense copyWith({
    int? id,
    int? userId,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}