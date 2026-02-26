import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'onboarding_flow_screen.dart';
import '../services/theme_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final error = await _authService.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingFlowScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    }
  }

  void _showThemeDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text("Switch Appearance", style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["Neo Dark", "Light Mode", "Amoled"].map((mode) {
            final isSelected = ThemeManager().currentThemeName == mode;
            return ListTile(
              onTap: () {
                ThemeManager().setTheme(mode);
                Navigator.pop(context);
              },
              leading: Icon(
                mode == "Light Mode" ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isSelected ? theme.primaryColor : theme.hintColor,
              ),
              title: Text(
                mode,
                style: TextStyle(
                  color: isSelected ? theme.primaryColor : theme.textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                ),
              ),
              trailing: isSelected ? Icon(Icons.check_circle_rounded, color: theme.primaryColor) : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Dynamic Background Accents
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
            child: Column(
              children: [
                // Top Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: _showThemeDialog,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Icon(Icons.palette_rounded, color: theme.primaryColor, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        // Premium Brand Identity
                        Hero(
                          tag: 'logo',
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor.withAlpha(60),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.bolt_rounded, size: 54, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          "FitAssist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48, 
                            fontWeight: FontWeight.w900, 
                            color: theme.textTheme.titleLarge?.color, 
                            letterSpacing: -2.0,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "YOUR ELITE ANALYTICS PARTNER",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12, 
                            color: theme.hintColor, 
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 54),

                        // Form Container
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            children: [
                              _buildGlassField(
                                theme: theme,
                                controller: _emailController,
                                hint: "Email Address",
                                icon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              _buildGlassField(
                                theme: theme,
                                controller: _passwordController,
                                hint: "Password",
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                obscureText: _obscurePassword,
                                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Forgot Password?", 
                                    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w900, fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 70),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                            shadowColor: theme.primaryColor.withAlpha(100),
                          ),
                          child: _isLoading 
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : const Text(
                                "SIGN IN", 
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.5),
                              ),
                        ),

                        const SizedBox(height: 48),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New to the platform?", style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.w600)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                                );
                              },
                              child: Text(
                                "Join Now", 
                                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassField({
    required ThemeData theme,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color, fontSize: 17),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: theme.hintColor, fontWeight: FontWeight.w500),
          icon: Icon(icon, color: theme.primaryColor, size: 24),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                  color: theme.hintColor,
                ),
                onPressed: onToggle,
              )
            : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
