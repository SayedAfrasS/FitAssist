import 'package:flutter/material.dart';
import '../widgets/onboarding_layout.dart';

class ActivityLevelScreen extends StatefulWidget {
  const ActivityLevelScreen({super.key});

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String? _selectedActivity;
  final ScrollController _scrollController = ScrollController();

  final List<ActivityOption> _options = [
    ActivityOption(
      title: 'Sedentary',
      subtitle: 'I sit at my desk all day',
      emoji: '🧍',
    ),
    ActivityOption(
      title: 'Lightly active',
      subtitle: 'I take short walks or light exercise',
      emoji: '🚶',
    ),
    ActivityOption(
      title: 'Moderately active',
      subtitle: 'I exercise 3-5 times a week',
      emoji: '🏃',
    ),
    ActivityOption(
      title: 'Very active',
      subtitle: 'I exercise daily and move a lot',
      emoji: '💪',
    ),
  ];

  void _onOptionSelected(String title) {
    setState(() {
      _selectedActivity = title;
    });
    
    // Auto-scroll to bottom to highlight the NEXT button
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      stepNumber: 6,
      totalSteps: 12,
      title: "What's your activity level?",
      isNextEnabled: _selectedActivity != null,
      onBack: () => Navigator.pop(context),
      onSkip: () {},
      onNext: () {
        // keep empty for now
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: _options.map((option) {
            final isSelected = _selectedActivity == option.title;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => _onOptionSelected(option.title),
                child: AnimatedScale(
                  scale: isSelected ? 1.03 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                Colors.blue.shade700,
                                Colors.blue.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade200, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected 
                            ? Colors.blue.withOpacity(0.2) 
                            : Colors.black.withOpacity(0.04),
                          blurRadius: isSelected ? 15 : 10,
                          offset: isSelected ? const Offset(0, 4) : const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          option.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 28,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ActivityOption {
  final String title;
  final String subtitle;
  final String emoji;

  ActivityOption({
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}
