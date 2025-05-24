import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mon_budget/views/dashboard/_partials/budget_versus_expenses.dart';
import 'package:mon_budget/views/dashboard/_partials/filter_expenses_by_categories.dart';
import 'package:mon_budget/views/dashboard/_partials/monthly_summary.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: HeroIcon(HeroIcons.bars3)),
        title: Text(
          "Mon Budget",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Monthly summary
                MonthlySummary(),

                // Expenses by categories
                const SizedBox(height: 24),
                FilterExpensesByCategories(),
                const SizedBox(height: 30),

                // Budgets vs Dépenses
                BudgetVersusExpenses(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
