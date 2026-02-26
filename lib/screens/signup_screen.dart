import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _signup() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (error != null) {
        _showError(error);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          // Dynamic Background Accent
          Positioned(
            top: -100,
            left: -100,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.primaryColor, size: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Create\nAccount",
                    style: TextStyle(
                      fontSize: 48, 
                      fontWeight: FontWeight.w900, 
                      color: theme.textTheme.titleLarge?.color, 
                      letterSpacing: -2.5,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Start your transformation today.",
                    style: TextStyle(fontSize: 15, color: theme.hintColor, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 48),

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
                        const SizedBox(height: 20),
                        _buildGlassField(
                          theme: theme,
                          controller: _confirmPasswordController,
                          hint: "Confirm Password",
                          icon: Icons.lock_reset_rounded,
                          isPassword: true,
                          obscureText: _obscurePassword,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text("CREATE PROFILE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Secured by 256-bit encryption",
                          style: TextStyle(color: theme.hintColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 40, height: 1, color: theme.dividerColor),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text("LEGAL", style: TextStyle(color: theme.hintColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                            ),
                            Container(width: 40, height: 1, color: theme.dividerColor),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Terms", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 20),
                            Text("Privacy", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
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
          suffixIcon: isPassword && onToggle != null
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
