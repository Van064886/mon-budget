import 'package:flutter/material.dart';
import 'package:mon_budget/core/configs/app_providers.dart';
import 'package:mon_budget/core/configs/app_routes.dart';
import 'package:mon_budget/core/configs/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Mon Budget',
        theme: AppTheme.lightTheme,
        routes: AppRoutes.routes,
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
