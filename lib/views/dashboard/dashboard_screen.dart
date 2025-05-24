import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Budgets vs Dépenses",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
                _buildBudgetCard("Alimentation", 500, 300, Colors.teal),
                _buildBudgetCard("Transport", 200, 150, Colors.orange),
                _buildBudgetCard("Logement", 1000, 1000, Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetCard(
    String title,
    double budget,
    double spent,
    Color color,
  ) {
    final percent = (spent / budget).clamp(0.0, 1.0);
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
              "$spent / $budget FCFA",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
