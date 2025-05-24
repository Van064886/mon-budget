import 'package:flutter/material.dart';
import 'package:mon_budget/views/base_screen.dart';
import 'package:mon_budget/views/categories/category_list_screen.dart';
import 'package:mon_budget/views/incomes/add_income_screen.dart';
import 'package:mon_budget/views/incomes/income_list_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String categories = '/categories';
  static const String budgets = '/budgets';
  static const String expenses = '/expenses';
  static const String incomes = '/incomes';
  static const String addIncome = '/incomes/new';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => BaseScreen(),
    categories: (context) => CategoryListScreen(),
    // budgets: (context) => BudgetListPage(),
    // expenses: (context) => ExpenseListPage(),
    incomes: (context) => IncomeListScreen(),
    addIncome: (context) => AddIncomeScreen(),
    // dashboard: (context) => DashboardPage(),
  };
}
