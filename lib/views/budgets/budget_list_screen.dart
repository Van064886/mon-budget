// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/core/utils/app_notifier.dart';
import 'package:mon_budget/models/budget.dart';
import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/budget_service.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<BudgetService, CategoryService>(
      builder: (context, budgetService, categoryService, child) {
        final budgets = budgetService.budgets;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Gestion des budgets",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await budgetService.fetchBudgets();
              await categoryService.fetchCategories();
            },
            child:
                budgetService.isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.mainColor,
                      ),
                    )
                    : budgets.isEmpty
                    ? ListView(
                      children: [
                        SizedBox(height: 400),
                        Center(child: Text("Aucun budget enregistré.")),
                      ],
                    )
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: budgets.length,
                      itemBuilder: (context, index) {
                        final budget = budgets[index];
                        final category = categoryService.categories.firstWhere(
                          (cat) => cat.id == budget.categoryId,
                          orElse: () => ExpenseCategory(name: 'Inconnue'),
                        );

                        return Slidable(
                          key: ValueKey(budget.id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) async {
                                  // final confirmed =
                                  //     await showDeleteConfirmation(context);
                                  // if (confirmed == true) {
                                  await budgetService.deleteBudget(budget.id!);
                                  AppNotifier.show(
                                    context,
                                    type: ToastificationType.success,
                                    message: "Budget supprimé",
                                  );
                                  // }
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                // label: 'Supprimer',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  showEditBudgetDialog(
                                    context,
                                    budget,
                                    categoryService,
                                  );
                                },
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                // label: 'Modifier',
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
                                backgroundColor: Colors.indigo.shade100,
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.indigo,
                                ),
                              ),
                              title: Text(
                                "${category.name} (${budget.periodicity})",
                              ),
                              subtitle: Text(
                                "Montant: ${budget.amount.toStringAsFixed(2)}",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddBudgetDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    final categoryService = Provider.of<CategoryService>(
      context,
      listen: false,
    );
    budgetService.fetchBudgets();
    categoryService.fetchCategories();
  }

  void showAddBudgetDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController amountController = TextEditingController();
    String? selectedPeriodicity;
    ExpenseCategory? selectedCategory;
    final BudgetService budgetService = Provider.of(context, listen: false);
    final CategoryService categoryService = Provider.of(context, listen: false);

    final periodicities = ['hebdomadaire', 'mensuel', 'trimestriel', 'annuel'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Nouveau budget',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Périodicité',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          periodicities
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.capitalize()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => selectedPeriodicity = value,
                      validator:
                          (value) =>
                              value == null
                                  ? 'Sélectionnez une périodicité'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ExpenseCategory>(
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          categoryService.categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => selectedCategory = value,
                      validator:
                          (value) =>
                              value == null
                                  ? 'Sélectionnez une catégorie'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Montant (FCFA)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return 'Montant invalide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    AppConstants.mainColor,
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      selectedCategory != null &&
                      selectedPeriodicity != null) {
                    final newBudget = Budget(
                      periodicity: selectedPeriodicity!,
                      amount: double.parse(amountController.text),
                      categoryId: selectedCategory!.id!,
                    );

                    final success = await budgetService.addBudget(newBudget);
                    if (success) {
                      AppNotifier.show(
                        context,
                        type: ToastificationType.success,
                        message: "Budget ajouté avec succès !",
                      );
                      Navigator.pop(context);
                    } else {
                      AppNotifier.show(
                        context,
                        type: ToastificationType.error,
                        message:
                            "Un budget existe déjà pour cette catégorie et périodicité",
                      );
                    }
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  void showEditBudgetDialog(
    BuildContext context,
    Budget budget,
    CategoryService categoryService,
  ) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController amountController = TextEditingController(
      text: budget.amount.toString(),
    );
    String selectedPeriodicity = budget.periodicity;
    ExpenseCategory? selectedCategory = categoryService.categories.firstWhere(
      (cat) => cat.id == budget.categoryId,
    );

    final periodicities = ['hebdomadaire', 'mensuel', 'trimestriel', 'annuel'];
    final BudgetService budgetService = Provider.of(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Modifier budget',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedPeriodicity,
                      decoration: const InputDecoration(
                        labelText: 'Périodicité',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          periodicities
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.capitalize()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => selectedPeriodicity = value!,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ExpenseCategory>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          categoryService.categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => selectedCategory = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Montant',
                        border: OutlineInputBorder(),
                        prefixText: 'XOF ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return 'Montant invalide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    AppConstants.mainColor,
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      selectedCategory != null) {
                    final updatedBudget = Budget(
                      id: budget.id,
                      periodicity: selectedPeriodicity,
                      amount: double.parse(amountController.text),
                      categoryId: selectedCategory!.id!,
                    );

                    final success = await budgetService.updateBudget(
                      updatedBudget,
                    );
                    if (success) {
                      AppNotifier.show(
                        context,
                        type: ToastificationType.success,
                        message: "Budget mis à jour avec succès !",
                      );
                      Navigator.pop(context);
                    } else {
                      AppNotifier.show(
                        context,
                        type: ToastificationType.error,
                        message:
                            "Un budget existe déjà pour cette catégorie et périodicité",
                      );
                    }
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  Future<bool?> showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Voulez-vous vraiment supprimer ce budget ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Non'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Oui'),
              ),
            ],
          ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
