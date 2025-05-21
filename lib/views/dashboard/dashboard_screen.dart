import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mon_budget/core/constants/app_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final double totalRevenus = 4500;
  final double totalDepenses = 2800;
  final List<String> periodes = [
    'Semaine',
    'Mois',
    'Trimestre',
    'Toute les périodes',
  ];
  String selectedPeriode = 'Semaine';

  final ScrollController _scrollController = ScrollController();
  bool hasShadow = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 10;
      if (hasShadow != scrolled) {
        setState(() => hasShadow = scrolled);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final solde = totalRevenus - totalDepenses;

    final chartData = [
      {'label': 'Alimentation', 'value': 40.0, 'color': Colors.teal},
      {'label': 'Transport', 'value': 25.0, 'color': Colors.orange},
      {'label': 'Logement', 'value': 15.0, 'color': Colors.blue},
      {'label': 'Autres', 'value': 20.0, 'color': Colors.purple},
    ];

    final total = chartData.fold<double>(
      0,
      (sum, e) => sum + (e['value'] as double),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: HeroIcon(HeroIcons.bars3)),
        title: Text(
          "Mon Budget",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Monthly summary
                Text(
                  "Bilan mensuel",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            "Revenus",
                            "$totalRevenus FCFA",
                            HeroIcons.arrowTrendingUp,
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoCard(
                            "Dépenses",
                            "$totalDepenses FCFA",
                            HeroIcons.arrowTrendingDown,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                    _buildInfoCard(
                      "Solde actuel",
                      "${solde >= 0 ? "" : "-"}${solde.abs().toStringAsFixed(2)} FCFA",
                      HeroIcons.banknotes,
                      Colors.amber,
                      // isMain: true,
                    ),
                  ],
                ),

                // Expenses by categories
                const SizedBox(height: 24),
                Text(
                  "Dépenses par catégories",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filtrer par période",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
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
                                      (_) => setState(
                                        () => selectedPeriode = periode,
                                      ),
                                  selectedColor: AppConstants.mainColor,
                                  checkmarkColor:
                                      selected ? Colors.white : Colors.black,
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color:
                                        selected ? Colors.white : Colors.black,
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
                                        final percentage = ((entry['value']
                                                    as double) /
                                                total *
                                                100)
                                            .toStringAsFixed(1);
                                        return PieChartSectionData(
                                          value: entry['value'] as double,
                                          color: entry['color'] as Color,
                                          title: '$percentage%',
                                          radius:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.22,
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
                                          margin: const EdgeInsets.only(
                                            right: 6,
                                          ),
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

                const SizedBox(height: 30),

                // Budgets vs Dépenses
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Budgets vs Dépenses",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
                _buildBudgetCard("Alimentation", 500, 300, Colors.teal),
                _buildBudgetCard("Transport", 200, 150, Colors.orange),
                _buildBudgetCard("Logement", 1000, 1000, Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    HeroIcons icon,
    Color color, {
    bool isMain = false,
  }) {
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment:
              isMain ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: HeroIcon(
                icon,
                style: HeroIconStyle.solid,
                color: color,
                size: isMain ? 40 : 25,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMain ? 25 : 10,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(
    String title,
    double budget,
    double spent,
    Color color,
  ) {
    final percent = (spent / budget).clamp(0.0, 1.0);
    final percentText = (percent * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "$percentText%",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 6),
            Text(
              "$spent / $budget FCFA",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
