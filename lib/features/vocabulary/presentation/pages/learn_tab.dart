import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_state.dart';
import '../../../../core/theme/glass_container.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  int _currentIndex = 0;
  bool _isShowingMeaning = false;

  void _nextCard(int totalWords) {
    setState(() {
      _isShowingMeaning = false;
      if (_currentIndex < totalWords - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
  }

  void _flipCard() {
    setState(() {
      _isShowingMeaning = !_isShowingMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // CRITICAL: Must be transparent so the MainHomeScreen background shows through!
      backgroundColor: Colors.transparent,
      body: BlocBuilder<VocabularyBloc, VocabularyState>(
        builder: (context, state) {
          if (state is VocabularyLoading || state is VocabularyInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VocabularyEmpty) {
            return Center(
              child: Text(
                "Add some words in the Home tab to start practicing!",
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is VocabularyLoaded) {
            final words = state.words;
            final currentWord = words[_currentIndex];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Card ${_currentIndex + 1} of ${words.length}",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // The Glass Flashcard
                  GestureDetector(
                    onTap: _flipCard,
                    child: GlassContainer(
                      padding: const EdgeInsets.all(32),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          key: ValueKey<bool>(_isShowingMeaning), // Forces animation on flip
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              _isShowingMeaning ? currentWord.meaning : currentWord.word,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_isShowingMeaning && currentWord.exampleSentence.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Divider(color: theme.dividerColor.withOpacity(0.2)),
                              const SizedBox(height: 24),
                              Text(
                                currentWord.exampleSentence,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app_rounded, size: 16, color: theme.hintColor),
                                const SizedBox(width: 8),
                                Text(
                                  "Tap to flip",
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Next Button
                  ElevatedButton(
                    onPressed: () => _nextCard(words.length),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      shadowColor: theme.primaryColor.withOpacity(0.5),
                    ),
                    child: const Text(
                      "Next Word",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}