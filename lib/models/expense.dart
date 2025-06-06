class Expense {
  final int? id;
  final int userId;
  final double amount;
  final String category;
  final String date;
  final String note;

  Expense({
    this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  // Convert từ Map => Expense object
  factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        id: json['id'],
        userId: json['user_id'],
        amount: json['amount'],
        category: json['category'],
        date: json['date'],
        note: json['note'],
      );

  // Convert từ Expense object => Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'amount': amount,
        'category': category,
        'date': date,
        'note': note,
      };
}
