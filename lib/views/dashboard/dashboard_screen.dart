import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons/heroicons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final double totalRevenus = 4500;
  final double totalDepenses = 2800;
  final List<String> periodes = ['Semaine', 'Mois', 'Trimestre'];
  String selectedPeriode = 'Mois';

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
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // SECTION FIXE : Bienvenue + notif
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow:
                      hasShadow
                          ? [
                            const BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ]
                          : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bienvenue 👋",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Utilisateur",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const HeroIcon(
                        HeroIcons.bell,
                        style: HeroIconStyle.outline,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SECTION SCROLLABLE : reste du contenu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Solde total + voir plus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Solde total",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${solde >= 0 ? "+" : "-"} ${solde.abs().toStringAsFixed(2)} FCFA",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: solde >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Voir plus",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Revenus + Dépenses
                  isWide
                      ? Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              "Total revenus",
                              "$totalRevenus FCFA",
                              HeroIcons.arrowTrendingUp,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              "Total dépenses",
                              "$totalDepenses FCFA",
                              HeroIcons.arrowTrendingDown,
                              Colors.red,
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          _buildInfoCard(
                            "Total revenus",
                            "$totalRevenus FCFA",
                            HeroIcons.arrowTrendingUp,
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            "Total dépenses",
                            "$totalDepenses FCFA",
                            HeroIcons.arrowTrendingDown,
                            Colors.red,
                          ),
                        ],
                      ),
                  const SizedBox(height: 24),

                  // Filtre par période
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Dépenses par catégorie",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children:
                        periodes.map((periode) {
                          final selected = periode == selectedPeriode;
                          return ChoiceChip(
                            label: Text(periode),
                            selected: selected,
                            onSelected:
                                (_) =>
                                    setState(() => selectedPeriode = periode),
                            selectedColor: Colors.teal,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                            ),
                            backgroundColor: Colors.grey[200],
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Pie Chart
                  AspectRatio(
                    aspectRatio: isWide ? 2.2 : 1.1,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: 40,
                            color: Colors.teal,
                            title: 'Alim',
                          ),
                          PieChartSectionData(
                            value: 25,
                            color: Colors.orange,
                            title: 'Transp',
                          ),
                          PieChartSectionData(
                            value: 15,
                            color: Colors.blue,
                            title: 'Logem',
                          ),
                          PieChartSectionData(
                            value: 20,
                            color: Colors.purple,
                            title: 'Autres',
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetCard("Alimentation", 500, 300, Colors.teal),
                  _buildBudgetCard("Transport", 200, 150, Colors.orange),
                  _buildBudgetCard("Logement", 1000, 1000, Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    HeroIcons icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: HeroIcon(icon, style: HeroIconStyle.solid, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

// Sticky header delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({required this.child, this.height = 80});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
