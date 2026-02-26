import 'package:flutter/material.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.textTheme.titleLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Weekly Report",
          style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 32),
            _sectionHeader("Detailed Metrics", context),
            const SizedBox(height: 20),
            _metricItem("Muscle Growth", "85%", Colors.blue, "Excellent progress in strength training.", context),
            _metricItem("Calorie Burn", "12.4k", Colors.orange, "Metabolic rate is 15% higher than last week.", context),
            _metricItem("Consistency", "92%", Colors.green, "You've missed 0 scheduled sessions.", context),
            const SizedBox(height: 32),
            _buildAIRecommendation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.indigo.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("THIS WEEK", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          const Text("Peak\nPerformance", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)),
          const SizedBox(height: 20),
          Row(
            children: [
              _simpleStat("Workouts", "6"),
              const SizedBox(width: 24),
              _simpleStat("Hours", "8.5"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _simpleStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _sectionHeader(String title, BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w900, 
        color: theme.hintColor,
        letterSpacing: 2,
      ),
    );
  }

  Widget _metricItem(String title, String value, Color color, String sub, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.bold, fontSize: 18)),
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(sub, style: TextStyle(color: theme.hintColor, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAIRecommendation(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(20),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.blue.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: Colors.blue.shade400, size: 24),
              const SizedBox(width: 12),
              Text("AI STRATEGY", style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Based on your 92% consistency, next week we recommend increasing resistance on Upper Body days by 5-10%.",
            style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 15, height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
