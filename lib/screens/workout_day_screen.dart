import 'package:flutter/material.dart';
import '../services/workout_plan_generator.dart';
import 'workout_player_screen.dart';

class WorkoutDayScreen extends StatefulWidget {
  final WorkoutDay workoutDay;

  const WorkoutDayScreen({super.key, required this.workoutDay});

  @override
  State<WorkoutDayScreen> createState() => _WorkoutDayScreenState();
}

class _WorkoutDayScreenState extends State<WorkoutDayScreen> {
  late List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = List.from(widget.workoutDay.exercises);
  }

  String _calculateTotalDuration() {
    int totalSeconds = 0;
    for (var ex in _exercises) {
      if (ex.type == "time") {
        totalSeconds += ex.value;
      } else {
        totalSeconds += (ex.value * 3);
      }
    }
    int minutes = totalSeconds ~/ 60;
    return "$minutes min";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Sleek Header Sliver
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0F172A),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.workoutDay.title.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2),
              ),
              background: Stack(
                children: [
                   Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade900, const Color(0xFF0F172A)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _statHeader(Icons.timer_outlined, _calculateTotalDuration()),
                            const SizedBox(width: 40),
                            _statHeader(Icons.fitness_center_rounded, "${_exercises.length} Exercises"),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Exercise List
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final exercise = _exercises[index];
                  return _buildExerciseTile(exercise, index);
                },
                childCount: _exercises.length,
              ),
            ),
          ),
        ],
      ),
      
      // Fixed Start Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutPlayerScreen(exercises: _exercises),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: const Center(
              child: Text(
                "COMMENCE TRAINING",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statHeader(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade400, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildExerciseTile(Exercise exercise, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(10), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.bolt_rounded, color: Colors.blue.shade400, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  exercise.type == "time" ? "${exercise.value} SECONDS" : "${exercise.value} REPS",
                  style: TextStyle(
                    color: Colors.blue.shade400,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withAlpha(10), shape: BoxShape.circle),
            child: const Icon(Icons.reorder_rounded, color: Colors.white24, size: 20),
          ),
        ],
      ),
    );
  }
}
