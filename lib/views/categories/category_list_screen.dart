import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
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
          await categoryService.fetchCategories(); // or reload from DB/API
        },
        child:
            categories.isEmpty
                ? ListView(
                  // required by RefreshIndicator to be scrollable even when empty
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
                            onPressed: (_) {
                              categoryService.deleteExpenseCategory(
                                category.id!,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Catégorie "${category.name}" supprimée',
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
          Navigator.pushNamed(context, '/categories/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
