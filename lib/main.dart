import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_flow_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

import 'services/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
  runApp(const FitAssistApp());
}

class FitAssistApp extends StatelessWidget {
  const FitAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FitAssist',
          theme: ThemeManager().currentTheme,
          home: const AuthWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/onboarding': (context) => const OnboardingFlowScreen(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (docSnapshot.hasData && docSnapshot.data!.exists) {
                final data = docSnapshot.data!.data() as Map<String, dynamic>?;
                if (data != null && data['onboardingCompleted'] == true) {
                  return const HomeScreen();
                }
              }
              
              return const OnboardingFlowScreen();
            },
          );
        }
        
        // Not logged in
        return const LoginScreen();
      },
    );
  }
}