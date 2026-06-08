import '../repositories/vocabulary_repository.dart';

class AddWord {
  final VocabularyRepository repository;

  AddWord(this.repository);

  Future<void> call({
    required String word,
    required String meaning,
    required String exampleSentence,
  }) async {
    await repository.addWord(
      word: word,
      meaning: meaning,
      exampleSentence: exampleSentence,
    );
  }
}