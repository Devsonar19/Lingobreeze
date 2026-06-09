import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/glass_container.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_state.dart'; // NEW: Import the glass container

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // CRITICAL: Must be transparent
      backgroundColor: Colors.transparent,
      body: BlocBuilder<VocabularyBloc, VocabularyState>(
        builder: (context, state) {
          int totalWords = 0;
          if (state is VocabularyLoaded) {
            totalWords = state.words.length;
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                "Your Progress",
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildGlassStatCard(
                      context: context,
                      title: "Words Learned",
                      value: totalWords.toString(),
                      icon: Icons.library_books_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGlassStatCard(
                      context: context,
                      title: "Day Streak",
                      value: "1",
                      icon: Icons.local_fire_department_rounded,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // A wide, glass achievement panel
              GlassContainer(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_events_rounded, color: theme.primaryColor, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Consistency is Key", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            "Keep practicing daily to unlock new fluency achievements.",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // The helper method now returns a GlassContainer instead of a solid colored box
  Widget _buildGlassStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? theme.primaryColor, size: 36),
          const SizedBox(height: 20),
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}