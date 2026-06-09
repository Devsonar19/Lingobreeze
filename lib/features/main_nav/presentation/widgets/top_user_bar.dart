import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/glass_container.dart';
import '../../../../core/theme/theme_toggle_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class TopUserBar extends StatelessWidget {
  const TopUserBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String displayName = "User";

                      if (state is Authenticated && state.user.email != null) {
                        displayName = state.user.email!.split('@')[0];
                      }

                      return Text(
                        displayName,
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    },
                  ),
                ],
              ),
            ),
            const ThemeToggleWidget(),
            IconButton(
              icon: const Icon(Icons.logout),
              color: Theme.of(context).textTheme.bodyLarge?.color,
              onPressed: () {
                // Show the premium confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    final dialogTheme = Theme.of(context);

                    return Dialog(
                      backgroundColor: Colors.transparent, // Hides the default solid box
                      elevation: 0,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout_rounded, size: 48, color: Colors.redAccent.withOpacity(0.8)),
                            const SizedBox(height: 16),
                            Text(
                              "Log Out",
                              style: dialogTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Are you sure you want to log out of LingoBreeze?",
                              style: dialogTheme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: Text("Cancel", style: TextStyle(color: dialogTheme.textTheme.bodyMedium?.color, fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      context.read<AuthBloc>().add(LogoutRequested());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      elevation: 8,
                                      shadowColor: Colors.redAccent.withOpacity(0.4),
                                    ),
                                    child: const Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper for building the dropdown items
  PopupMenuItem<ThemeMode> _buildThemeMenuItem({
    required ThemeMode value,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color primaryColor,
    Color? textColor,
  }) {
    return PopupMenuItem<ThemeMode>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isSelected ? primaryColor : textColor?.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryColor : textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}