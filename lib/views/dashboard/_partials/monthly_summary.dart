import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:mon_budget/services/income_service.dart';
import 'package:provider/provider.dart';

class MonthlySummary extends StatefulWidget {
  const MonthlySummary({super.key});

  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final incomeService = Provider.of<IncomeService>(context, listen: false);
    final expenseService = Provider.of<ExpenseService>(context, listen: false);

    if (incomeService.incomes.isEmpty) await incomeService.fetchIncomes();
    if (expenseService.expenses.isEmpty) await expenseService.fetchExpenses();

    if (mounted) setState(() {});
  }

  double _calculateMonthlyTotal(List<dynamic> items) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return items.fold(0.0, (sum, item) {
      final itemDate = DateTime.tryParse(item.date);
      if (itemDate != null &&
          itemDate.isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
          itemDate.isBefore(lastDayOfMonth.add(const Duration(days: 1)))) {
        return sum + item.amount;
      }
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incomeService = Provider.of<IncomeService>(context);
    final expenseService = Provider.of<ExpenseService>(context);

    final totalRevenus = _calculateMonthlyTotal(incomeService.incomes);
    final totalDepenses = _calculateMonthlyTotal(expenseService.expenses);
    final solde = totalRevenus - totalDepenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bilan mensuel",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    "Revenus",
                    "${totalRevenus.toStringAsFixed(0)} FCFA",
                    HeroIcons.arrowTrendingUp,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    "Dépenses",
                    "${totalDepenses.toStringAsFixed(0)} FCFA",
                    HeroIcons.arrowTrendingDown,
                    Colors.red,
                  ),
                ),
              ],
            ),
            _buildInfoCard(
              "Solde actuel",
              "${solde >= 0 ? "" : "-"}${solde.abs().toStringAsFixed(0)} FCFA",
              HeroIcons.banknotes,
              solde >= 0 ? Colors.green : Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    HeroIcons icon,
    Color color, {
    bool isMain = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      borderOnForeground: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment:
              isMain ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: HeroIcon(
                icon,
                style: HeroIconStyle.solid,
                color: color,
                size: isMain ? 40 : 25,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMain ? 25 : 11,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
