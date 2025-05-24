// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/core/utils/app_notifier.dart';
import 'package:mon_budget/models/expense.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Load categories if necessary
    final categoryService = Provider.of<CategoryService>(
      context,
      listen: false,
    );
    if (categoryService.categories.isEmpty) {
      categoryService.fetchCategories();
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true ||
        _selectedCategoryId == null) {
      return;
    }

    final expense = Expense(
      date: _dateController.text.trim(),
      label: _labelController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      categoryId: _selectedCategoryId!,
      note:
          _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
    );

    await Provider.of<ExpenseService>(
      context,
      listen: false,
    ).addExpense(expense);

    AppNotifier.show(
      context,
      message: 'Dépense ajoutée avec succès',
      type: ToastificationType.success,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    final categories = categoryService.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ajouter une dépense",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(_dateController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(picked);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: "Catégorie",
                  prefixIcon: Icon(Icons.category),
                ),
                items:
                    categories
                        .map(
                          (cat) => DropdownMenuItem<int>(
                            value: cat.id,
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategoryId = value);
                },
                validator:
                    (value) =>
                        value == null
                            ? "Veuillez sélectionner une catégorie"
                            : null,
              ),
              const SizedBox(height: 16),

              // Label
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: "Libellé",
                  prefixIcon: Icon(Icons.edit),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 16),

              // Montant
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Montant (FCFA)",
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  return val == null || val <= 0
                      ? "Entrez un montant valide"
                      : null;
                },
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Note (optionnel)",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 30),

              // Save button
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Enregistrer",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.mainColor,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
