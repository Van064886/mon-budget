import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/base_service.dart';
import 'package:mon_budget/services/expense_service.dart';

class CategoryService extends BaseService {
  final List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  // Fetch all categories from DB
  Future<void> fetchCategories() async {
    setIsLoading(true);

    final db = await dbHelper.db;
    final List<Map<String, dynamic>> result = await db.query('categories');

    _categories
      ..clear()
      ..addAll(result.map((e) => ExpenseCategory.fromMap(e)).toList().reversed);

    setIsLoading(false);
  }

  // Insert new ExpenseCategory
  Future<void> addExpenseCategory(ExpenseCategory expenseCategory) async {
    final db = await dbHelper.db;
    await db.insert('categories', expenseCategory.toMap());
    await fetchCategories();
  }

  // Check if category is used
  Future<bool> _isCategoryUsed(
    int categoryId,
    ExpenseService expenseService,
  ) async {
    await expenseService.fetchExpenses();

    return expenseService.expenses.any(
      (expense) => expense.categoryId == categoryId,
    );
  }

  // Delete ExpenseCategory by id
  Future<bool> deleteExpenseCategory(
    int id, {
    required ExpenseService expenseService,
  }) async {
    final hasExpenses = await _isCategoryUsed(id, expenseService);

    if (hasExpenses) {
      return false;
    }

    final db = await dbHelper.db;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
    return true;
  }

  // Clear all categories
  Future<void> clearCategories() async {
    final db = await dbHelper.db;
    await db.delete('categories');
    _categories.clear();
    notifyListeners();
  }
}
