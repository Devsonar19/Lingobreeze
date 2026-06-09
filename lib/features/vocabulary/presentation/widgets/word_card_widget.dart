import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lingobreeze_app/core/theme/glass_container.dart';
import '../../domain/entities/word_entity.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_word_modal.dart';

class WordCardWidget extends StatelessWidget {
  final WordEntity word;

  const WordCardWidget({super.key, required this.word});

  void _showDeleteConfirmation(BuildContext context, WordEntity word) {
    final dialogTheme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: dialogTheme.cardColor,
          title: Text(
            "Delete Word",
            style: dialogTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to delete '${word.word}'? This cannot be undone.",
            style: dialogTheme.textTheme.bodyLarge,
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(color: dialogTheme.textTheme.bodyMedium?.color, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 1. Close the dialog
                Navigator.pop(dialogContext);
                // 2. Trigger the delete event in the BLoC using the word's ID
                context.read<VocabularyBloc>().add(DeleteVocabularyWord(word.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  word.word,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevents overflow if the word is too long
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NEW: Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded, size: 28),
                    color: theme.primaryColor,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>   EditWordModal(word: word),
                      );
                    },
                  ),
                  // Existing Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 26),
                    color: Colors.redAccent.withOpacity(0.8),
                    onPressed: () {
                      _showDeleteConfirmation(context, word);
                    },
                  ),
                ],
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


