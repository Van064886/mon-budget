class Income {
  final int? id;
  final String date;
  final double amount;
  final String label;
  final String? note;

  Income({
    this.id,
    required this.date,
    required this.amount,
    required this.label,
    this.note,
  });

  Map<String, dynamic> toMap() {
    final map = {'date': date, 'amount': amount, 'label': label, 'note': note};
    if (id != null) map['id'] = id;
    return map;
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] as int?,
      date: map['date'],
      amount: map['amount'],
      label: map['label'],
      note: map['note'],
    );
  }

  @override
  String toString() =>
      'Income(id: $id, date: $date, amount: $amount, label: $label)';

  // Faker
  static List<Income> fakeIncomes = [
    Income(date: '2025-05-01', amount: 1500, label: 'Salaire'),
    Income(date: '2025-05-10', amount: 300, label: 'Prime'),
  ];
}
