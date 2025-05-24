import 'package:mon_budget/services/budget_service.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:mon_budget/services/income_service.dart';
import 'package:mon_budget/services/theme_service.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider(create: (_) => ThemeService()),
    ChangeNotifierProvider(create: (_) => BudgetService()),
    ChangeNotifierProvider(create: (_) => IncomeService()),
    ChangeNotifierProvider(create: (_) => ExpenseService()),
    ChangeNotifierProvider(create: (_) => CategoryService()),
  ];
}
