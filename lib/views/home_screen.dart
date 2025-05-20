import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mon_budget/core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppConstants.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bienvenue !",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  HeroIcon(HeroIcons.bell, size: 28, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
