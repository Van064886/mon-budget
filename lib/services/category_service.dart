import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/base_service.dart';

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

  // Delete ExpenseCategory by id
  Future<void> deleteExpenseCategory(int id) async {
    final db = await dbHelper.db;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Seed DB with fake data
  Future<void> insertFakeCategories() async {
    final db = await dbHelper.db;
    for (final cat in ExpenseCategory.defaultCategories) {
      await db.insert('categories', cat.toMap());
    }
    await fetchCategories();
  }

  // Clear all categories
  Future<void> clearCategories() async {
    final db = await dbHelper.db;
    await db.delete('categories');
    _categories.clear();
    notifyListeners();
  }
}
