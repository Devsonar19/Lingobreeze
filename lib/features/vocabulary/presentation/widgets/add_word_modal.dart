import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_event.dart';
import '../../../../core/theme/glass_container.dart';

class AddWordModal extends StatefulWidget {
  const AddWordModal({super.key});

  @override
  State<AddWordModal> createState() => _AddWordModalState();
}

class _AddWordModalState extends State<AddWordModal> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _exampleController = TextEditingController();

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
        AddNewWord(
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

    // We wrap the whole thing in a Padding to lift it above the keyboard
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24, // Keep it slightly separated from the very top of the screen
      ),
      child: GlassContainer(
        padding: const EdgeInsets.all(32),
        // A slightly tighter border radius for the bottom sheet
        borderRadius: 32,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The little drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white30 : Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Add New Word",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              _buildFrostedTextField(
                controller: _wordController,
                label: "Word",
                icon: Icons.text_fields_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              _buildFrostedTextField(
                controller: _meaningController,
                label: "Meaning",
                icon: Icons.lightbulb_outline_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              _buildFrostedTextField(
                controller: _exampleController,
                label: "Example Sentence (Optional)",
                icon: Icons.chat_bubble_outline_rounded,
                isDark: isDark,
                isOptional: true,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: theme.primaryColor.withOpacity(0.5),
                ),
                child: const Text(
                  "Save Word",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16), // Extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrostedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: isOptional ? null : (val) => val != null && val.isNotEmpty ? null : "Required field",
    );
  }
}