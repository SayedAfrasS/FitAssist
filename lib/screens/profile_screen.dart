import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final theme = Theme.of(context);
        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final String goal = userData?['goal'] ?? "Custom Goal";
        final double bmi = (userData?['bmi'] as num?)?.toDouble() ?? 0.0;
        final String category = _getBMICategory(bmi);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // User Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [theme.primaryColor, Colors.indigo.shade800]),
                        boxShadow: [
                          BoxShadow(color: theme.primaryColor.withAlpha(50), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle, border: Border.all(color: theme.dividerColor)),
                        child: Icon(Icons.camera_alt_rounded, size: 20, color: theme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                user?.email?.split('@').first.toUpperCase() ?? "FITNESS ENTHUSIAST",
                style: TextStyle(color: theme.textTheme.titleLarge?.color, fontSize: 24, fontWeight: FontWeight.w900),
              ),
              Text(
                "$goal • $category",
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              
              const SizedBox(height: 48),
              
              _profileOption(Icons.person_outline_rounded, "Account Details", user?.email ?? "Update your profile info", context),
              _profileOption(Icons.height_rounded, "Body Metrics", "${userData?['height'] ?? '--'} cm • ${userData?['weight'] ?? '--'} kg", context),
              _profileOption(Icons.notifications_none_rounded, "Notifications", "Workout reminders & tips", context),
              _profileOption(Icons.security_rounded, "Privacy", "Manage your data & security", context),
              
              const SizedBox(height: 40),
              
              // Sign Out Button
              ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withAlpha(20),
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  side: BorderSide(color: Colors.redAccent.withAlpha(50)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded),
                    SizedBox(width: 12),
                    Text("LOGOUT SESSION", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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

  Widget _profileOption(IconData icon, String title, String sub, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.hintColor),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: theme.hintColor, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.dividerColor),
        ],
      ),
    );
  }
}
