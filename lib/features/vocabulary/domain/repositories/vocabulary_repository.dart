import '../entities/word_entity.dart';

abstract class VocabularyRepository {
  Future<List<WordEntity>> getWords();
  Future<void> addWord({
    required String word,
    required String meaning,
    required String exampleSentence,
  });
  Future<void> deleteWord(String id);
}