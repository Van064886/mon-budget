class Expense {
  final int? id;
  final String date;
  final double amount;
  final String label;
  final int categoryId;
  final String? note;

  Expense({
    this.id,
    required this.date,
    required this.amount,
    required this.label,
    required this.categoryId,
    this.note,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'date': date,
      'amount': amount,
      'label': label,
      'categoryId': categoryId,
      'note': note,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      date: map['date'],
      amount: map['amount'],
      label: map['label'],
      categoryId: map['categoryId'],
      note: map['note'],
    );
  }

  @override
  String toString() =>
      'Expense(id: $id, date: $date, amount: $amount, label: $label, categoryId: $categoryId)';

  // Faker
  static List<Expense> fakeExpenses = [
    Expense(date: '2025-05-01', amount: 120, label: 'Courses', categoryId: 1),
    Expense(date: '2025-05-03', amount: 50, label: 'Taxi', categoryId: 2),
    Expense(date: '2025-05-05', amount: 750, label: 'Loyer', categoryId: 3),
  ];
}
