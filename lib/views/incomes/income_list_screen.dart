import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mon_budget/services/income_service.dart';
import 'package:provider/provider.dart';

class IncomeListScreen extends StatelessWidget {
  const IncomeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeService = Provider.of<IncomeService>(context);
    final incomes = incomeService.incomes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mes revenus",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => incomeService.fetchIncomes(),
        child:
            incomes.isEmpty
                ? ListView(
                  children: [
                    SizedBox(height: 400),
                    Center(child: Text("Aucun revenu enregistré.")),
                  ],
                )
                : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: incomes.length,
                  itemBuilder: (context, index) {
                    final income = incomes[index];

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
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/incomes/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
