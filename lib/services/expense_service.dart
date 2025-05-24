import 'package:mon_budget/models/expense.dart';
import 'package:mon_budget/services/base_service.dart';

class ExpenseService extends BaseService {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  // Récupérer toutes les dépenses
  Future<void> fetchExpenses() async {
    setIsLoading(true);

    final db = await dbHelper.db;
    final List<Map<String, dynamic>> result = await db.query('expenses');

    _expenses
      ..clear()
      ..addAll(result.map((e) => Expense.fromMap(e)).toList().reversed);

    setIsLoading(false);
  }

  // Ajouter une dépense
  Future<void> addExpense(Expense expense) async {
    final db = await dbHelper.db;
    await db.insert('expenses', expense.toMap());
    await fetchExpenses();
  }

  // Supprimer une dépense par ID
  Future<void> deleteExpense(int id) async {
    final db = await dbHelper.db;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  // Supprimer toutes les dépenses
  Future<void> clearExpenses() async {
    final db = await dbHelper.db;
    await db.delete('expenses');
    _expenses.clear();
    notifyListeners();
  }
}
