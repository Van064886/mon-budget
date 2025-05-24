import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mon_budget/core/constants/app_constants.dart';
import 'package:mon_budget/views/budgets/budget_list_screen.dart';
import 'package:mon_budget/views/categories/category_list_screen.dart';
import 'package:mon_budget/views/dashboard/dashboard_screen.dart';
import 'package:mon_budget/views/expenses/expense_list_screen.dart';
import 'package:mon_budget/views/incomes/income_list_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    CategoryListScreen(),
    ExpenseListScreen(),
    BudgetListScreen(),
    IncomeListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: HeroIcon(HeroIcons.chartBar, style: HeroIconStyle.outline),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: HeroIcon(HeroIcons.tag, style: HeroIconStyle.outline),
      label: 'Catégories',
    ),
    BottomNavigationBarItem(
      icon: HeroIcon(HeroIcons.currencyDollar, style: HeroIconStyle.outline),
      label: 'Dépenses',
    ),
    BottomNavigationBarItem(
      icon: HeroIcon(HeroIcons.wallet, style: HeroIconStyle.outline),
      label: 'Budgets',
    ),
    BottomNavigationBarItem(
      icon: HeroIcon(HeroIcons.banknotes, style: HeroIconStyle.outline),
      label: 'Revenus',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: _navItems,
        selectedItemColor: AppConstants.mainColor,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
