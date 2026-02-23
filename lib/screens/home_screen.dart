import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/workout_plan_generator.dart';
import 'workout_day_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _startWorkout(BuildContext context, {String? customGoal, String? customFocus}) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    final goal = customGoal ?? args?['goal'] ?? "Muscle Growth";
    final activityLevel = args?['activityLevel'] ?? "Moderately Active";
    final focusArea = customFocus ?? args?['focusArea'] ?? "Full Body";

    final generator = WorkoutPlanGenerator();
    final plan = generator.generatePlan(
      goal: goal,
      activityLevel: activityLevel,
      focus: focusArea,
      weeklyDays: 4,
    );

    if (plan.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutDayScreen(workoutDay: plan[0]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainDashboard(context),
          const StatsScreen(),
          const ProfileScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: Border(top: BorderSide(color: Colors.white.withAlpha(10))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navIcon(Icons.home_filled, 0),
            _navIcon(Icons.bar_chart_rounded, 1),
            _navIcon(Icons.person_rounded, 2),
            _navIcon(Icons.settings_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDashboard(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "FitAssist",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1.5),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.blue, size: 20),
                  onPressed: () {},
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
          // AI Performance Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.indigo.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade900.withAlpha(80),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   children: [
                     Icon(Icons.auto_awesome_rounded, color: Colors.blue.shade300, size: 20),
                     const SizedBox(width: 8),
                     const Text(
                      "AI OPTIMIZED",
                      style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
                   ],
                 ),
                const SizedBox(height: 12),
                const Text(
                  "Reach your\nDaily Peak",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _startWorkout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("RESUME TRAINING", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          _sectionHeader("Metabolic Activity"),
          const SizedBox(height: 20),
          Row(
            children: [
              _statCard("ENERGY", "1,240", "kcal", Icons.bolt_rounded, Colors.orange),
              const SizedBox(width: 16),
              _statCard("STAMINA", "84%", "peak", Icons.favorite_rounded, Colors.redAccent),
            ],
          ),
          
          const SizedBox(height: 40),
          
          _sectionHeader("Next Sessions"),
          const SizedBox(height: 20),
          _sessionItem("Chest Power", "45 min", "High", Icons.fitness_center_rounded, goal: "Muscle Growth", focus: "Upper Body"),
          _sessionItem("Recovery Yoga", "15 min", "Smooth", Icons.self_improvement_rounded, goal: "Better Health", focus: "Full Body"),
          _sessionItem("Core Stability", "20 min", "Medium", Icons.grid_view_rounded, goal: "Muscle Growth", focus: "Core & Abs"),
        ],
      ),
    );
  }

  Widget _buildSettingsPlaceholder() {
    return const Center(child: Text("Settings Module Coming Soon", style: TextStyle(color: Colors.white54)));
  }

  Widget _sectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w900, 
        color: Colors.white38,
        letterSpacing: 2,
      ),
    );
  }

  Widget _statCard(String label, String value, String unit, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(5),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withAlpha(5), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(unit, style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _sessionItem(String title, String duration, String level, IconData icon, {String? goal, String? focus}) {
    return GestureDetector(
      onTap: () => _startWorkout(context, customGoal: goal, customFocus: focus),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withAlpha(5), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade700]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(duration, style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue.withAlpha(30), borderRadius: BorderRadius.circular(6)),
                        child: Text(level.toUpperCase(), style: const TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    bool active = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: active ? BoxDecoration(color: Colors.blue.withAlpha(20), shape: BoxShape.circle) : null,
        child: Icon(icon, color: active ? Colors.blue : Colors.white24, size: 28),
      ),
    );
  }
}
