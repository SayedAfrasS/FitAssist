import 'package:flutter/material.dart';

class OnboardingLayout extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final String title;
  final Widget child;
  final VoidCallback? onNext;
  final bool isNextEnabled;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const OnboardingLayout({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.title,
    required this.child,
    this.onNext,
    this.isNextEnabled = true,
    this.onBack,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background accents for continuity
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade900.withAlpha(40),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Premium Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onBack,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withAlpha(20)),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(10),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                height: 8,
                                width: (MediaQuery.of(context).size.width - 120) * (stepNumber / totalSteps),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        if (onSkip != null)
                          TextButton(
                            onPressed: onSkip,
                            child: const Text(
                              "Skip",
                              style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
                            ),
                          )
                        else
                          const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Main Title Header
                  const SizedBox(height: 10),
                  Text(
                    "STEP $stepNumber OF $totalSteps",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.0,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Modern Content Area
                  Expanded(child: child),

                  // Action Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0, top: 20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: isNextEnabled
                            ? LinearGradient(
                                colors: [Colors.blue.shade700, Colors.blue.shade500],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isNextEnabled ? null : Colors.white.withAlpha(10),
                        boxShadow: isNextEnabled
                            ? [
                                BoxShadow(
                                  color: Colors.blue.shade800.withAlpha(60),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                            : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isNextEnabled ? onNext : null,
                          borderRadius: BorderRadius.circular(24),
                          child: Center(
                            child: Text(
                              "CONTINUE",
                              style: TextStyle(
                                color: isNextEnabled ? Colors.white : Colors.white24,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
