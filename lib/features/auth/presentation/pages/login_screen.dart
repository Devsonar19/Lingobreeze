import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'register_screen.dart';
import '../../../../core/theme/theme_toggle_widget.dart';
import '../../../../core/theme/glass_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true, // Lets the background flow under the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          ThemeToggleWidget(),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // 1. Colorful Background Orbs
          Positioned(
            top: -50, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.blueAccent.withOpacity(0.2) : Colors.blue.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -50, right: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.purpleAccent.withOpacity(0.2) : Colors.purple.withOpacity(0.2),
              ),
            ),
          ),

          // 2. The Glass Form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      // Make sure your _showErrorDialog is still at the bottom of this file!
                      _showErrorDialog(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return GlassContainer(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(Icons.cloud_circle_rounded, size: 80, color: theme.primaryColor),
                            const SizedBox(height: 24),
                            Text(
                              "Welcome to LingoBreeze",
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to continue your journey.",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Frosted Text Fields
                            _buildFrostedTextField(
                              controller: _emailController,
                              label: "Email",
                              icon: Icons.email_outlined,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            _buildFrostedTextField(
                              controller: _passwordController,
                              label: "Password",
                              icon: Icons.lock_outline,
                              isDark: isDark,
                              isPassword: true,
                            ),
                            const SizedBox(height: 32),

                            // Glass Button
                            ElevatedButton(
                              onPressed: state is AuthLoading ? null : _submitLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 8,
                                shadowColor: theme.primaryColor.withOpacity(0.5),
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text("Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                            const SizedBox(height: 16),

                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: theme.textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(_emailController.text.trim(), _passwordController.text.trim()),
      );
    }
  }

  Widget _buildFrostedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) => val != null && val.isNotEmpty ? null : "Required field",
    );
  }
}
// Drop this at the bottom of your UI files
void _showErrorDialog(BuildContext context, String message) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 28),
          const SizedBox(width: 12),
          Text("Oops!", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
      content: Text(message, style: theme.textTheme.bodyLarge),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Try Again", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}