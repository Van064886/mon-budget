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
}
