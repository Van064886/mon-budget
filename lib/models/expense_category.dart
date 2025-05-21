class ExpenseCategory {
  final int? id;
  final String name;

  ExpenseCategory({this.id, required this.name});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'name': name};
    if (id != null) map['id'] = id;
    return map;
  }

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(id: map['id'] as int?, name: map['name'] as String);
  }

  @override
  String toString() => 'ExpenseCategory(id: $id, name: $name)';

  // Faker data
  static List<ExpenseCategory> defaultCategories = [
    ExpenseCategory(id: 1, name: 'Alimentation'),
    ExpenseCategory(id: 2, name: 'Transport'),
    ExpenseCategory(id: 3, name: 'Logement'),
    ExpenseCategory(id: 4, name: 'Divertissement'),
    ExpenseCategory(id: 5, name: 'Santé'),
    ExpenseCategory(id: 6, name: 'Éducation'),
    ExpenseCategory(id: 7, name: 'Abonnements'),
  ];
}
