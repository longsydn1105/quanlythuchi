// lib/models/transaction.dart
class Transaction {
  double amount;
  String type;
  String category;
  String note;
  DateTime date;

  Transaction({
    required this.amount,
    required this.type,
    required this.category,
    required this.note,
    required this.date,
  });

  Transaction copy() {
    return Transaction(
      amount: amount,
      type: type,
      category: category,
      note: note,
      date: date,
    );
  }
}
