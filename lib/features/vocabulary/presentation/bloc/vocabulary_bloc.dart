import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import 'vocabulary_event.dart';
import 'vocabulary_state.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final VocabularyRepository repository;

  VocabularyBloc({required this.repository}) : super(VocabularyInitial()) {
    on<FetchVocabulary>(_onFetchVocabulary);
    on<AddNewWord>(_onAddNewWord);
    on<DeleteVocabularyWord>(_onDeleteVocabularyWord);
    on<UpdateVocabularyWord>(_onUpdateVocabularyWord);
  }

  Future<void> _onFetchVocabulary(FetchVocabulary event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    try {
      final words = await repository.getWords();
      if (words.isEmpty) {
        emit(VocabularyEmpty());
      } else {
        emit(VocabularyLoaded(words));
      }
    } catch (e) {
      emit(VocabularyError("Failed to fetch words. Check your connection."));
    }
  }

  Future<void> _onAddNewWord(AddNewWord event, Emitter<VocabularyState> emit) async {
    try {
      await repository.addWord(
        word: event.word,
        meaning: event.meaning,
        exampleSentence: event.exampleSentence,
      );
      // Re-fetch the list after a successful save
      add(FetchVocabulary());
    } catch (e) {
      emit(VocabularyError("Failed to save word."));
    }
  }

  Future<void> _onDeleteVocabularyWord(DeleteVocabularyWord event, Emitter<VocabularyState> emit) async {
    try {
      await repository.deleteWord(event.id);
      add(FetchVocabulary()); // Refresh the list automatically
    } catch (e) {
      emit(const VocabularyError("Failed to delete word. Please try again."));
    }
  }

  Future<void> _onUpdateVocabularyWord(UpdateVocabularyWord event, Emitter<VocabularyState> emit) async {
    try {
      await repository.updateWord(
        id: event.id,
        word: event.word,
        meaning: event.meaning,
        exampleSentence: event.exampleSentence,
      );
      add(FetchVocabulary());
    } catch (e) {
      emit(const VocabularyError("Failed to update word."));
    }
  }
}