import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_event.dart';
import '../bloc/vocabulary_state.dart';
import '../widgets/word_card_widget.dart';
import '../widgets/add_word_modal.dart'; // We will build this next!

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    // Kick off the Node.js API call as soon as the screen loads
    context.read<VocabularyBloc>().add(FetchVocabulary());
  }

  void _showAddWordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddWordModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VocabularyBloc, VocabularyState>(
        builder: (context, state) {
          if (state is VocabularyLoading || state is VocabularyInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          else if (state is VocabularyEmpty) {
            return _buildEmptyState();
          }

          else if (state is VocabularyLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<VocabularyBloc>().add(FetchVocabulary());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
                itemCount: state.words.length,
                itemBuilder: (context, index) {
                  return WordCardWidget(word: state.words[index]);
                },
              ),
            );
          }

          else if (state is VocabularyError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWordModal(context),
        backgroundColor: const Color(0xFF3498DB),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // The Assignment Requirement: Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.book_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "You haven't saved any words yet.",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddWordModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              "Add Your First Word",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}