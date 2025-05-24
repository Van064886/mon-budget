import 'package:flutter/material.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/budget_service.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:provider/provider.dart';

class BudgetVersusExpenses extends StatefulWidget {
  const BudgetVersusExpenses({super.key});

  @override
  State<BudgetVersusExpenses> createState() => _BudgetVersusExpensesState();
}

class _BudgetVersusExpensesState extends State<BudgetVersusExpenses> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    final expenseService = Provider.of<ExpenseService>(context, listen: false);
    final categoryService = Provider.of<CategoryService>(
      context,
      listen: false,
    );

    if (budgetService.budgets.isEmpty) await budgetService.fetchBudgets();
    if (expenseService.expenses.isEmpty) await expenseService.fetchExpenses();
    if (categoryService.categories.isEmpty) {
      await categoryService.fetchCategories();
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final budgetService = Provider.of<BudgetService>(context);
    final expenseService = Provider.of<ExpenseService>(context);
    final categoryService = Provider.of<CategoryService>(context);

    final Map<int, double> expensesByCategory = {};
    for (final expense in expenseService.expenses) {
      expensesByCategory.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final List<BudgetVsExpense> data = [];
    for (final budget in budgetService.budgets) {
      final category = categoryService.categories.firstWhere(
        (cat) => cat.id == budget.categoryId,
        orElse: () => ExpenseCategory(id: -1, name: 'Inconnue'),
      );

      data.add(
        BudgetVsExpense(
          categoryName: category.name,
          budgetAmount: budget.amount,
          spentAmount: expensesByCategory[budget.categoryId] ?? 0,
          color:
              AppConstants.categoryColors[budget.categoryId %
                  AppConstants.categoryColors.length],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Budgets vs Dépenses",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ),
        if (data.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              "Aucun budget défini",
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...data.map(
            (item) => _buildBudgetCard(
              item.categoryName,
              item.budgetAmount,
              item.spentAmount,
              item.color,
            ),
          ),
      ],
    );
  }

  Widget _buildBudgetCard(
    String title,
    double budget,
    double spent,
    Color color,
  ) {
    final percent = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final percentText = (percent * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "$percentText%",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 6),
            Text(
              "${spent.toStringAsFixed(0)} / ${budget.toStringAsFixed(0)} FCFA",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetVsExpense {
  final String categoryName;
  final double budgetAmount;
  final double spentAmount;
  final Color color;

  BudgetVsExpense({
    required this.categoryName,
    required this.budgetAmount,
    required this.spentAmount,
    required this.color,
  });
}
