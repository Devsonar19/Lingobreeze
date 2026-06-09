import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/word_entity.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_event.dart';

class EditWordModal extends StatefulWidget {
  final WordEntity word;

  const EditWordModal({super.key, required this.word});

  @override
  State<EditWordModal> createState() => _EditWordModalState();
}

class _EditWordModalState extends State<EditWordModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _wordController;
  late TextEditingController _meaningController;
  late TextEditingController _exampleController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with the existing data
    _wordController = TextEditingController(text: widget.word.word);
    _meaningController = TextEditingController(text: widget.word.meaning);
    _exampleController = TextEditingController(text: widget.word.exampleSentence);
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<VocabularyBloc>().add(
        UpdateVocabularyWord(
          id: widget.word.id,
          word: _wordController.text.trim(),
          meaning: _meaningController.text.trim(),
          exampleSentence: _exampleController.text.trim(),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Edit Word",
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _wordController,
                label: "Word",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _meaningController,
                label: "Meaning",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _exampleController,
                label: "Example Sentence",
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "Update Word",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
      ),
      validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
    );
  }
}