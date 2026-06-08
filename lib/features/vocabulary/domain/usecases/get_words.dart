import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

class GetWords {
  final VocabularyRepository repository;

  GetWords(this.repository);

  Future<List<WordEntity>> call() async {
    return await repository.getWords();
  }
}