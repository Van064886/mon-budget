// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/core/utils/app_notifier.dart';
import 'package:mon_budget/models/expense_category.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
      builder: (context, categoryService, child) {
        final categories = categoryService.categories;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Catégories de dépenses",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await categoryService.fetchCategories();
            },
            child:
                categoryService.isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.mainColor,
                      ),
                    )
                    : categories.isEmpty
                    ? ListView(
                      children: [
                        SizedBox(height: 400),
                        Center(child: Text("Aucune catégorie enregistrée.")),
                      ],
                    )
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Slidable(
                          key: ValueKey(category.id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) async {
                                  final expenseService =
                                      Provider.of<ExpenseService>(
                                        context,
                                        listen: false,
                                      );

                                  final success = await categoryService
                                      .deleteExpenseCategory(
                                        category.id!,
                                        expenseService: expenseService,
                                      );

                                  if (success) {
                                    AppNotifier.show(
                                      context,
                                      type: ToastificationType.success,
                                      message:
                                          "Catégorie ${category.name} supprimée",
                                    );
                                  } else {
                                    AppNotifier.show(
                                      context,
                                      type: ToastificationType.error,
                                      message:
                                          "Impossible ! Catégorie associée à des dépenses",
                                    );
                                  }
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
                                backgroundColor: Colors.teal.shade100,
                                child: const Icon(
                                  Icons.category,
                                  color: Colors.teal,
                                ),
                              ),
                              title: Text(category.name),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddCategoryDialog(context);
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
    CategoryService categoryService = Provider.of(context, listen: false);
    categoryService.fetchCategories();
  }

  bool categoryAlreadyExists(String category) {
    CategoryService categoryService = Provider.of(context, listen: false);

    final alreadyExists = categoryService.categories.any(
      (cat) => cat.name.toLowerCase() == category.toLowerCase(),
    );

    if (alreadyExists) {
      AppNotifier.show(
        context,
        type: ToastificationType.warning,
        message: "La catégorie $category existe déjà !",
      );
      return true;
    }

    return false;
  }

  void showAddCategoryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    CategoryService categoryService = Provider.of(context, listen: false);

    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text(
                'Ajouter une catégorie',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la catégorie',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un nom valide';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
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
                    String categoryName = nameController.text.trim();
                    if (formKey.currentState!.validate()) {
                      final newCategory = ExpenseCategory(name: categoryName);

                      if (!categoryAlreadyExists(categoryName)) {
                        await categoryService.addExpenseCategory(newCategory);

                        AppNotifier.show(
                          context,
                          type: ToastificationType.success,
                          message: "Catégorie ajoutée avec succès !",
                        );
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
      );
    }
  }
}
