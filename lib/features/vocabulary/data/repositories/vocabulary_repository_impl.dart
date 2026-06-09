import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_remote_datasource.dart';
import '../models/word_model.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyRemoteDataSource remoteDataSource;

  VocabularyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WordEntity>> getWords() async {
    return await remoteDataSource.fetchWordsFromNode();
  }

  @override
  Future<void> addWord({
    required String word,
    required String meaning,
    required String exampleSentence,
  }) async {
    final newWord = WordModel(
      id: '', // Firebase assigns the ID automatically
      word: word,
      meaning: meaning,
      exampleSentence: exampleSentence,
    );
    await remoteDataSource.saveWordToFirebase(newWord);
  }

  @override
  Future<void> deleteWord(String id) async {
    await remoteDataSource.deleteWordFromFirebase(id);
  }

  @override
  Future<void> updateWord({
    required String id,
    required String word,
    required String meaning,
    required String exampleSentence,
  }) async {
    final updatedWord = WordModel(
      id: id,
      word: word,
      meaning: meaning,
      exampleSentence: exampleSentence,
    );
    await remoteDataSource.updateWordInFirebase(updatedWord);
  }
}