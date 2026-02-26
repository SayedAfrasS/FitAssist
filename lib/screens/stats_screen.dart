import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PERFORMANCE",
            style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 32, letterSpacing: -1.5),
          ),
          const SizedBox(height: 8),
          Text(
            "Your metabolic activity over the last 7 days",
            style: TextStyle(color: theme.hintColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 40),
          
          // Chart Card
          Container(
            height: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: theme.dividerColor),
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4.5),
                      const FlSpot(5, 6),
                      const FlSpot(6, 5.5),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue.withAlpha(50), Colors.blue.withAlpha(0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          _statRow("Total Workouts", "24", Icons.fitness_center_rounded, Colors.blue, context),
          const SizedBox(height: 16),
          _statRow("Active Minutes", "1,420", Icons.timer_outlined, Colors.orange, context),
          const SizedBox(height: 16),
          _statRow("Calories Burned", "12.4k", Icons.local_fire_department_rounded, Colors.redAccent, context),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, IconData icon, Color color, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Text(label, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          Text(value, style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 20)),
        ],
      ),
    );
  }
}
