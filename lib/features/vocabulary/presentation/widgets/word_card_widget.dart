import 'package:flutter/material.dart';
import '../../domain/entities/word_entity.dart';

class WordCardWidget extends StatelessWidget {
  final WordEntity word;

  const WordCardWidget({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24), // Smooth, premium rounding
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Word and Speaker Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word.word,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 28),
                color: theme.textTheme.bodyMedium?.color,
                onPressed: () {
                  // Future: Wire up Text-To-Speech here
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // The Meaning Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              word.meaning,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          if (word.exampleSentence.isNotEmpty) ...[
            const SizedBox(height: 20),
            Divider(color: theme.dividerColor.withOpacity(isDark ? 0.1 : 0.2), height: 1),
            const SizedBox(height: 16),
            Text(
              word.exampleSentence,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.textTheme.bodyMedium?.color,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
