import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/workout_plan_generator.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final Exercise exercise;

  const WorkoutPlayerScreen({super.key, required this.exercise});

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.exercise.value;
  }

  void _startTimer() {
    if (_timer != null) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopTimer();
        _showCompleteDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() => _isRunning = false);
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _remainingSeconds = widget.exercise.value;
      _isRunning = false;
    });
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "Workout Complete",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: const Text(
          "Excellent work! You've successfully finished this exercise.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              Navigator.pop(context); // Pop player screen
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.exercise.value > 0 
        ? _remainingSeconds / widget.exercise.value 
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            children: [
              // Exercise Name at top
              Text(
                widget.exercise.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              const Spacer(),
              
              // Lottie Animation in the middle
              SliverPadding(
                padding: const EdgeInsets.all(0), // Dummy padding if needed, but we are in Column
                sliver: null, // Just a reminder of layout
              ),
              Container(
                height: 300,
                child: widget.exercise.animationAsset.startsWith('http')
                  ? Lottie.network(
                      widget.exercise.animationAsset,
                      onWarning: (w) => print("Lottie Warning: $w"),
                    )
                  : Lottie.asset(
                      widget.exercise.animationAsset,
                    ),
              ),
              
              const Spacer(),
              
              // Timer with Circular Progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withAlpha(10),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                    ),
                  ),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stop Button
                  _controlButton(
                    icon: Icons.stop_rounded,
                    color: Colors.redAccent,
                    onTap: _stopTimer,
                  ),
                  const SizedBox(width: 40),
                  // Start/Pause Button
                  _controlButton(
                    icon: _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.blue.shade600,
                    size: 80,
                    onTap: _isRunning ? _pauseTimer : _startTimer,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 64,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.6),
      ),
    );
  }
}
