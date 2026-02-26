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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                color: theme.primaryColor.withAlpha(20),
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
                              color: theme.cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Icon(Icons.arrow_back_ios_new, size: 16, color: theme.textTheme.titleLarge?.color),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: theme.dividerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                height: 8,
                                width: (MediaQuery.of(context).size.width - 120) * (stepNumber / totalSteps),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
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
                            child: Text(
                              "Skip",
                              style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold),
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
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: theme.textTheme.titleLarge?.color,
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
                                colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isNextEnabled ? null : theme.dividerColor,
                        boxShadow: isNextEnabled
                            ? [
                                BoxShadow(
                                  color: theme.primaryColor.withAlpha(60),
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
                                color: isNextEnabled ? Colors.white : theme.hintColor,
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
