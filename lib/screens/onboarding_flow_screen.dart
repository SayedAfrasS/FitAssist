import 'package:flutter/material.dart';
import '../widgets/onboarding_layout.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  final int _totalSteps = 6;
  bool _isNextEnabled = false;

  // Storing selections for a professional profile
  String? _focusArea;
  String? _activityLevel;
  String? _goal;
  String? _motivation;
  String? _gender;
  
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final Map<int, String> _stepTitles = {
    1: "What's your fitness focus?",
    2: "What's your daily activity?",
    3: "Set your fitness goal",
    4: "What motivates you most?",
    5: "Select your gender",
    6: "Your body metrics",
  };

  void _onNext() {
    if (_currentStep < _totalSteps) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
      );
    } else {
      Navigator.pushReplacementNamed(
        context, 
        '/home',
        arguments: {
          'goal': _goal,
          'focusArea': _focusArea,
          'activityLevel': _activityLevel,
        },
      );
    }
  }

  void _onBack() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _checkButtonState() {
    bool enabled = false;
    switch (_currentStep) {
      case 1: enabled = _focusArea != null; break;
      case 2: enabled = _activityLevel != null; break;
      case 3: enabled = _goal != null; break;
      case 4: enabled = _motivation != null; break;
      case 5: enabled = _gender != null; break;
      case 6: 
        enabled = _heightController.text.isNotEmpty && _weightController.text.isNotEmpty;
        break;
    }
    setState(() {
      _isNextEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      stepNumber: _currentStep,
      totalSteps: _totalSteps,
      title: _stepTitles[_currentStep] ?? "Tell us about yourself",
      isNextEnabled: _isNextEnabled,
      onNext: _onNext,
      onBack: _onBack,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentStep = index + 1;
            _checkButtonState();
          });
        },
        children: [
          _buildFocusAreaStep(),
          _buildActivityStep(),
          _buildGoalStep(),
          _buildMotivationStep(),
          _buildGenderStep(),
          _buildMetricsStep(),
        ],
      ),
    );
  }

  // --- Step 1: Focus Area ---
  Widget _buildFocusAreaStep() {
    final options = [
      {'label': 'Full Body', 'sub': 'Balanced training for everywhere', 'icon': Icons.accessibility_new_rounded},
      {'label': 'Upper Body', 'sub': 'Focus on chest, back, and arms', 'icon': Icons.fitness_center_rounded},
      {'label': 'Core & Abs', 'sub': 'Strengthen your midsection', 'icon': Icons.grid_view_rounded},
      {'label': 'Lower Body', 'sub': 'Develop legs and glutes', 'icon': Icons.directions_run_rounded},
    ];
    return _buildSelectionList(options, (val) => _focusArea = val, _focusArea);
  }

  // --- Step 2: Activity Level ---
  Widget _buildActivityStep() {
    final levels = [
      {'label': 'Sedentary', 'sub': 'Desk job, little movement', 'icon': Icons.weekend_rounded},
      {'label': 'Lightly Active', 'sub': 'Walking or light exercise 1-2 times/week', 'icon': Icons.directions_walk_rounded},
      {'label': 'Moderately Active', 'sub': 'Proper workouts 3-5 times/week', 'icon': Icons.directions_run_rounded},
      {'label': 'Very Active', 'sub': 'Intense daily training or physical job', 'icon': Icons.bolt_rounded},
    ];
    return _buildSelectionList(levels, (val) => _activityLevel = val, _activityLevel);
  }

  // --- Step 3: Goals ---
  Widget _buildGoalStep() {
    final goals = [
      {'label': 'Weight Loss', 'sub': 'Burn fat and get leaner', 'icon': Icons.monitor_weight_rounded},
      {'label': 'Muscle Growth', 'sub': 'Increase strength and size', 'icon': Icons.fitness_center_rounded},
      {'label': 'Better Health', 'sub': 'Improve stamina and energy', 'icon': Icons.favorite_rounded},
    ];
    return _buildSelectionList(goals, (val) => _goal = val, _goal);
  }

  // --- Step 4: Motivation ---
  Widget _buildMotivationStep() {
    final list = [
      {'label': 'Self Confidence', 'sub': 'Feel better in your own skin', 'icon': Icons.auto_awesome_rounded},
      {'label': 'Stress Relief', 'sub': 'Mental health and relaxation', 'icon': Icons.spa_rounded},
      {'label': 'Longevity', 'sub': 'Stay healthy for the future', 'icon': Icons.health_and_safety_rounded},
      {'label': 'Performance', 'sub': 'Push your physical limits', 'icon': Icons.bolt_rounded},
    ];
    return _buildSelectionList(list, (val) => _motivation = val, _motivation);
  }

  // --- Step 5: Gender ---
  Widget _buildGenderStep() {
    final list = [
      {'label': 'Male', 'icon': Icons.male_rounded},
      {'label': 'Female', 'icon': Icons.female_rounded},
      {'label': 'Non-binary', 'icon': Icons.person_search_rounded},
    ];
    return _buildSelectionList(list, (val) => _gender = val, _gender);
  }

  // --- Step 6: Metrics ---
  Widget _buildMetricsStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _MetricCard(
            controller: _heightController,
            label: "Height",
            unit: "cm",
            icon: Icons.height_rounded,
            onChanged: (v) => _checkButtonState(),
          ),
          const SizedBox(height: 20),
          _MetricCard(
            controller: _weightController,
            label: "Weight",
            unit: "kg",
            icon: Icons.monitor_weight_rounded,
            onChanged: (v) => _checkButtonState(),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(20),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blue.withAlpha(30)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_fix_high_rounded, color: Colors.blue.shade400, size: 28),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Our AI uses these metrics to generate your optimal metabolic training profile.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectionList(List<Map<String, dynamic>> items, Function(String) onSet, String? current) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final label = item['label'] as String;
        final isSelected = current == label;
        return _SelectionTile(
          label: label,
          sub: item['sub'],
          icon: item['icon'] as IconData,
          isSelected: isSelected,
          onTap: () {
            setState(() => onSet(label));
            _checkButtonState();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

class _SelectionTile extends StatelessWidget {
  final String label;
  final String? sub;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionTile({
    required this.label,
    this.sub,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600.withAlpha(40) : Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.white.withAlpha(20),
            width: 2,
          ),
          boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withAlpha(30), blurRadius: 15, offset: const Offset(0, 8))] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      sub!,
                      style: const TextStyle(fontSize: 13, color: Colors.white54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final IconData icon;
  final Function(String) onChanged;

  const _MetricCard({
    required this.controller,
    required this.label,
    required this.unit,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(20), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade400, size: 28),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "00",
                    hintStyle: TextStyle(color: Colors.white10),
                  ),
                ),
              ],
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.blue.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
