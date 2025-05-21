import 'package:mon_budget/models/income.dart';
import 'package:mon_budget/services/base_service.dart';

class IncomeService extends BaseService {
  final List<Income> _incomes = [];

  List<Income> get incomes => _incomes;

  Future<void> fetchIncomes() async {
    setIsLoading(true);

    final db = await dbHelper.db;
    final List<Map<String, dynamic>> result = await db.query('incomes');

    _incomes
      ..clear()
      ..addAll(result.map((e) => Income.fromMap(e)).toList().reversed);

    setIsLoading(false);
  }

  // Add a new income
  Future<void> addIncome(Income income) async {
    final db = await dbHelper.db;
    await db.insert('incomes', income.toMap());
    await fetchIncomes();
  }

  // Delete an income using it's ID
  Future<void> deleteIncome(int id) async {
    final db = await dbHelper.db;
    await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
    _incomes.removeWhere((income) => income.id == id);
    notifyListeners();
  }

  // Clear all registered incomes
  Future<void> clearIncomes() async {
    final db = await dbHelper.db;
    await db.delete('incomes');
    _incomes.clear();
    notifyListeners();
  }
}
