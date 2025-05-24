// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/core/utils/app_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../models/income.dart';
import '../../services/income_service.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    final income = Income(
      date: _dateController.text.trim(),
      label: _labelController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      note:
          _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
    );

    await Provider.of<IncomeService>(context, listen: false).addIncome(income);

    AppNotifier.show(
      context,
      message: 'Revenu ajouté avec succès',
      type: ToastificationType.success,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ajouter un revenu",
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
