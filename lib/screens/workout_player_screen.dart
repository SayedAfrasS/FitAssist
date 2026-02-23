import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/workout_plan_generator.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const WorkoutPlayerScreen({super.key, required this.exercises});

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  int _currentIndex = 0;
  int _timerValue = 0;
  Timer? _timer;
  bool _isResting = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startExercise();
  }

  void _startExercise() {
    final ex = widget.exercises[_currentIndex];
    if (ex.type == "time") {
      setState(() {
        _timerValue = ex.value;
        _isResting = false;
        _isPaused = false;
      });
      _startTimer();
    } else {
      setState(() {
        _timerValue = 0;
        _isResting = false;
        _isPaused = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_timerValue > 0) {
            _timerValue--;
          } else {
            timer.cancel();
            _handleNext();
          }
        });
      }
    });
  }

  void _handleNext() {
    if (_isResting) {
      if (_currentIndex < widget.exercises.length - 1) {
        setState(() {
          _currentIndex++;
          _isResting = false;
        });
        _startExercise();
      } else {
        _finishWorkout();
      }
    } else {
      // Start Rest Period (15s)
      setState(() {
        _isResting = true;
        _timerValue = 15;
      });
      _startTimer();
    }
  }

  void _finishWorkout() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.blue.withAlpha(20), shape: BoxShape.circle),
                child: const Icon(Icons.emoji_events_rounded, color: Colors.blue, size: 60),
              ),
              const SizedBox(height: 24),
              const Text(
                "PEAK REACHED",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              const SizedBox(height: 12),
              const Text(
                "Your performance data has been synchronized with the AI engine.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Back to day screen
                  Navigator.pop(context); // Back to home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("CONTINUE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercises[_currentIndex];
    final progress = (_currentIndex + 1) / widget.exercises.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      ),
                      Text(
                        "${_currentIndex + 1} / ${widget.exercises.length}",
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                      const SizedBox(width: 48), // for balance
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(color: Colors.white.withAlpha(10), borderRadius: BorderRadius.circular(10)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isResting ? _buildRestUI() : _buildExerciseUI(ex),
            ),

            // Controls
            _buildControls(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseUI(Exercise ex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          ex.name.toUpperCase(),
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
        ),
        const SizedBox(height: 12),
        Text(
          ex.type == "time" ? "REMAINING TIME" : "TARGET INTENSITY",
          style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12),
        ),
        const SizedBox(height: 40),
        
        // Lottie Container
        Container(
          height: 240,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(5),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withAlpha(10)),
          ),
          child: Center(
            child: Lottie.network(
              ex.animationAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.bolt_rounded, size: 80, color: Colors.blue);
              },
            ),
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Countdown / Reps
        if (ex.type == "time")
          _buildFuturisticTimer()
        else
          Text(
            "${ex.value}",
            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -5),
          ),
          
        if (ex.type != "time")
          const Text("REPS", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, letterSpacing: 4)),
      ],
    );
  }

  Widget _buildRestUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.spa_rounded, color: Colors.greenAccent, size: 60),
        const SizedBox(height: 20),
        const Text(
          "RECOVERY PHASE",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
        ),
        const SizedBox(height: 40),
        _buildFuturisticTimer(),
        const SizedBox(height: 40),
        const Text(
          "UP NEXT",
          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        const SizedBox(height: 12),
        Text(
          widget.exercises[_currentIndex + 1].name,
          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildFuturisticTimer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: _timerValue / (_isResting ? 15 : widget.exercises[_currentIndex].value),
            strokeWidth: 8,
            color: _isResting ? Colors.greenAccent : Colors.blue,
            backgroundColor: Colors.white.withAlpha(10),
          ),
        ),
        Text(
          "$_timerValue",
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _controlCircle(Icons.skip_previous_rounded, () {
            if (_currentIndex > 0) {
              setState(() => _currentIndex--);
              _startExercise();
            }
          }),
          GestureDetector(
            onTap: () => setState(() => _isPaused = !_isPaused),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.white.withAlpha(20), blurRadius: 30, spreadRadius: 5),
                ],
              ),
              child: Icon(
                _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: const Color(0xFF0F172A),
                size: 50,
              ),
            ),
          ),
          _controlCircle(Icons.skip_next_rounded, _handleNext),
        ],
      ),
    );
  }

  Widget _controlCircle(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(10)),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
