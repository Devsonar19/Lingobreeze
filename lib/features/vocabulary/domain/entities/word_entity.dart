import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  final String id;
  final String word;
  final String meaning; // The translation/meaning pill
  final String exampleSentence; // Added based on your UI design!

  const WordEntity({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
  });

  @override
  List<Object?> get props => [id, word, meaning, exampleSentence];
}