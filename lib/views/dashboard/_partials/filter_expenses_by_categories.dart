import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mon_budget/core/constants/app_constants.dart';

class FilterExpensesByCategories extends StatefulWidget {
  const FilterExpensesByCategories({super.key});

  @override
  State<FilterExpensesByCategories> createState() =>
      _FilterExpensesByCategoriesState();
}

class _FilterExpensesByCategoriesState
    extends State<FilterExpensesByCategories> {
  final List<String> periodes = [
    'Semaine',
    'Mois',
    'Trimestre',
    'Toute les périodes',
  ];
  String selectedPeriode = 'Semaine';

  final chartData = [
    {'label': 'Alimentation', 'value': 40.0, 'color': Colors.teal},
    {'label': 'Transport', 'value': 25.0, 'color': Colors.orange},
    {'label': 'Logement', 'value': 15.0, 'color': Colors.blue},
    {'label': 'Autres', 'value': 20.0, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    final total = chartData.fold<double>(
      0,
      (sum, e) => sum + (e['value'] as double),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dépenses par catégories",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filtrer par période",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  children:
                      periodes.map((periode) {
                        final selected = periode == selectedPeriode;
                        return ChoiceChip(
                          label: Text(periode),
                          selected: selected,
                          onSelected:
                              (_) => setState(() => selectedPeriode = periode),
                          selectedColor: AppConstants.mainColor,
                          checkmarkColor:
                              selected ? Colors.white : Colors.black,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white : Colors.black,
                          ),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),

                // Pie Chart
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius:
                              MediaQuery.of(context).size.width * .12,
                          sections:
                              chartData.map((entry) {
                                final percentage = ((entry['value'] as double) /
                                        total *
                                        100)
                                    .toStringAsFixed(1);
                                return PieChartSectionData(
                                  value: entry['value'] as double,
                                  color: entry['color'] as Color,
                                  title: '$percentage%',
                                  radius:
                                      MediaQuery.of(context).size.width * 0.22,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Legend below the chart
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 8,
                      children:
                          chartData.map((entry) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: entry['color'] as Color,
                                  ),
                                ),
                                Text(
                                  '${entry['label']} (${entry['value']})',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
