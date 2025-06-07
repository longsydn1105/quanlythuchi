import 'package:hive/hive.dart';

part 'expense.g.dart'; // File sẽ được generate tự động

@HiveType(typeId: 1) // Định danh duy nhất cho model
class Expense extends HiveObject {
  @HiveField(0)
  final int? id;
  
  @HiveField(1)
  final int userId;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final String type;
  
  @HiveField(4)
  final String category;
  
  @HiveField(5)
  final DateTime date;
  
  @HiveField(6)
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

  // Convert từ Map => Expense object (nếu cần cho tương thích ngược)
  factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        id: json['id'],
        userId: json['user_id'],
        amount: json['amount'],
        type: json['type'],
        category: json['category'],
        date: DateTime.parse(json['date']),
        note: json['note'],
      );

  // Convert từ Expense object => Map (nếu cần cho tương thích ngược)
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'amount': amount,
        'type': type,
        'category': category,
        'date': date.toIso8601String(),
        'note': note,
      };
}