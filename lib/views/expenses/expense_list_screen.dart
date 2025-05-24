import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:mon_budget/core/utils/app_notifier.dart';
import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../core/constants/app_constants.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final expenseService = Provider.of<ExpenseService>(context, listen: false);
    final categoryService = Provider.of<CategoryService>(
      context,
      listen: false,
    );

    expenseService.fetchExpenses();
    categoryService.fetchCategories();

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startDate = startOfWeek;
    endDate = now;
  }

  bool isWithinPeriod(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return false;

    return startDate != null &&
        endDate != null &&
        date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate!.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    final categoryService = Provider.of<CategoryService>(context);
    final allExpenses = expenseService.expenses;
    final categories = categoryService.categories;

    final filteredExpenses =
        allExpenses.where((e) => isWithinPeriod(e.date)).toList();

    String getCategoryName(int categoryId) {
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => ExpenseCategory(name: 'Inconnue', id: -1),
      );
      return category.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes Dépenses",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => startDate = picked);
                    }
                  },
                  icon: HeroIcon(
                    HeroIcons.calendar,
                    size: 15,
                    color: AppConstants.mainColor,
                  ),
                  label: Text(
                    startDate != null
                        ? "Du : ${DateFormat('yyyy-MM-dd').format(startDate!)}"
                        : "Du : -",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.mainColor,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => endDate = picked);
                    }
                  },
                  icon: HeroIcon(
                    HeroIcons.calendar,
                    size: 15,
                    color: AppConstants.mainColor,
                  ),
                  label: Text(
                    endDate != null
                        ? "Au : ${DateFormat('yyyy-MM-dd').format(endDate!)}"
                        : "Au : -",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await expenseService.fetchExpenses();
                await categoryService.fetchCategories();
              },
              child:
                  filteredExpenses.isEmpty
                      ? ListView(
                        children: const [
                          SizedBox(height: 300),
                          Center(
                            child: Text("Aucune dépense pour cette période."),
                          ),
                        ],
                      )
                      : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          final categoryName = getCategoryName(
                            expense.categoryId,
                          );

                          return Slidable(
                            key: ValueKey(expense.id),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    expenseService.deleteExpense(expense.id!);
                                    AppNotifier.show(
                                      context,
                                      message:
                                          'Dépense "${expense.label}" supprimée',
                                      type: ToastificationType.success,
                                    );
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Supprimer',
                                ),
                              ],
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red.shade100,
                                  child: const Icon(
                                    Icons.money_off,
                                    color: Colors.red,
                                  ),
                                ),
                                title: Text(expense.label),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(expense.date),
                                    Text(
                                      'Catégorie: $categoryName',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  "- ${expense.amount.toStringAsFixed(2)} FCFA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/expenses/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
