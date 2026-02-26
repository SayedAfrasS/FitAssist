import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/workout_plan_generator.dart';
import 'workout_day_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'weekly_report_screen.dart';
import 'ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedMood = "Neutral";

  void _startWorkout(BuildContext context, {String? customGoal, String? customFocus, String? customActivity}) {
    final goal = customGoal ?? "Muscle Growth";
    final activityLevel = customActivity ?? "Moderately Active";
    final focusArea = customFocus ?? "Full Body";

    final generator = WorkoutPlanGenerator();
    final plan = generator.generatePlan(
      goal: goal,
      activityLevel: activityLevel,
      focus: focusArea,
      weeklyDays: 4,
      mood: _selectedMood,
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: theme.dividerColor)),
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
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final theme = Theme.of(context);
        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final String goal = userData?['goal'] ?? "Muscle Growth";
        final String focusArea = userData?['focusArea'] ?? "Full Body";
        final String activityLevel = userData?['activityLevel'] ?? "Moderately Active";
        final double bmi = (userData?['bmi'] as num?)?.toDouble() ?? 0.0;
        final String bmiCategory = _getBMICategory(bmi);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "FitAssist",
                    style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1.5),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.dividerColor),
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
                    Text(
                      "Reach your\n$goal Goal",
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1),
                    ),
                    const SizedBox(height: 20),
                    // Mood Selector Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _moodChip("Energetic", "🔥"),
                          _moodChip("Neutral", "😐"),
                          _moodChip("Tired", "😴"),
                          _moodChip("Focused", "🎯"),
                          _moodChip("Stressed", "🧘"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _startWorkout(context, customGoal: goal, customFocus: focusArea, customActivity: activityLevel),
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
                  _statCard("BMI INDEX", bmi.toStringAsFixed(1), bmiCategory, Icons.bolt_rounded, Colors.orange),
                  const SizedBox(width: 16),
                  _statCard("FOCUS", focusArea.split(' ').first.toUpperCase(), "area", Icons.favorite_rounded, Colors.redAccent),
                ],
              ),
              
              const SizedBox(height: 40),

              _sectionHeader("AI Insights & Reports"),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildServiceCard(
                    context,
                    "Weekly\nReport",
                    Icons.assessment_rounded,
                    Colors.purpleAccent,
                    const WeeklyReportScreen(),
                  ),
                  const SizedBox(width: 16),
                  _buildServiceCard(
                    context,
                    "AI Coach\nChatbox",
                    Icons.auto_awesome_rounded,
                    Colors.blueAccent,
                    const AIChatScreen(),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              
              _sectionHeader("Next Sessions"),
              const SizedBox(height: 20),
              _sessionItem("$focusArea Power", "45 min", "High", Icons.fitness_center_rounded, goal: goal, focus: focusArea, activity: activityLevel),
              _sessionItem("Recovery Yoga", "15 min", "Smooth", Icons.self_improvement_rounded, goal: goal, focus: "Full Body", activity: activityLevel),
              _sessionItem("Core Stability", "20 min", "Medium", Icons.grid_view_rounded, goal: goal, focus: "Core & Abs", activity: activityLevel),
            ],
          ),
        );
      },
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi <= 0) return 'N/A';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  Widget _sectionHeader(String title) {
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

  Widget _buildServiceCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: theme.dividerColor, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: theme.textTheme.titleLarge?.color,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Icon(Icons.arrow_forward_rounded, color: theme.hintColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, String unit, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: theme.dividerColor, width: 1.5),
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
                Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: theme.textTheme.titleLarge?.color, letterSpacing: -1)),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(unit, style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: theme.hintColor.withAlpha(150), fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _sessionItem(String title, String duration, String level, IconData icon, {String? goal, String? focus, String? activity}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _startWorkout(context, customGoal: goal, customFocus: focus, customActivity: activity),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor, width: 1.5),
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
                  Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: theme.textTheme.titleLarge?.color)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(duration, style: TextStyle(color: theme.hintColor, fontSize: 13, fontWeight: FontWeight.bold)),
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
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.dividerColor),
          ],
        ),
      ),
    );
  }

  Widget _moodChip(String mood, String emoji) {
    final theme = Theme.of(context);
    bool isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.blue, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              mood,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0F172A) : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    bool active = _currentIndex == index;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: active ? BoxDecoration(color: Colors.blue.withAlpha(20), shape: BoxShape.circle) : null,
        child: Icon(icon, color: active ? Colors.blue : theme.hintColor.withAlpha(100), size: 28),
      ),
    );
  }
}
