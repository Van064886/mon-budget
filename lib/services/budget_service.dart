import 'package:mon_budget/models/budget.dart';
import 'package:mon_budget/services/base_service.dart';

class BudgetService extends BaseService {
  final List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  // Fetch all budgets
  Future<void> fetchBudgets() async {
    setIsLoading(true);

    final db = await dbHelper.db;
    final List<Map<String, dynamic>> result = await db.query('budgets');

    _budgets
      ..clear()
      ..addAll(result.map((e) => Budget.fromMap(e)).toList().reversed);

    setIsLoading(false);
    notifyListeners();
  }

  // Add new budget
  Future<bool> addBudget(Budget budget) async {
    final db = await dbHelper.db;

    final existing = await db.query(
      'budgets',
      where: 'periodicity = ? AND categoryId = ?',
      whereArgs: [budget.periodicity, budget.categoryId],
    );

    if (existing.isNotEmpty) {
      return false;
    }

    await db.insert('budgets', budget.toMap());
    await fetchBudgets();
    return true;
  }

  // Udpdate existing budget
  Future<bool> updateBudget(Budget budget) async {
    final db = await dbHelper.db;

    final existing = await db.query(
      'budgets',
      where: 'periodicity = ? AND categoryId = ? AND id != ?',
      whereArgs: [budget.periodicity, budget.categoryId, budget.id],
    );

    if (existing.isNotEmpty) {
      return false;
    }

    await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );

    await fetchBudgets();
    return true;
  }

  // Delete budget by id
  Future<void> deleteBudget(int id) async {
    final db = await dbHelper.db;
    await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
    _budgets.removeWhere((budget) => budget.id == id);
    notifyListeners();
  }

  // Get budget by ID
  Future<Budget?> getBudgetById(int id) async {
    final db = await dbHelper.db;
    final result = await db.query('budgets', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Budget.fromMap(result.first) : null;
  }

  // Get budget by category
  Future<List<Budget>> getBudgetsByCategory(int categoryId) async {
    final db = await dbHelper.db;
    final result = await db.query(
      'budgets',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return result.map((e) => Budget.fromMap(e)).toList();
  }

  // Get total budget amount
  Future<double> getTotalBudgetAmount(String periodicity) async {
    final db = await dbHelper.db;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM budgets WHERE periodicity = ?',
      [periodicity],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<bool> hasBudgetForCategory(int categoryId, String periodicity) async {
    final db = await dbHelper.db;
    final result = await db.query(
      'budgets',
      where: 'categoryId = ? AND periodicity = ?',
      whereArgs: [categoryId, periodicity],
    );
    return result.isNotEmpty;
  }
}
