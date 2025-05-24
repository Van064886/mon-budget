class Budget {
  final int? id;
  final String periodicity; // Hebdomadaire, mensuel, trimestriel, annuel
  final double amount;
  final int categoryId;

  Budget({
    this.id,
    required this.periodicity,
    required this.amount,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'periodicity': periodicity,
      'amount': amount,
      'categoryId': categoryId,
    };
    if (id != null) map['id'] = id!;
    return map;
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as int?,
      periodicity: map['periodicity'],
      amount: map['amount'],
      categoryId: map['categoryId'],
    );
  }

  @override
  String toString() =>
      'Budget(id: $id, periodicity: $periodicity, amount: $amount, categoryId: $categoryId)';

  // Faker
  static List<Budget> fakeBudgets = [
    Budget(periodicity: 'mensuel', amount: 5000, categoryId: 1),
    Budget(periodicity: 'hebdomadaire', amount: 300, categoryId: 2),
    Budget(periodicity: 'annuel', amount: 12000, categoryId: 3),
  ];
}
