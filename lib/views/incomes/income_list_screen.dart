import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:provider/provider.dart';

import '../../services/income_service.dart';

class IncomeListScreen extends StatefulWidget {
  const IncomeListScreen({super.key});

  @override
  State<IncomeListScreen> createState() => _IncomeListPageState();
}

class _IncomeListPageState extends State<IncomeListScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    Provider.of<IncomeService>(context, listen: false).fetchIncomes();

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
    final incomeService = Provider.of<IncomeService>(context);
    final allIncomes = incomeService.incomes;

    final filteredIncomes =
        allIncomes.where((i) => isWithinPeriod(i.date)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes Revenus",
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
                    HeroIcons.calendarDateRange,
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
                    HeroIcons.calendarDateRange,
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
              onRefresh: () => incomeService.fetchIncomes(),
              child:
                  filteredIncomes.isEmpty
                      ? ListView(
                        children: [
                          SizedBox(height: 300),
                          Center(
                            child: Text("Aucun revenu pour cette période."),
                          ),
                        ],
                      )
                      : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredIncomes.length,
                        itemBuilder: (context, index) {
                          final income = filteredIncomes[index];

                          return Slidable(
                            key: ValueKey(income.id),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    incomeService.deleteIncome(income.id!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Revenu "${income.label}" supprimé',
                                        ),
                                      ),
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
                                  backgroundColor: Colors.green.shade100,
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  ),
                                ),
                                title: Text(income.label),
                                subtitle: Text(income.date),
                                trailing: Text(
                                  "+ ${income.amount.toStringAsFixed(2)} FCFA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
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
          Navigator.pushNamed(context, '/incomes/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
