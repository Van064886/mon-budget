import 'package:flutter/material.dart';
import 'package:mon_budget/core/configs/app_routes.dart';
import 'package:mon_budget/core/configs/app_theme.dart';
import 'package:mon_budget/services/budget_service.dart';
import 'package:mon_budget/services/category_service.dart';
import 'package:mon_budget/services/expense_service.dart';
import 'package:mon_budget/services/income_service.dart';
import 'package:mon_budget/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => BudgetService()),
          ChangeNotifierProvider(create: (_) => IncomeService()),
          ChangeNotifierProvider(create: (_) => ExpenseService()),
          ChangeNotifierProvider(create: (_) => CategoryService()),
        ],
        child: MaterialApp(
          title: 'Mon Budget',
          theme: AppTheme.lightTheme,
          routes: AppRoutes.routes,
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
