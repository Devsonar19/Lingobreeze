import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_remote_datasource.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyRemoteDataSource remoteDataSource;

  VocabularyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WordEntity>> getWords() async {
    return await remoteDataSource.getWords();
  }

  @override
  Future<void> addWord({
    required String word,
    required String meaning,
    required String exampleSentence,
  }) async {
    await remoteDataSource.addWord(word, meaning, exampleSentence);
  }

  @override
  Future<void> updateWord({
    required String id,
    required String word,
    required String meaning,
    required String exampleSentence,
  }) async {
    await remoteDataSource.updateWord(id, word, meaning, exampleSentence);
  }

  @override
  Future<void> deleteWord(String id) async {
    await remoteDataSource.deleteWord(id);
  }
}