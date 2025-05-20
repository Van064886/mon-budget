import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class DashboardHeader extends StatelessWidget {
  final double totalRevenus;
  final double totalDepenses;

  const DashboardHeader({
    super.key,
    required this.totalRevenus,
    required this.totalDepenses,
  });

  @override
  Widget build(BuildContext context) {
    final double solde = totalRevenus - totalDepenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION 1: Bienvenue + notifications
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container A: User
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
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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

            // Container B: Notifications
            IconButton(
              icon: const HeroIcon(
                HeroIcons.bell,
                style: HeroIconStyle.outline,
              ),
              onPressed: () {
                // Notifications
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // SECTION 2: Solde total + bouton voir plus
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container A: Solde
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Solde total",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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

            // Container B: Bouton Voir plus
            TextButton(
              onPressed: () {
                // Voir plus action
              },
              child: const Text(
                "Voir plus",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // SECTION 3: Total revenus & dépenses
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const HeroIcon(
                          HeroIcons.arrowTrendingUp,
                          style: HeroIconStyle.solid,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total revenus",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$totalRevenus FCFA",
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
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const HeroIcon(
                          HeroIcons.arrowTrendingDown,
                          style: HeroIconStyle.solid,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total dépenses",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$totalDepenses FCFA",
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
