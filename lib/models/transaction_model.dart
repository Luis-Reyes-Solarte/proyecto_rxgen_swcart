enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String currency;
  final String concept;
  final String category;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.concept,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'concept': concept,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      type: map['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      concept: map['concept'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
