import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';

class BudgetService extends ChangeNotifier {
  final dbHelper = DatabaseHelper();

  Future<void> insertBudget(Map<String, dynamic> budget) async {
    final db = await dbHelper.db;
    await db.insert('budgets', budget);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final db = await dbHelper.db;
    return await db.query('budgets');
  }

  Future<void> deleteBudget(int id) async {
    final db = await dbHelper.db;
    await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }
}
