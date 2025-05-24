import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/models/expense.dart';
import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:provider/provider.dart';

class FilterExpensesByCategories extends StatefulWidget {
  const FilterExpensesByCategories({super.key});

  @override
  State<FilterExpensesByCategories> createState() =>
      _FilterExpensesByCategoriesState();
}

class _FilterExpensesByCategoriesState
    extends State<FilterExpensesByCategories> {
  final List<String> periodes = [
    'Semaine',
    'Mois',
    'Trimestre',
    'Toutes les périodes',
  ];
  String selectedPeriode = 'Semaine';

  @override
  void initState() {
    super.initState();
    // Charge les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final expenseService = Provider.of<ExpenseService>(context, listen: false);
    final categoryService = Provider.of<CategoryService>(
      context,
      listen: false,
    );

    if (expenseService.expenses.isEmpty) {
      await expenseService.fetchExpenses();
    }
    if (categoryService.categories.isEmpty) {
      await categoryService.fetchCategories();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    final categoryService = Provider.of<CategoryService>(context);
    final expenses = expenseService.expenses;
    final categories = categoryService.categories;

    // Filter expenses based on the defined periodicity
    List<Expense> filteredExpenses = _filterExpensesByPeriod(expenses);

    // Group expenses by category
    Map<int, double> expensesByCategory = {};
    for (var expense in filteredExpenses) {
      expensesByCategory.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    // Prepare data for the chart
    List<Map<String, dynamic>> chartData = [];
    final categoryColors = AppConstants.categoryColors;

    for (var entry in expensesByCategory.entries) {
      final category = categories.firstWhere(
        (cat) => cat.id == entry.key,
        orElse: () => ExpenseCategory(id: -1, name: 'Inconnue'),
      );

      chartData.add({
        'label': category.name,
        'value': entry.value,
        'color': categoryColors[entry.key % categoryColors.length],
      });
    }

    // Sort by descending amount
    chartData.sort(
      (a, b) => (b['value'] as double).compareTo(a['value'] as double),
    );

    final total = chartData.fold<double>(
      0,
      (sum, e) => sum + (e['value'] as double),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dépenses par catégories",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filtrer par période",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  children:
                      periodes.map((periode) {
                        final selected = periode == selectedPeriode;
                        return ChoiceChip(
                          label: Text(periode),
                          selected: selected,
                          onSelected:
                              (_) => setState(() => selectedPeriode = periode),
                          selectedColor: AppConstants.mainColor,
                          checkmarkColor:
                              selected ? Colors.white : Colors.black,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white : Colors.black,
                          ),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),

                // Pie Chart
                if (chartData.isNotEmpty) ...[
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections:
                            chartData.map((entry) {
                              final percentage = ((entry['value'] as double) /
                                      total *
                                      100)
                                  .toStringAsFixed(1);
                              return PieChartSectionData(
                                value: entry['value'] as double,
                                color: entry['color'] as Color,
                                title: '$percentage%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children:
                        chartData.map((entry) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: entry['color'] as Color,
                                ),
                              ),
                              Text(
                                '${entry['label']} (${(entry['value'] as double).toStringAsFixed(0)} FCFA',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ] else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("Aucune donnée disponible"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Expense> _filterExpensesByPeriod(List<Expense> expenses) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (selectedPeriode) {
      case 'Semaine':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Mois':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Trimestre':
        final quarter = (now.month - 1) ~/ 3;
        startDate = DateTime(now.year, quarter * 3 + 1, 1);
        break;
      case 'Toutes les périodes':
      default:
        return expenses;
    }

    return expenses.where((expense) {
      final expenseDate = DateTime.tryParse(expense.date);
      return expenseDate != null &&
          expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          expenseDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
}
