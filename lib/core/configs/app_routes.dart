import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String categories = '/categories';
  static const String budgets = '/budgets';
  static const String expenses = '/expenses';
  static const String incomes = '/incomes';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    // home: (context) => HomePage(),
    // categories: (context) => CategoryListPage(),
    // budgets: (context) => BudgetListPage(),
    // expenses: (context) => ExpenseListPage(),
    // incomes: (context) => IncomeListPage(),
    // dashboard: (context) => DashboardPage(),
  };
}
