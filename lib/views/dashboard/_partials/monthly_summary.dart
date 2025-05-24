import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class MonthlySummary extends StatefulWidget {
  const MonthlySummary({super.key});

  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  final double totalRevenus = 4500;
  final double totalDepenses = 2800;

  @override
  Widget build(BuildContext context) {
    final solde = totalRevenus - totalDepenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
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
}
