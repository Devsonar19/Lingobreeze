import 'package:equatable/equatable.dart';

abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object> get props => [];
}

class FetchVocabulary extends VocabularyEvent {}

class AddNewWord extends VocabularyEvent {
  final String word;
  final String meaning;
  final String exampleSentence;

  const AddNewWord({
    required this.word,
    required this.meaning,
    required this.exampleSentence,
  });

  @override
  List<Object> get props => [word, meaning, exampleSentence];
}
class DeleteVocabularyWord extends VocabularyEvent {
  final String id;

  const DeleteVocabularyWord(this.id);

  @override
  List<Object> get props => [id];
}