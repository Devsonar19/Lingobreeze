import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
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

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24), // Matches your card styling
                      ),
                      backgroundColor: dialogTheme.cardColor,
                      title: Text(
                        "Log Out",
                        style: dialogTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        "Are you sure you want to log out of LingoBreeze?",
                        style: dialogTheme.textTheme.bodyLarge,
                      ),
                      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext), // Just close the dialog
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: dialogTheme.textTheme.bodyMedium?.color,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext); // Close the dialog first
                            context.read<AuthBloc>().add(LogoutRequested()); // Then trigger the logout event
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Highlights the destructive action
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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